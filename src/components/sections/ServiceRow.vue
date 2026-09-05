<template>
  <div
    ref="rowEl"
    :class="
      cn(
        'grid items-center gap-10 py-16 md:grid-cols-2 md:gap-16 md:py-24',
        reverse && 'md:[&>*:first-child]:order-2',
      )
    "
  >
    <div>
      <p :class="cn('eyebrow', glow === 'purple' ? 'text-glow-purple' : 'text-primary')">
        <component
          :is="icon"
          class="h-4 w-4"
        />
        {{ kicker }}
      </p>
      <h3 class="mt-4 font-display text-3xl font-bold text-white md:text-4xl">
        {{ title }}
      </h3>
      <p class="mt-4 max-w-md text-lg text-ink-dim">
        {{ description }}
      </p>
    </div>

    <div>
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, type Component } from 'vue'
import gsap from 'gsap'
import { cn } from '@/utils/cn'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE } from '@/constants/motion'

const { glow = 'cyan', reverse = false } = defineProps<{
  kicker: string
  title: string
  description: string
  icon: Component
  glow?: 'cyan' | 'purple'
  reverse?: boolean
}>()

const rowEl = ref<HTMLElement>()
const { prefersReducedMotion } = useReducedMotion()
let tween: gsap.core.Tween | undefined

onMounted(() => {
  if (!rowEl.value || prefersReducedMotion.value) return
  tween = gsap.from(rowEl.value, {
    opacity: 0,
    x: reverse ? 40 : -40,
    duration: DURATION.slow,
    ease: EASE.outExpo,
    scrollTrigger: { trigger: rowEl.value, start: 'top 80%' },
  })
})

onUnmounted(() => {
  tween?.scrollTrigger?.kill()
  tween?.kill()
})
</script>
