-- SECURE PAYMENT SYSTEM for Luvlang Dating App
-- This script creates secure payment processing infrastructure

-- =================================================================
-- 1. PAYMENT TRANSACTIONS TABLE (HIGHLY SECURE)
-- =================================================================

CREATE TABLE IF NOT EXISTS payment_transactions (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_id TEXT NOT NULL,
    paypal_transaction_id TEXT UNIQUE NOT NULL,
    paypal_capture_id TEXT,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    currency TEXT NOT NULL DEFAULT 'USD',
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_method TEXT NOT NULL DEFAULT 'paypal',
    failure_reason TEXT,
    refund_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    refunded_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on payment transactions
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;

-- Users can only see their own transactions
CREATE POLICY "Users can view their own payment transactions"
    ON payment_transactions FOR SELECT
    USING (auth.uid() = user_id);

-- Only service role can insert transactions (from backend)
CREATE POLICY "Service role can insert payment transactions"
    ON payment_transactions FOR INSERT
    WITH CHECK (auth.role() = 'service_role');

-- Only service role can update transactions (from PayPal webhooks)
CREATE POLICY "Service role can update payment transactions"
    ON payment_transactions FOR UPDATE
    USING (auth.role() = 'service_role');

-- Admins can view all transactions
CREATE POLICY "Admins can view all payment transactions"
    ON payment_transactions FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );

-- =================================================================
-- 2. SUBSCRIPTIONS TABLE (SECURE)
-- =================================================================

CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_id TEXT NOT NULL,
    paypal_subscription_id TEXT UNIQUE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('active', 'cancelled', 'expired', 'pending', 'suspended')),
    current_period_start TIMESTAMPTZ NOT NULL,
    current_period_end TIMESTAMPTZ NOT NULL,
    cancel_at_period_end BOOLEAN DEFAULT FALSE,
    cancelled_at TIMESTAMPTZ,
    trial_start TIMESTAMPTZ,
    trial_end TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on subscriptions
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Users can only see their own subscriptions
CREATE POLICY "Users can view their own subscriptions"
    ON subscriptions FOR SELECT
    USING (auth.uid() = user_id);

-- Users can update their own subscription (for cancellation)
CREATE POLICY "Users can cancel their own subscriptions"
    ON subscriptions FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id AND cancel_at_period_end = TRUE);

-- Service role can manage all subscriptions
CREATE POLICY "Service role can manage subscriptions"
    ON subscriptions FOR ALL
    USING (auth.role() = 'service_role');

-- Admins can view all subscriptions
CREATE POLICY "Admins can view all subscriptions"
    ON subscriptions FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );

-- =================================================================
-- 3. PAYMENT PLANS TABLE (READ-ONLY)
-- =================================================================

CREATE TABLE IF NOT EXISTS payment_plans (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    currency TEXT NOT NULL DEFAULT 'USD',
    interval_type TEXT NOT NULL CHECK (interval_type IN ('month', 'year')),
    interval_count INTEGER NOT NULL DEFAULT 1 CHECK (interval_count > 0),
    features JSONB,
    is_popular BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert payment plans
INSERT INTO payment_plans (id, name, description, price, interval_type, features, is_popular) VALUES
('executive-monthly', 'Executive Monthly', 'Premium features for executives', 99.99, 'month', 
 '["Unlimited premium matches", "Advanced search filters", "Priority profile visibility", "Video chat capabilities", "Professional verification", "Concierge matching service"]', 
 false),
('executive-yearly', 'Executive Annual', 'Best value for executives', 999.99, 'year',
 '["All Executive Monthly features", "2 months free (12 for 10)", "Exclusive executive events", "Personal dating advisor", "Premium venue recommendations", "Identity verification included"]',
 true),
('entrepreneur-monthly', 'Entrepreneur Monthly', 'For startup founders and entrepreneurs', 199.99, 'month',
 '["All Executive features", "Investor network access", "Business partnership matching", "Startup event invitations", "Mentor connections", "IPO/Exit networking"]',
 false)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    features = EXCLUDED.features,
    is_popular = EXCLUDED.is_popular,
    updated_at = NOW();

-- Payment plans are readable by authenticated users
GRANT SELECT ON payment_plans TO authenticated;

-- =================================================================
-- 4. PAYMENT WEBHOOKS TABLE (SECURITY LOGGING)
-- =================================================================

CREATE TABLE IF NOT EXISTS payment_webhooks (
    id BIGSERIAL PRIMARY KEY,
    webhook_id TEXT UNIQUE NOT NULL,
    event_type TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    summary TEXT,
    resource_id TEXT,
    parent_payment TEXT,
    webhook_data JSONB NOT NULL,
    processed BOOLEAN DEFAULT FALSE,
    processing_error TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    processed_at TIMESTAMPTZ
);

-- Enable RLS on webhooks
ALTER TABLE payment_webhooks ENABLE ROW LEVEL SECURITY;

-- Only service role can manage webhooks
CREATE POLICY "Service role can manage payment webhooks"
    ON payment_webhooks FOR ALL
    USING (auth.role() = 'service_role');

-- Admins can view webhook logs
CREATE POLICY "Admins can view payment webhooks"
    ON payment_webhooks FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );

