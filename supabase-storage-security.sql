-- STORAGE SECURITY CONFIGURATION for Luvlang Dating App
-- This script secures file storage for sensitive documents and images

-- =================================================================
-- 1. CREATE SECURE STORAGE BUCKETS
-- =================================================================

-- Create bucket for verification documents (HIGHLY RESTRICTED)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'verification-documents',
    'verification-documents',
    false, -- NOT PUBLIC
    10485760, -- 10MB limit
    '{"image/jpeg","image/png","application/pdf"}'
) ON CONFLICT (id) DO UPDATE SET
    public = false,
    file_size_limit = 10485760,
    allowed_mime_types = '{"image/jpeg","image/png","application/pdf"}';

-- Create bucket for profile images (CONTROLLED ACCESS)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'profile-images',
    'profile-images',
    false, -- NOT PUBLIC
    5242880, -- 5MB limit
    '{"image/jpeg","image/png","image/webp"}'
) ON CONFLICT (id) DO UPDATE SET
    public = false,
    file_size_limit = 5242880,
    allowed_mime_types = '{"image/jpeg","image/png","image/webp"}';

-- Create bucket for chat media (PRIVATE)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'chat-media',
    'chat-media',
    false, -- NOT PUBLIC
    20971520, -- 20MB limit
    '{"image/jpeg","image/png","image/webp","video/mp4","video/quicktime"}'
) ON CONFLICT (id) DO UPDATE SET
    public = false,
    file_size_limit = 20971520,
    allowed_mime_types = '{"image/jpeg","image/png","image/webp","video/mp4","video/quicktime"}';

-- =================================================================
-- 2. VERIFICATION DOCUMENTS STORAGE POLICIES (MAXIMUM SECURITY)
-- =================================================================

-- Users can only upload their own verification documents
CREATE POLICY "Users can upload their own verification documents"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'verification-documents' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Users can only view their own verification documents
CREATE POLICY "Users can view their own verification documents"
ON storage.objects FOR SELECT
USING (
    bucket_id = 'verification-documents' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Only admins and document owners can delete verification documents
CREATE POLICY "Restricted delete for verification documents"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'verification-documents' 
    AND (
        auth.uid()::text = (storage.foldername(name))[1]
        OR EXISTS (
            SELECT 1 FROM profiles 
            WHERE id = auth.uid() 
            AND role = 'admin'
        )
    )
);

-- =================================================================
-- 3. PROFILE IMAGES STORAGE POLICIES (CONTROLLED ACCESS)
-- =================================================================

-- Users can upload their own profile images
CREATE POLICY "Users can upload their own profile images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'profile-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- Users can view profile images based on privacy settings
CREATE POLICY "Controlled access to profile images"
ON storage.objects FOR SELECT
USING (
    bucket_id = 'profile-images' 
    AND (
        -- Users can always see their own images
        auth.uid()::text = (storage.foldername(name))[1]
        OR
        -- Or if they have permission to view the profile
        EXISTS (
            SELECT 1 FROM profiles p
            JOIN dating_preferences dp ON p.id = dp.user_id
            WHERE p.id::text = (storage.foldername(name))[1]
            AND (
                dp.privacy_level = 'public'
                OR (
                    dp.privacy_level = 'private' 
                    AND EXISTS (
                        SELECT 1 FROM matches m
                        WHERE (m.user1_id = auth.uid() AND m.user2_id = p.id)
                           OR (m.user1_id = p.id AND m.user2_id = auth.uid())
                        AND m.status = 'accepted'
                    )
                )
            )
        )
    )
);

-- Users can update/delete their own profile images
CREATE POLICY "Users can manage their own profile images"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'profile-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

CREATE POLICY "Users can delete their own profile images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'profile-images' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- =================================================================
-- 4. CHAT MEDIA STORAGE POLICIES (PRIVATE)
-- =================================================================

-- Users can upload media to conversations they're part of
CREATE POLICY "Users can upload to their conversations"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'chat-media' 
    AND EXISTS (
        SELECT 1 FROM conversations c
        WHERE c.id::text = (storage.foldername(name))[1]
        AND (c.participant1_id = auth.uid() OR c.participant2_id = auth.uid())
    )
);

-- Users can view media from their conversations
CREATE POLICY "Users can view their conversation media"
ON storage.objects FOR SELECT
USING (
    bucket_id = 'chat-media' 
    AND EXISTS (
        SELECT 1 FROM conversations c
        WHERE c.id::text = (storage.foldername(name))[1]
        AND (c.participant1_id = auth.uid() OR c.participant2_id = auth.uid())
    )
);

-- Users can delete media they uploaded
CREATE POLICY "Users can delete their uploaded media"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'chat-media' 
    AND owner = auth.uid()
);

-- =================================================================
-- 5. SECURE FILE ACCESS FUNCTIONS
-- =================================================================

-- Function to get secure URL for verification documents (admin only)
CREATE OR REPLACE FUNCTION get_verification_document_url(
    document_id BIGINT
)
RETURNS TEXT AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_document_path TEXT;
    v_is_admin BOOLEAN := FALSE;
    v_document_owner UUID;
