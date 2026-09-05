<template>
  <span ref="el">{{ display }}</span>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION } from '@/constants/motion'

const {
  value,
  prefix = '',
  suffix = '',
  decimals = 0,
} = defineProps<{
  value: number
  prefix?: string
  suffix?: string
  decimals?: number
}>()

function format(n: number) {
  return `${prefix}${n.toFixed(decimals)}${suffix}`
}

const el = ref<HTMLElement>()
const display = ref(format(0))
const { prefersReducedMotion } = useReducedMotion()

let observer: IntersectionObserver | undefined

onMounted(() => {
  if (!el.value) return

  if (prefersReducedMotion.value) {
    display.value = format(value)
    return
  }

  const counter = { n: 0 }
  observer = new IntersectionObserver(
    (entries) => {
      if (!entries[0]?.isIntersecting) return
      gsap.to(counter, {
        n: value,
        duration: DURATION.cinematic,
        ease: 'power2.out',
        onUpdate: () => {
          display.value = format(counter.n)
        },
      })
      observer?.disconnect()
    },
    { threshold: 0.4 },
  )
  observer.observe(el.value)
})

onUnmounted(() => observer?.disconnect())
</script>
