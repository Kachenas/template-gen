import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { IAuditRequest } from '@/types/auditInterface'
import * as auditService from '@/services/AuditService'
import { getErrorMessage } from '@/utils/errorHandler'

export const useAuditStore = defineStore('audit', () => {
  const current = ref<IAuditRequest | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function submit(payload: IAuditRequest) {
    loading.value = true
    error.value = null
    try {
      current.value = await auditService.submitAuditRequest(payload)
      return current.value
    } catch (err: unknown) {
      error.value = getErrorMessage(err)
      throw err
    } finally {
      loading.value = false
    }
  }

  function clear() {
    current.value = null
    error.value = null
  }

  return { current, loading, error, submit, clear }
})