BEGIN
    -- Check if user is admin
    SELECT EXISTS (
        SELECT 1 FROM profiles 
        WHERE id = v_user_id 
        AND role = 'admin'
    ) INTO v_is_admin;

    -- Get document info
    SELECT user_id, document_url INTO v_document_owner, v_document_path
    FROM verification_documents
    WHERE id = document_id;

    -- Check authorization
    IF NOT (v_is_admin OR v_document_owner = v_user_id) THEN
        RETURN NULL;
    END IF;

    -- Return signed URL (valid for 1 hour)
    RETURN storage.sign(v_document_path, 3600);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get secure profile image URL
CREATE OR REPLACE FUNCTION get_profile_image_url(
    target_user_id UUID
)
RETURNS TEXT AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_image_path TEXT;
    v_can_view BOOLEAN;
BEGIN
    -- Check if user can view this profile
    SELECT can_view_profile(target_user_id) INTO v_can_view;

    IF NOT v_can_view THEN
        RETURN NULL;
    END IF;

    -- Get profile image path
    SELECT profile_image_url INTO v_image_path
    FROM profiles
    WHERE id = target_user_id;

    IF v_image_path IS NULL THEN
        RETURN NULL;
    END IF;

    -- Return signed URL (valid for 24 hours)
    RETURN storage.sign(v_image_path, 86400);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================================
-- 6. FILE CLEANUP FUNCTIONS
-- =================================================================

-- Function to clean up orphaned files
CREATE OR REPLACE FUNCTION cleanup_orphaned_files()
RETURNS INTEGER AS $$
DECLARE
    v_deleted_count INTEGER := 0;
    r RECORD;
BEGIN
    -- Clean up verification documents for deleted users
    FOR r IN (
        SELECT name FROM storage.objects 
        WHERE bucket_id = 'verification-documents'
        AND NOT EXISTS (
            SELECT 1 FROM auth.users 
            WHERE id::text = (storage.foldername(name))[1]
        )
    ) LOOP
        DELETE FROM storage.objects WHERE name = r.name;
        v_deleted_count := v_deleted_count + 1;
    END LOOP;

    -- Clean up profile images for deleted users
    FOR r IN (
        SELECT name FROM storage.objects 
        WHERE bucket_id = 'profile-images'
        AND NOT EXISTS (
            SELECT 1 FROM auth.users 
            WHERE id::text = (storage.foldername(name))[1]
        )
    ) LOOP
        DELETE FROM storage.objects WHERE name = r.name;
        v_deleted_count := v_deleted_count + 1;
    END LOOP;

    -- Clean up old chat media (older than 1 year)
    FOR r IN (
        SELECT name FROM storage.objects 
        WHERE bucket_id = 'chat-media'
        AND created_at < NOW() - INTERVAL '1 year'
    ) LOOP
        DELETE FROM storage.objects WHERE name = r.name;
        v_deleted_count := v_deleted_count + 1;
    END LOOP;

    RETURN v_deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================================
-- 7. STORAGE AUDIT TRIGGERS
-- =================================================================

-- Function to log storage access
CREATE OR REPLACE FUNCTION log_storage_access()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_logs (
        user_id,
        action,
        table_name,
        record_id,
        new_data,
        created_at
    ) VALUES (
        auth.uid(),
        TG_OP,
        'storage.objects',
        COALESCE(NEW.id::text, OLD.id::text),
        to_jsonb(NEW),
        NOW()
    );
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create triggers for storage audit
CREATE TRIGGER storage_audit_trigger
    AFTER INSERT OR UPDATE OR DELETE ON storage.objects
    FOR EACH ROW EXECUTE FUNCTION log_storage_access();

-- =================================================================
-- 8. SCHEDULED CLEANUP JOB
-- =================================================================

-- Create function to be called by cron job
CREATE OR REPLACE FUNCTION scheduled_cleanup()
RETURNS VOID AS $$
BEGIN
    -- Clean up expired phone verification codes
    DELETE FROM phone_verifications 
    WHERE code_expires_at < NOW() - INTERVAL '1 day';

    -- Clean up old audit logs (keep 1 year)
    DELETE FROM audit_logs 
    WHERE created_at < NOW() - INTERVAL '1 year';

    -- Clean up orphaned files
    PERFORM cleanup_orphaned_files();

    -- Clean up expired verification documents (rejected ones older than 30 days)
    DELETE FROM verification_documents 
    WHERE verification_status = 'rejected' 
    AND uploaded_at < NOW() - INTERVAL '30 days';
    
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =================================================================
-- GRANT PERMISSIONS
-- =================================================================

-- Grant execute permissions on secure functions
GRANT EXECUTE ON FUNCTION get_verification_document_url(BIGINT) TO authenticated;
GRANT EXECUTE ON FUNCTION get_profile_image_url(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION cleanup_orphaned_files() TO service_role;
GRANT EXECUTE ON FUNCTION scheduled_cleanup() TO service_role;