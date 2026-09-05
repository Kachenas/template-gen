<template>
  <div
    ref="cardEl"
    class="glass-panel-light text-ink-dim inline-flex items-center gap-2 px-4 py-2 text-xs font-medium"
  >
    <slot />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import gsap from 'gsap'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE } from '@/constants/motion'

const { delay = 0 } = defineProps<{ delay?: number }>()

const cardEl = ref<HTMLElement>()
const { prefersReducedMotion } = useReducedMotion()

onMounted(() => {
  if (!cardEl.value || prefersReducedMotion.value) return
  gsap.from(cardEl.value, {
    y: 16,
    opacity: 0,
    duration: DURATION.slow,
    delay,
    ease: EASE.smooth,
  })
})
</script>
