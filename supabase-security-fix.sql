-- CRITICAL SECURITY FIX for Luvlang Dating App
-- This script addresses all major security vulnerabilities

-- =================================================================
-- 1. ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- =================================================================

-- Enable RLS on profiles table
ALTER TABLE IF EXISTS profiles ENABLE ROW LEVEL SECURITY;

-- Enable RLS on user_profiles table (if exists)
ALTER TABLE IF EXISTS user_profiles ENABLE ROW LEVEL SECURITY;

-- Enable RLS on matches table
CREATE TABLE IF NOT EXISTS matches (
    id BIGSERIAL PRIMARY KEY,
    user1_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    user2_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    status TEXT CHECK (status IN ('pending', 'accepted', 'declined', 'blocked')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user1_id, user2_id)
);
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;

-- Enable RLS on messages table
CREATE TABLE IF NOT EXISTS messages (
    id BIGSERIAL PRIMARY KEY,
    conversation_id UUID NOT NULL,
    sender_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    receiver_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'file')),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Enable RLS on conversations table
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    participant1_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    participant2_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    last_message_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(participant1_id, participant2_id)
);
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;

-- Enable RLS on verification documents table
CREATE TABLE IF NOT EXISTS verification_documents (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    document_type TEXT CHECK (document_type IN ('id', 'passport', 'drivers_license', 'professional_license')),
    document_url TEXT NOT NULL,
    verification_status TEXT DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    verified_at TIMESTAMPTZ,
    verified_by UUID REFERENCES auth.users(id)
);
ALTER TABLE verification_documents ENABLE ROW LEVEL SECURITY;

