import { reactive } from 'vue'
import { storeToRefs } from 'pinia'
import { useAuditStore } from '@/stores/auditStore'
import type { IAuditRequest } from '@/types/auditInterface'

export function useAudit() {
  const store = useAuditStore()
  const { current, loading, error } = storeToRefs(store)

  const form = reactive<IAuditRequest>({ name: '', email: '', website: '' })

  async function submit() {
    return store.submit({ ...form })
  }

  return {
    // Store state (reactive refs via storeToRefs)
    current,
    loading,
    error,
    // Local state
    form,
    // Actions
    submit,
  }
}
