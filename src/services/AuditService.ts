import { post } from '@/composables/useApi'
import type { IAuditRequest } from '@/types/auditInterface'

export async function submitAuditRequest(payload: IAuditRequest): Promise<IAuditRequest> {
  return await post<IAuditRequest>('/audit-requests', payload)
}