-- =================================================================
-- 5. SECURE PAYMENT FUNCTIONS
-- =================================================================

-- Function to get active subscription
CREATE OR REPLACE FUNCTION get_active_subscription(p_user_id UUID)
RETURNS TABLE (
    subscription_id UUID,
    plan_id TEXT,
    status TEXT,
    current_period_end TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id,
        s.plan_id,
        s.status,
        s.current_period_end
    FROM subscriptions s
    WHERE s.user_id = p_user_id
    AND s.status = 'active'
    AND s.current_period_end > NOW()
    ORDER BY s.current_period_end DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user has premium access
CREATE OR REPLACE FUNCTION has_premium_access(p_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_has_access BOOLEAN := FALSE;
BEGIN
    SELECT EXISTS (
        SELECT 1 FROM subscriptions s
        WHERE s.user_id = p_user_id
        AND s.status = 'active'
        AND s.current_period_end > NOW()
    ) INTO v_has_access;
    
    RETURN v_has_access;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to calculate monthly revenue (admin only)
CREATE OR REPLACE FUNCTION calculate_monthly_revenue()
RETURNS DECIMAL AS $$
DECLARE
    v_revenue DECIMAL := 0;
    v_user_id UUID := auth.uid();
BEGIN
    -- Check if user is admin
    IF NOT EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = v_user_id 
        AND role = 'admin'
    ) THEN
        RAISE EXCEPTION 'Unauthorized: Admin access required';
    END IF;
    
    SELECT COALESCE(SUM(amount), 0) INTO v_revenue
    FROM payment_transactions
    WHERE status = 'completed'
    AND created_at >= DATE_TRUNC('month', NOW())
    AND created_at < DATE_TRUNC('month', NOW()) + INTERVAL '1 month';
    
    RETURN v_revenue;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to process payment completion
CREATE OR REPLACE FUNCTION process_payment_completion(
    p_transaction_id TEXT,
    p_paypal_capture_id TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
    v_transaction RECORD;
    v_period_end TIMESTAMPTZ;
BEGIN
    -- Get transaction details
    SELECT * INTO v_transaction
    FROM payment_transactions
    WHERE paypal_transaction_id = p_transaction_id
    AND status = 'pending';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Transaction not found or already processed';
    END IF;
    
    -- Update transaction status
    UPDATE payment_transactions
    SET 
        status = 'completed',
        paypal_capture_id = p_paypal_capture_id,
        completed_at = NOW(),
        updated_at = NOW()
    WHERE paypal_transaction_id = p_transaction_id;
    
    -- Calculate subscription period
    SELECT 
        CASE 
            WHEN pp.interval_type = 'month' THEN NOW() + (pp.interval_count || ' month')::INTERVAL
            WHEN pp.interval_type = 'year' THEN NOW() + (pp.interval_count || ' year')::INTERVAL
            ELSE NOW() + INTERVAL '1 month'
        END INTO v_period_end
    FROM payment_plans pp
    WHERE pp.id = v_transaction.plan_id;
    
    -- Create or update subscription
    INSERT INTO subscriptions (
        user_id,
        plan_id,
        paypal_subscription_id,
        status,
        current_period_start,
        current_period_end,
        created_at,
        updated_at
    ) VALUES (
        v_transaction.user_id,
        v_transaction.plan_id,
        p_transaction_id,
        'active',
        NOW(),
        v_period_end,
        NOW(),
        NOW()
    ) ON CONFLICT (paypal_subscription_id) DO UPDATE SET
        status = 'active',
        current_period_end = v_period_end,
        updated_at = NOW();
    
    -- Update user profile
    UPDATE profiles
    SET 
        membership_type = 'premium',
        membership_plan = v_transaction.plan_id,
        premium_since = COALESCE(premium_since, NOW()),
        updated_at = NOW()
    WHERE id = v_transaction.user_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================================
-- 6. PAYMENT SECURITY TRIGGERS
-- =================================================================

-- Trigger to log payment changes
CREATE OR REPLACE FUNCTION log_payment_changes()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (
        user_id,
        action,
        table_name,
        record_id,
        old_data,
        new_data,
        created_at
    ) VALUES (
        COALESCE(NEW.user_id, OLD.user_id),
        TG_OP,
        'payment_transactions',
        COALESCE(NEW.id::text, OLD.id::text),
        to_jsonb(OLD),
        to_jsonb(NEW),
        NOW()
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create payment audit trigger
CREATE TRIGGER payment_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON payment_transactions
    FOR EACH ROW EXECUTE FUNCTION log_payment_changes();

-- Trigger to update subscription timestamps
CREATE OR REPLACE FUNCTION update_subscription_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER subscription_update_trigger
    BEFORE UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_subscription_timestamp();

-- =================================================================
-- 7. PAYMENT SECURITY INDEXES
-- =================================================================

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_payment_transactions_user_id ON payment_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_status ON payment_transactions(status);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_paypal_id ON payment_transactions(paypal_transaction_id);
CREATE INDEX IF NOT EXISTS idx_payment_transactions_created_at ON payment_transactions(created_at);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_period_end ON subscriptions(current_period_end);

CREATE INDEX IF NOT EXISTS idx_payment_webhooks_webhook_id ON payment_webhooks(webhook_id);
CREATE INDEX IF NOT EXISTS idx_payment_webhooks_processed ON payment_webhooks(processed);

-- =================================================================
-- 8. GRANT PERMISSIONS
-- =================================================================

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON payment_plans TO authenticated;
GRANT SELECT ON payment_transactions TO authenticated;
GRANT SELECT ON subscriptions TO authenticated;

-- Grant sequence permissions
GRANT USAGE, SELECT ON SEQUENCE payment_transactions_id_seq TO service_role;
GRANT USAGE, SELECT ON SEQUENCE payment_webhooks_id_seq TO service_role;

-- Grant function execution permissions
GRANT EXECUTE ON FUNCTION get_active_subscription(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION has_premium_access(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_monthly_revenue() TO authenticated;
GRANT EXECUTE ON FUNCTION process_payment_completion(TEXT, TEXT) TO service_role;

-- =================================================================
-- 9. PAYMENT SECURITY VALIDATION
-- =================================================================

-- Validate all payment tables have RLS enabled
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN 
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        AND tablename IN ('payment_transactions', 'subscriptions', 'payment_webhooks')
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM pg_class c
            JOIN pg_namespace n ON c.relnamespace = n.oid
            WHERE n.nspname = r.schemaname
            AND c.relname = r.tablename
            AND c.relrowsecurity = true
        ) THEN
            RAISE NOTICE 'WARNING: Payment table %.% does not have RLS enabled!', r.schemaname, r.tablename;
        END IF;
    END LOOP;
END $$;