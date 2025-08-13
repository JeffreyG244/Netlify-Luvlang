# Custom Domain Configuration for Supabase Auth

## Overview
Configure custom domains for Supabase Auth to enhance security and user experience.

## Steps to Configure Custom Domain

### 1. Domain Setup
- Primary domain: `luvlang.org`
- Auth subdomain: `auth.luvlang.org`

### 2. DNS Configuration
Add the following DNS records:

```
Type: CNAME
Name: auth
Value: tzskjzkolyiwhijslqmq.supabase.co
TTL: 3600
```

### 3. Supabase Dashboard Configuration

#### Auth Settings:
1. Go to Supabase Dashboard → Authentication → Settings
2. Under "Site URL", set: `https://luvlang.org`
3. Under "Additional redirect URLs", add:
   - `https://luvlang.org/auth/callback`
   - `https://auth.luvlang.org/callback`
   - `https://luvlang.org/auth/reset-password`

#### Custom SMTP (Optional but Recommended):
1. Go to Authentication → Settings → SMTP Settings
2. Configure custom SMTP to send emails from `@luvlang.org` domain
3. Example configuration:
   ```
   SMTP Host: smtp.your-provider.com
   SMTP Port: 587
   SMTP User: noreply@luvlang.org
   SMTP Pass: [Your SMTP Password]
   ```

### 4. Application Configuration

Update your application configuration:

```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://tzskjzkolyiwhijslqmq.supabase.co'
const supabaseAnonKey = 'your-anon-key'

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    flowType: 'pkce',
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    // Custom redirect configuration
    redirectTo: process.env.NODE_ENV === 'production' 
      ? 'https://luvlang.org/auth/callback'
      : 'http://localhost:3000/auth/callback'
  }
})
```

### 5. Security Headers Configuration

Add security headers to your hosting platform:

```
# Netlify _headers file
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  X-XSS-Protection: 1; mode=block
  Referrer-Policy: strict-origin-when-cross-origin
  Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' https://tzskjzkolyiwhijslqmq.supabase.co; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' https://tzskjzkolyiwhijslqmq.supabase.co wss://tzskjzkolyiwhijslqmq.supabase.co;

/auth/*
  X-Robots-Tag: noindex
```

### 6. Verification Steps

1. **Test DNS Resolution:**
   ```bash
   nslookup auth.luvlang.org
   ```

2. **Test HTTPS Certificate:**
   ```bash
   curl -I https://auth.luvlang.org
   ```

3. **Test Auth Flow:**
   - Navigate to your login page
   - Initiate authentication
   - Verify redirect URLs work correctly
   - Check email templates use custom domain

### 7. Email Template Configuration

Update email templates to use custom domain:

1. Go to Authentication → Email Templates
2. Update each template to reference `luvlang.org` instead of Supabase URLs
3. Example for confirmation email:
   ```html
   <h2>Confirm your signup</h2>
   <p>Follow this link to confirm your user:</p>
   <p><a href="{{ .ConfirmationURL }}">Confirm your account</a></p>
   <p>This link will expire in 24 hours.</p>
   ```

### 8. Monitoring and Alerts

Monitor auth domain health:

```typescript
// Add to your monitoring system
async function checkAuthDomainHealth() {
  try {
    const response = await fetch('https://auth.luvlang.org/.well-known/jwks.json')
    return response.ok
  } catch (error) {
    console.error('Auth domain health check failed:', error)
    return false
  }
}
```

## Security Best Practices

1. **HTTPS Only**: Ensure all auth flows use HTTPS
2. **HSTS Headers**: Enable HTTP Strict Transport Security
3. **Certificate Pinning**: Consider implementing certificate pinning
4. **Domain Validation**: Regularly verify domain ownership
5. **Access Logs**: Monitor access patterns for anomalies

## Troubleshooting

### Common Issues:

1. **CORS Errors**: Verify all URLs are added to Supabase settings
2. **Certificate Issues**: Ensure SSL certificate covers subdomains
3. **Redirect Loops**: Check redirect URL configuration
4. **Email Delivery**: Verify SMTP settings and DNS SPF records

### Verification Commands:

```bash
# Check DNS propagation
dig auth.luvlang.org CNAME

# Test SSL certificate
openssl s_client -connect auth.luvlang.org:443 -servername auth.luvlang.org

# Test auth endpoint
curl https://auth.luvlang.org/.well-known/jwks.json
```