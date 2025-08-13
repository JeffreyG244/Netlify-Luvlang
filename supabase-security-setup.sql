-- Security Events Table for Monitoring
CREATE TABLE IF NOT EXISTS security_events (
    id BIGSERIAL PRIMARY KEY,
    event_type TEXT NOT NULL CHECK (event_type IN ('login_attempt', 'password_reset', 'account_creation', 'suspicious_activity')),
    user_id UUID REFERENCES auth.users(id),
    ip_address INET,
    user_agent TEXT,
    success BOOLEAN NOT NULL DEFAULT false,
    metadata JSONB,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS on security_events
ALTER TABLE security_events ENABLE ROW LEVEL SECURITY;

-- Only allow service role to read/write security events
CREATE POLICY "Service role can manage security events" ON security_events
    FOR ALL USING (auth.role() = 'service_role');

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_security_events_timestamp ON security_events(timestamp);
CREATE INDEX IF NOT EXISTS idx_security_events_ip ON security_events(ip_address);
CREATE INDEX IF NOT EXISTS idx_security_events_type ON security_events(event_type);
CREATE INDEX IF NOT EXISTS idx_security_events_user ON security_events(user_id);

-- Backup Configuration Table
CREATE TABLE IF NOT EXISTS backup_config (
    id BIGSERIAL PRIMARY KEY,
    backup_type TEXT NOT NULL CHECK (backup_type IN ('daily', 'weekly', 'monthly')),
    last_backup TIMESTAMPTZ,
    next_backup TIMESTAMPTZ,
    status TEXT DEFAULT 'pending',
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on backup_config
ALTER TABLE backup_config ENABLE ROW LEVEL SECURITY;

-- Only allow service role to manage backups
CREATE POLICY "Service role can manage backups" ON backup_config
    FOR ALL USING (auth.role() = 'service_role');

-- Environment Variables Table (for production config)
CREATE TABLE IF NOT EXISTS app_config (
    id BIGSERIAL PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT,
    is_secret BOOLEAN DEFAULT false,
    environment TEXT DEFAULT 'production',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on app_config
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;

-- Only allow service role to manage config
CREATE POLICY "Service role can manage config" ON app_config
    FOR ALL USING (auth.role() = 'service_role');

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_backup_config_updated_at BEFORE UPDATE ON backup_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_app_config_updated_at BEFORE UPDATE ON app_config
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert initial backup configuration
INSERT INTO backup_config (backup_type, next_backup) VALUES
('daily', NOW() + INTERVAL '1 day'),
('weekly', NOW() + INTERVAL '1 week'),
('monthly', NOW() + INTERVAL '1 month')
ON CONFLICT DO NOTHING;

-- Insert production environment variables
INSERT INTO app_config (key, value, is_secret, environment) VALUES
('SITE_URL', 'https://luvlang.org', false, 'production'),
('APP_NAME', 'Luvlang', false, 'production'),
('MAX_LOGIN_ATTEMPTS', '5', false, 'production'),
('LOGIN_ATTEMPT_WINDOW', '3600', false, 'production'),
('PASSWORD_MIN_LENGTH', '8', false, 'production'),
('ENABLE_MFA', 'true', false, 'production')
ON CONFLICT (key) DO NOTHING;

-- Create a view for monitoring dashboard
CREATE OR REPLACE VIEW security_dashboard AS
SELECT 
    DATE_TRUNC('hour', timestamp) as hour,
    event_type,
    COUNT(*) as event_count,
    COUNT(*) FILTER (WHERE success = false) as failed_count,
    COUNT(DISTINCT ip_address) as unique_ips,
    COUNT(DISTINCT user_id) as unique_users
FROM security_events
WHERE timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', timestamp), event_type
ORDER BY hour DESC;

-- Grant permissions for the view
GRANT SELECT ON security_dashboard TO service_role;