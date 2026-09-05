<template>
  <component
    :is="href ? 'a' : 'button'"
    ref="btnEl"
    :href="href"
    :type="href ? undefined : type"
    :disabled="disabled"
    :class="
      cn(
        'group',
        variant === 'primary' ? 'btn-primary-glow' : 'btn-secondary-glass',
        'focus-visible:ring-primary focus-visible:ring-offset-bg focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-none',
        size === 'sm' ? 'gap-1.5 px-5 py-2 text-sm' : 'gap-2 px-7 py-3.5 text-base',
        disabled && 'cursor-not-allowed opacity-50',
      )
    "
  >
    <slot />
    <ArrowRightIcon
      class="h-4 w-4 shrink-0 transition-transform duration-300 group-hover:translate-x-1"
    />
  </component>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { ArrowRightIcon } from '@heroicons/vue/24/outline'
import { cn } from '@/utils/cn'
import { useReducedMotion } from '@/composables/useReducedMotion'

const {
  variant = 'primary',
  size = 'base',
  type = 'button',
  disabled = false,
  href,
} = defineProps<{
  variant?: 'primary' | 'secondary'
  size?: 'base' | 'sm'
  type?: 'button' | 'submit'
  disabled?: boolean
  href?: string
}>()

const btnEl = ref<HTMLElement>()
const { prefersReducedMotion } = useReducedMotion()

let setX: (value: number) => void
let setY: (value: number) => void

function handlePointerMove(e: PointerEvent) {
  if (prefersReducedMotion.value || disabled || !btnEl.value) return
  const rect = btnEl.value.getBoundingClientRect()
  setX((e.clientX - rect.left - rect.width / 2) * 0.25)
  setY((e.clientY - rect.top - rect.height / 2) * 0.25)
}

function handlePointerLeave() {
  setX(0)
  setY(0)
}

onMounted(() => {
  if (!btnEl.value) return
  setX = gsap.quickTo(btnEl.value, 'x', { duration: 0.3, ease: 'power3.out' })
  setY = gsap.quickTo(btnEl.value, 'y', { duration: 0.3, ease: 'power3.out' })
  btnEl.value.addEventListener('pointermove', handlePointerMove)
  btnEl.value.addEventListener('pointerleave', handlePointerLeave)
})

onUnmounted(() => {
  btnEl.value?.removeEventListener('pointermove', handlePointerMove)
  btnEl.value?.removeEventListener('pointerleave', handlePointerLeave)
})
</script>
