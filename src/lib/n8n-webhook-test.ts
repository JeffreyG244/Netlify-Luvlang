import { supabase } from './supabase'
import { securityMonitor } from './security'

export interface WebhookTestResult {
  test_name: string
  success: boolean
  response_time: number
  status_code?: number
  error_message?: string
  timestamp: string
}

export class N8NWebhookTester {
  private webhookUrl: string

  constructor(webhookUrl?: string) {
    this.webhookUrl = webhookUrl || process.env.N8N_WEBHOOK_URL || 'http://localhost:5678/webhook/test'
  }

  async testWebhookConnection(): Promise<WebhookTestResult> {
    const startTime = Date.now()
    const testName = 'Connection Test'

    try {
      const response = await fetch(this.webhookUrl, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Luvlang-Security-Test/1.0'
        },
        signal: AbortSignal.timeout(10000) // 10 second timeout
      })

      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: response.ok,
        response_time: responseTime,
        status_code: response.status,
        timestamp: new Date().toISOString()
      }
    } catch (error) {
      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: false,
        response_time: responseTime,
        error_message: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      }
    }
  }

  async testSecurityEventWebhook(): Promise<WebhookTestResult> {
    const startTime = Date.now()
    const testName = 'Security Event Webhook'

    try {
      const testEvent = {
        event_type: 'login_attempt',
        success: false,
        ip_address: '192.168.1.100',
        user_agent: 'Test-Agent/1.0',
        metadata: {
          test: true,
          timestamp: new Date().toISOString()
        }
      }

      const response = await fetch(this.webhookUrl + '/security', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Webhook-Source': 'luvlang-security'
        },
        body: JSON.stringify(testEvent),
        signal: AbortSignal.timeout(10000)
      })

      const endTime = Date.now()
      const responseTime = endTime - startTime

      // Log the test event
      await securityMonitor.logSecurityEvent({
        event_type: 'login_attempt',
        success: true,
        ip_address: '127.0.0.1',
        user_agent: 'N8N-Webhook-Test',
        metadata: {
          test: true,
          webhook_response_code: response.status,
          response_time: responseTime
        }
      })

      return {
        test_name: testName,
        success: response.ok,
        response_time: responseTime,
        status_code: response.status,
        timestamp: new Date().toISOString()
      }
    } catch (error) {
      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: false,
        response_time: responseTime,
        error_message: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      }
    }
  }

  async testUserRegistrationWebhook(): Promise<WebhookTestResult> {
    const startTime = Date.now()
    const testName = 'User Registration Webhook'

    try {
      const testUser = {
        id: 'test-user-' + Date.now(),
        email: 'test@example.com',
        created_at: new Date().toISOString(),
        metadata: {
          test: true,
          source: 'webhook-test'
        }
      }

      const response = await fetch(this.webhookUrl + '/user-registration', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Webhook-Source': 'luvlang-auth'
        },
        body: JSON.stringify(testUser),
        signal: AbortSignal.timeout(10000)
      })

      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: response.ok,
        response_time: responseTime,
        status_code: response.status,
        timestamp: new Date().toISOString()
      }
    } catch (error) {
      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: false,
        response_time: responseTime,
        error_message: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      }
    }
  }

  async testDataBackupWebhook(): Promise<WebhookTestResult> {
    const startTime = Date.now()
    const testName = 'Data Backup Webhook'

    try {
      const backupData = {
        backup_id: 'test-backup-' + Date.now(),
        backup_type: 'manual',
        status: 'completed',
        tables: ['users', 'profiles', 'security_events'],
        record_count: 150,
        size_bytes: 1048576,
        timestamp: new Date().toISOString(),
        metadata: {
          test: true,
          source: 'webhook-test'
        }
      }

      const response = await fetch(this.webhookUrl + '/backup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Webhook-Source': 'luvlang-backup'
        },
        body: JSON.stringify(backupData),
        signal: AbortSignal.timeout(10000)
      })

      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: response.ok,
        response_time: responseTime,
        status_code: response.status,
        timestamp: new Date().toISOString()
      }
    } catch (error) {
      const endTime = Date.now()
      const responseTime = endTime - startTime

      return {
        test_name: testName,
        success: false,
        response_time: responseTime,
        error_message: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      }
    }
  }

  async runAllTests(): Promise<WebhookTestResult[]> {
    console.log('Starting N8N webhook integration tests...')

    const tests = [
      this.testWebhookConnection(),
      this.testSecurityEventWebhook(),
      this.testUserRegistrationWebhook(),
      this.testDataBackupWebhook()
    ]

    const results = await Promise.all(tests)

    // Store test results
    try {
      const { error } = await supabase
        .from('webhook_test_results')
        .insert(results)

      if (error) {
        console.error('Failed to store webhook test results:', error)
      }
    } catch (err) {
      console.error('Error storing test results:', err)
    }

    // Log summary
    const successful = results.filter(r => r.success).length
    const total = results.length
    
    console.log(`N8N Webhook Tests Complete: ${successful}/${total} tests passed`)
    
    if (successful < total) {
      console.warn('Some webhook tests failed. Check the results for details.')
      
      // Log failed tests as security events
      const failedTests = results.filter(r => !r.success)
      for (const test of failedTests) {
        await securityMonitor.logSecurityEvent({
          event_type: 'suspicious_activity',
          success: false,
          metadata: {
            test_failure: true,
            test_name: test.test_name,
            error: test.error_message
          }
        })
      }
    }

    return results
  }

  async validateWebhookSecurity(): Promise<{
    secure: boolean
    issues: string[]
    recommendations: string[]
  }> {
    const issues: string[] = []
    const recommendations: string[] = []

    // Test for basic security headers
    try {
      const response = await fetch(this.webhookUrl, {
        method: 'OPTIONS'
      })

      const headers = response.headers

      if (!headers.get('x-frame-options')) {
        issues.push('Missing X-Frame-Options header')
        recommendations.push('Add X-Frame-Options: DENY header')
      }

      if (!headers.get('x-content-type-options')) {
        issues.push('Missing X-Content-Type-Options header')
        recommendations.push('Add X-Content-Type-Options: nosniff header')
      }

      if (!this.webhookUrl.startsWith('https://')) {
        issues.push('Webhook URL is not using HTTPS')
        recommendations.push('Use HTTPS for all webhook endpoints')
      }

    } catch (error) {
      issues.push('Unable to perform security validation')
      recommendations.push('Ensure webhook endpoint is accessible for security testing')
    }

    return {
      secure: issues.length === 0,
      issues,
      recommendations
    }
  }
}

export const n8nTester = new N8NWebhookTester()