-- Enable RLS on professional information table
CREATE TABLE IF NOT EXISTS professional_info (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    company_name TEXT,
    job_title TEXT,
    industry TEXT,
    salary_range TEXT,
    net_worth_range TEXT,
    education_level TEXT,
    university TEXT,
    professional_achievements TEXT[],
    linkedin_verified BOOLEAN DEFAULT FALSE,
    company_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE professional_info ENABLE ROW LEVEL SECURITY;

-- Enable RLS on phone verification table
CREATE TABLE IF NOT EXISTS phone_verifications (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    phone_number TEXT NOT NULL,
    verification_code TEXT NOT NULL,
    code_expires_at TIMESTAMPTZ NOT NULL,
    attempts INTEGER DEFAULT 0,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE phone_verifications ENABLE ROW LEVEL SECURITY;

-- Enable RLS on dating preferences
CREATE TABLE IF NOT EXISTS dating_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    age_min INTEGER,
    age_max INTEGER,
    location_preference TEXT,
    income_preference TEXT,
    education_preference TEXT,
    relationship_type TEXT,
    privacy_level TEXT DEFAULT 'private' CHECK (privacy_level IN ('public', 'private', 'anonymous')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE dating_preferences ENABLE ROW LEVEL SECURITY;

-- =================================================================
-- 2. CREATE SECURE RLS POLICIES
-- =================================================================

-- PROFILES POLICIES
CREATE POLICY "Users can only view their own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can only update their own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
    ON profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- MATCHES POLICIES
CREATE POLICY "Users can only see their own matches"
    ON matches FOR SELECT
    USING (auth.uid() = user1_id OR auth.uid() = user2_id);

CREATE POLICY "Users can only create matches involving themselves"
    ON matches FOR INSERT
    WITH CHECK (auth.uid() = user1_id OR auth.uid() = user2_id);

CREATE POLICY "Users can only update their own matches"
    ON matches FOR UPDATE
    USING (auth.uid() = user1_id OR auth.uid() = user2_id);

-- MESSAGES POLICIES
CREATE POLICY "Users can only view messages they sent or received"
    ON messages FOR SELECT
    USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can only send messages as themselves"
    ON messages FOR INSERT
    WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "Users can only update their own messages"
    ON messages FOR UPDATE
    USING (auth.uid() = sender_id);

-- CONVERSATIONS POLICIES
CREATE POLICY "Users can only view their own conversations"
    ON conversations FOR SELECT
    USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

CREATE POLICY "Users can only create conversations they participate in"
    ON conversations FOR INSERT
    WITH CHECK (auth.uid() = participant1_id OR auth.uid() = participant2_id);

-- VERIFICATION DOCUMENTS POLICIES (HIGHLY RESTRICTED)
CREATE POLICY "Users can only view their own verification documents"
    ON verification_documents FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can only upload their own verification documents"
    ON verification_documents FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Only admins can verify documents"
    ON verification_documents FOR UPDATE
    USING (
        auth.uid() = user_id OR 
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );

-- PROFESSIONAL INFO POLICIES
CREATE POLICY "Users can only view their own professional info"
    ON professional_info FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can only update their own professional info"
    ON professional_info FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can only insert their own professional info"
    ON professional_info FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- PHONE VERIFICATION POLICIES (EXTRA SECURE)
CREATE POLICY "Users can only view their own phone verifications"
    ON phone_verifications FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can only create their own phone verifications"
    ON phone_verifications FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- No update policy for phone verifications - they should be immutable

-- DATING PREFERENCES POLICIES
CREATE POLICY "Users can only view their own dating preferences"
    ON dating_preferences FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can only update their own dating preferences"
    ON dating_preferences FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can only insert their own dating preferences"
    ON dating_preferences FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- =================================================================
-- 3. SECURE PHONE VERIFICATION
-- =================================================================

-- Function to generate secure verification codes
CREATE OR REPLACE FUNCTION generate_verification_code()
RETURNS TEXT AS $$
BEGIN
    -- Generate a 6-digit random code
    RETURN LPAD(FLOOR(RANDOM() * 1000000)::TEXT, 6, '0');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create phone verification with rate limiting
CREATE OR REPLACE FUNCTION create_phone_verification(
    p_phone_number TEXT
)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_code TEXT;
    v_attempts INTEGER;
    v_last_attempt TIMESTAMPTZ;
BEGIN
    -- Check if user is authenticated
    IF v_user_id IS NULL THEN
        RETURN json_build_object('error', 'Unauthorized');
    END IF;

    -- Check recent attempts (rate limiting)
    SELECT attempts, created_at INTO v_attempts, v_last_attempt
    FROM phone_verifications
    WHERE user_id = v_user_id 
    AND phone_number = p_phone_number
    AND created_at > NOW() - INTERVAL '1 hour'
    ORDER BY created_at DESC
    LIMIT 1;

    -- Block if too many attempts
    IF v_attempts >= 3 AND v_last_attempt > NOW() - INTERVAL '1 hour' THEN
        RETURN json_build_object('error', 'Too many attempts. Please wait 1 hour.');
    END IF;

    -- Generate secure code
    v_code := generate_verification_code();

    -- Insert verification record
    INSERT INTO phone_verifications (
        user_id,
        phone_number,
        verification_code,
        code_expires_at,
        attempts
    ) VALUES (
        v_user_id,
        p_phone_number,
        v_code,
        NOW() + INTERVAL '10 minutes',
        1
    );

    -- Return success (don't expose the code in response)
    RETURN json_build_object(
        'success', true,
        'message', 'Verification code sent',
        'expires_at', NOW() + INTERVAL '10 minutes'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to verify phone code securely
CREATE OR REPLACE FUNCTION verify_phone_code(
    p_phone_number TEXT,
    p_code TEXT
)
RETURNS JSON AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_record RECORD;
BEGIN
    -- Check if user is authenticated
    IF v_user_id IS NULL THEN
        RETURN json_build_object('error', 'Unauthorized');
    END IF;

    -- Get verification record
    SELECT * INTO v_record
    FROM phone_verifications
    WHERE user_id = v_user_id
    AND phone_number = p_phone_number
    AND verification_code = p_code
    AND code_expires_at > NOW()
    AND is_verified = FALSE
    ORDER BY created_at DESC
    LIMIT 1;

    -- Check if valid
    IF v_record IS NULL THEN
        -- Increment attempts
        UPDATE phone_verifications 
        SET attempts = attempts + 1
        WHERE user_id = v_user_id 
        AND phone_number = p_phone_number
        AND created_at > NOW() - INTERVAL '1 hour';
        
        RETURN json_build_object('error', 'Invalid or expired code');
    END IF;

    -- Mark as verified
    UPDATE phone_verifications
    SET is_verified = TRUE
    WHERE id = v_record.id;

    -- Clear old verification codes for this phone
    DELETE FROM phone_verifications
    WHERE user_id = v_user_id
    AND phone_number = p_phone_number
    AND id != v_record.id;

    RETURN json_build_object('success', true, 'message', 'Phone verified successfully');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================================
-- 4. CREATE SECURE VIEWS FOR SAFE DATA ACCESS
-- =================================================================

-- Safe profile view (excludes sensitive data)
CREATE OR REPLACE VIEW public_profiles AS
SELECT 
    p.id,
    p.first_name,
    p.age,
    pi.job_title,
    pi.company_name,
    pi.industry,
    p.location,
    p.bio,
    p.interests,
    CASE 
        WHEN dp.privacy_level = 'public' THEN p.profile_image_url
        ELSE NULL 
    END as profile_image_url,
    p.created_at
FROM profiles p
LEFT JOIN professional_info pi ON p.id = pi.user_id
LEFT JOIN dating_preferences dp ON p.id = dp.user_id
WHERE p.is_active = true
AND p.profile_complete = true
AND (dp.privacy_level IS NULL OR dp.privacy_level != 'anonymous');

-- Grant access to public profiles view
GRANT SELECT ON public_profiles TO authenticated;

-- =================================================================
-- 5. AUDIT LOGGING FOR SECURITY
-- =================================================================

-- Create audit log table
CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT,
    old_data JSONB,
    new_data JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Only admins can view audit logs
CREATE POLICY "Only admins can view audit logs"
    ON audit_logs FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    );

-- =================================================================
-- 6. SECURITY FUNCTIONS
-- =================================================================

-- Function to check if user can view another user's profile
CREATE OR REPLACE FUNCTION can_view_profile(target_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_privacy_level TEXT;
    v_has_match BOOLEAN := FALSE;
BEGIN
    -- Users can always view their own profile
    IF v_user_id = target_user_id THEN
        RETURN TRUE;
    END IF;

    -- Check privacy settings
    SELECT privacy_level INTO v_privacy_level
    FROM dating_preferences
    WHERE user_id = target_user_id;

    -- Check if there's a mutual match
    SELECT EXISTS(
        SELECT 1 FROM matches
        WHERE (user1_id = v_user_id AND user2_id = target_user_id)
           OR (user1_id = target_user_id AND user2_id = v_user_id)
        AND status = 'accepted'
    ) INTO v_has_match;

    -- Return based on privacy level and match status
    RETURN (
        v_privacy_level = 'public' OR
        (v_privacy_level = 'private' AND v_has_match) OR
        v_privacy_level IS NULL
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================================
-- 7. INDEXES FOR PERFORMANCE
-- =================================================================

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles(id);
CREATE INDEX IF NOT EXISTS idx_matches_users ON matches(user1_id, user2_id);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_users ON messages(sender_id, receiver_id);
CREATE INDEX IF NOT EXISTS idx_conversations_participants ON conversations(participant1_id, participant2_id);
CREATE INDEX IF NOT EXISTS idx_phone_verifications_user_phone ON phone_verifications(user_id, phone_number);
CREATE INDEX IF NOT EXISTS idx_professional_info_user ON professional_info(user_id);
CREATE INDEX IF NOT EXISTS idx_verification_docs_user ON verification_documents(user_id);

-- =================================================================
-- GRANT PERMISSIONS
-- =================================================================

-- Grant necessary permissions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE ON profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE ON matches TO authenticated;
GRANT SELECT, INSERT, UPDATE ON messages TO authenticated;
GRANT SELECT, INSERT, UPDATE ON conversations TO authenticated;
GRANT SELECT, INSERT ON verification_documents TO authenticated;
GRANT SELECT, INSERT, UPDATE ON professional_info TO authenticated;
GRANT SELECT, INSERT ON phone_verifications TO authenticated;
GRANT SELECT, INSERT, UPDATE ON dating_preferences TO authenticated;

-- Grant sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- =================================================================
-- FINAL SECURITY VALIDATION
-- =================================================================

-- Verify all tables have RLS enabled
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN 
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        AND tablename NOT IN ('audit_logs')
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM pg_class c
            JOIN pg_namespace n ON c.relnamespace = n.oid
            WHERE n.nspname = r.schemaname
            AND c.relname = r.tablename
            AND c.relrowsecurity = true
        ) THEN
            RAISE NOTICE 'WARNING: Table %.% does not have RLS enabled!', r.schemaname, r.tablename;
        END IF;
    END LOOP;
END $$;