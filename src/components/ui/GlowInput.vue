<template>
  <div>
    <label
      v-if="label"
      :for="id"
      class="mb-1.5 block text-sm font-medium text-ink-dim"
    >
      {{ label }}
    </label>
    <input
      :id="id"
      :type="type"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :autocomplete="autocomplete"
      :class="
        cn(
          'w-full rounded-xl border border-border-strong bg-white/5 px-4 py-2.5 text-sm text-white outline-none transition-colors',
          'placeholder:text-muted',
          'focus:border-primary focus:ring-2 focus:ring-primary/20',
          errorMessage && 'border-rose-400/50 focus:border-rose-400 focus:ring-rose-400/20',
          disabled && 'cursor-not-allowed opacity-50',
        )
      "
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
    >
    <p
      v-if="errorMessage"
      class="mt-1 text-xs text-rose-300"
    >
      {{ errorMessage }}
    </p>
  </div>
</template>

<script setup lang="ts">
import { cn } from '@/utils/cn'

const {
  modelValue = '',
  label = '',
  type = 'text',
  placeholder = '',
  disabled = false,
  errorMessage = '',
  id,
  autocomplete,
} = defineProps<{
  modelValue?: string
  label?: string
  type?: string
  placeholder?: string
  disabled?: boolean
  errorMessage?: string
  id?: string
  autocomplete?: string
}>()

defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()
</script>
