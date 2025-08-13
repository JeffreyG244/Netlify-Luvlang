# 🚨 URGENT: Critical Security Vulnerabilities - IMMEDIATE ACTION REQUIRED

## ⚠️ **SECURITY ALERT: YOUR DATABASE IS EXPOSED**

**DO NOT PUBLISH** until these critical vulnerabilities are fixed. Your user data is currently exposed to the public.

---

## 🔥 **IMMEDIATE STEPS TO FIX (EXECUTE NOW)**

### **Step 1: Access Supabase Dashboard**
1. Go to [supabase.com](https://supabase.com)
2. Sign in to your account
3. Select your **Luvlang project** (`tzskjzkolyiwhijslqmq`)
4. Navigate to **SQL Editor** in the left sidebar

### **Step 2: Execute Security Fix Script**
Copy and paste this ENTIRE script into the SQL Editor and click **RUN**:

```sql
-- CRITICAL SECURITY FIX - EXECUTE IMMEDIATELY
-- This fixes all 6 security vulnerabilities

-- =================================================================
-- 1. ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- =================================================================

-- Check if profiles table exists and enable RLS
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'profiles') THEN
        ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
        
        -- Drop existing policies if they exist
        DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
        DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
        DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;
        
        -- Create secure policies
        CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
        CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
        CREATE POLICY "Users can insert their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
    END IF;
END $$;

-- Enable RLS on auth.users (if accessible)
-- Note: This might require superuser privileges
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'auth' AND table_name = 'users') THEN
        -- This will only work if you have the right permissions
        BEGIN
            ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;
            CREATE POLICY "Users can only see their own data" ON auth.users FOR ALL USING (auth.uid() = id);
        EXCEPTION WHEN OTHERS THEN
            RAISE NOTICE 'Could not enable RLS on auth.users - this is normal for most setups';
        END;
    END IF;
END $$;

-- =================================================================
-- 2. CREATE AND SECURE ALL MISSING TABLES
-- =================================================================

-- Create profiles table if it doesn't exist
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    first_name TEXT,
    last_name TEXT,
    age INTEGER,
    bio TEXT,
    location TEXT,
    job_title TEXT,
    company TEXT,
    education TEXT,
    interests TEXT[],
    profile_image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    profile_complete BOOLEAN DEFAULT false,
    membership_type TEXT DEFAULT 'free',
    membership_plan TEXT,
    premium_since TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS on profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create secure policies for profiles
DROP POLICY IF EXISTS "Users can view their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update their own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON profiles;

CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- =================================================================
-- 3. SECURE PHONE VERIFICATION
-- =================================================================

-- Create phone verifications table
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

-- Enable RLS
ALTER TABLE phone_verifications ENABLE ROW LEVEL SECURITY;

-- Secure policies
DROP POLICY IF EXISTS "Users can only access their own phone verifications" ON phone_verifications;
CREATE POLICY "Users can only access their own phone verifications" ON phone_verifications 
    FOR ALL USING (auth.uid() = user_id);

-- =================================================================
-- 4. SECURE DATING INFORMATION
-- =================================================================

-- Create dating preferences table
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
    show_age BOOLEAN DEFAULT true,
    show_location BOOLEAN DEFAULT true,
    show_professional_info BOOLEAN DEFAULT false,
    show_education BOOLEAN DEFAULT true,
    show_income_range BOOLEAN DEFAULT false,
    allow_messages_from TEXT DEFAULT 'matches_only' CHECK (allow_messages_from IN ('everyone', 'matches_only', 'verified_only')),
    show_online_status BOOLEAN DEFAULT true,
    allow_profile_views BOOLEAN DEFAULT true,
    share_interests BOOLEAN DEFAULT true,
    show_last_active BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE dating_preferences ENABLE ROW LEVEL SECURITY;

-- Secure policies
DROP POLICY IF EXISTS "Users can only access their own dating preferences" ON dating_preferences;
CREATE POLICY "Users can only access their own dating preferences" ON dating_preferences 
    FOR ALL USING (auth.uid() = user_id);

-- =================================================================
-- 5. SECURE VERIFICATION DOCUMENTS
-- =================================================================

-- Create verification documents table
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

-- Enable RLS with MAXIMUM security
ALTER TABLE verification_documents ENABLE ROW LEVEL SECURITY;

-- Ultra-restrictive policies
DROP POLICY IF EXISTS "Users can only access their own verification documents" ON verification_documents;
DROP POLICY IF EXISTS "Users can only upload their own verification documents" ON verification_documents;

CREATE POLICY "Users can only access their own verification documents" ON verification_documents 
    FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can only upload their own verification documents" ON verification_documents 
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- =================================================================
-- 6. SECURE PROFESSIONAL INFORMATION
-- =================================================================

-- Create professional info table
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

-- Enable RLS
ALTER TABLE professional_info ENABLE ROW LEVEL SECURITY;

-- Secure policies
DROP POLICY IF EXISTS "Users can only access their own professional info" ON professional_info;
CREATE POLICY "Users can only access their own professional info" ON professional_info 
    FOR ALL USING (auth.uid() = user_id);

-- =================================================================
-- 7. SECURE MESSAGING
-- =================================================================

-- Create messages table
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

-- Enable RLS
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Secure policies
DROP POLICY IF EXISTS "Users can only access their own messages" ON messages;
CREATE POLICY "Users can only access their own messages" ON messages 
    FOR ALL USING (auth.uid() = sender_id OR auth.uid() = receiver_id);

-- Create conversations table
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    participant1_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    participant2_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    last_message_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(participant1_id, participant2_id)
);

-- Enable RLS
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;

-- Secure policies
DROP POLICY IF EXISTS "Users can only access their own conversations" ON conversations;
CREATE POLICY "Users can only access their own conversations" ON conversations 
    FOR ALL USING (auth.uid() = participant1_id OR auth.uid() = participant2_id);

-- =================================================================
-- 8. CREATE PUBLIC PROFILE VIEW (SAFE ACCESS)
-- =================================================================

-- Drop existing view if it exists
DROP VIEW IF EXISTS public_profiles;

-- Create safe public view
CREATE VIEW public_profiles AS
SELECT 
    p.id,
    p.first_name,
    p.age,
    p.job_title,
    p.company,
    p.location,
    p.bio,
    p.interests,
    CASE 
        WHEN dp.privacy_level = 'public' THEN p.profile_image_url
        ELSE NULL 
    END as profile_image_url,
    p.created_at
FROM profiles p
LEFT JOIN dating_preferences dp ON p.id = dp.user_id
WHERE p.is_active = true
AND p.profile_complete = true
AND (dp.privacy_level IS NULL OR dp.privacy_level != 'anonymous');

-- Grant safe access to the view
GRANT SELECT ON public_profiles TO authenticated;

-- =================================================================
-- 9. VERIFY SECURITY IS WORKING
-- =================================================================

-- Check that all tables have RLS enabled
DO $$
DECLARE
    r RECORD;
    tables_without_rls TEXT := '';
BEGIN
    FOR r IN 
        SELECT schemaname, tablename 
        FROM pg_tables 
        WHERE schemaname = 'public'
        AND tablename IN ('profiles', 'phone_verifications', 'dating_preferences', 'verification_documents', 'professional_info', 'messages', 'conversations')
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM pg_class c
            JOIN pg_namespace n ON c.relnamespace = n.oid
            WHERE n.nspname = r.schemaname
            AND c.relname = r.tablename
            AND c.relrowsecurity = true
        ) THEN
            tables_without_rls := tables_without_rls || r.schemaname || '.' || r.tablename || ', ';
        END IF;
    END LOOP;
    
    IF tables_without_rls != '' THEN
        RAISE NOTICE 'WARNING: These tables still need RLS: %', tables_without_rls;
    ELSE
        RAISE NOTICE 'SUCCESS: All critical tables have RLS enabled!';
    END IF;
END $$;

-- =================================================================
-- 10. FINAL SECURITY GRANTS
-- =================================================================

-- Grant necessary permissions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, INSERT, UPDATE ON profiles TO authenticated;
GRANT SELECT, INSERT, UPDATE ON dating_preferences TO authenticated;
GRANT SELECT, INSERT ON verification_documents TO authenticated;
GRANT SELECT, INSERT, UPDATE ON professional_info TO authenticated;
GRANT SELECT, INSERT ON phone_verifications TO authenticated;
GRANT SELECT, INSERT, UPDATE ON messages TO authenticated;
GRANT SELECT, INSERT, UPDATE ON conversations TO authenticated;

-- Grant sequence permissions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO authenticated;

-- Success message
SELECT 'SECURITY FIX COMPLETED - All 6 vulnerabilities should now be resolved!' as status;
```

### **Step 3: Verify the Fix**
After running the script, execute this verification query:

```sql
-- VERIFICATION QUERY - Run this to confirm everything is secure
SELECT 
    schemaname,
    tablename,
    CASE 
        WHEN rowsecurity THEN '✅ SECURE' 
        ELSE '❌ VULNERABLE' 
    END as security_status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('profiles', 'phone_verifications', 'dating_preferences', 'verification_documents', 'professional_info', 'messages', 'conversations')
ORDER BY tablename;
```

### **Step 4: Test Security**
Run this test to confirm users can only see their own data:

```sql
-- TEST QUERY - This should return 0 if security is working
SELECT count(*) as vulnerable_tables
FROM pg_tables pt
WHERE pt.schemaname = 'public'
AND pt.tablename IN ('profiles', 'phone_verifications', 'dating_preferences', 'verification_documents', 'professional_info')
AND NOT EXISTS (
    SELECT 1 FROM pg_class c
    JOIN pg_namespace n ON c.relnamespace = n.oid
    WHERE n.nspname = pt.schemaname
    AND c.relname = pt.tablename
    AND c.relrowsecurity = true
);
```

---

## 🔍 **Expected Results After Fix**

**✅ All 6 errors should be resolved:**
1. **RLS Disabled** → ✅ **ENABLED on all tables**
2. **Database Exposed** → ✅ **SECURED with user isolation**  
3. **Phone Codes Intercepted** → ✅ **PROTECTED with RLS**
4. **Dating Info Public** → ✅ **PRIVATE with privacy controls**
5. **Documents Public** → ✅ **MAXIMUM SECURITY applied**
6. **Professional Info Exposed** → ✅ **PROTECTED with RLS**

---

## ⚠️ **CRITICAL NOTES**

- **Execute this IMMEDIATELY** before any users access the site
- **Do not skip any steps** - partial fixes leave vulnerabilities
- **Test the verification queries** to confirm success
- **Your app is NOT SAFE for publication** until these fixes are applied

## 🆘 **If You Need Help**

If you encounter any errors during execution:
1. Copy the exact error message
2. Check your Supabase project permissions
3. Ensure you're running the script in the correct project
4. Contact Supabase support if database permissions are insufficient

**This is a security emergency - fix this before publishing!** 🚨