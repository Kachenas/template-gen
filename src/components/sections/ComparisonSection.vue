<template>
  <section
    ref="sectionEl"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div
        ref="headingEl"
        class="mx-auto max-w-2xl text-center"
      >
        <p class="eyebrow text-glow-emerald">
          <span class="h-1.5 w-1.5 rounded-full bg-glow-emerald" />
          The Transformation
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Same Business. Different Website.
        </h2>
        <p class="mt-4 text-lg text-ink-dim">
          Drag the slider — this is what a VibeCheckKits rebuild actually changes.
        </p>
      </div>

      <div
        ref="compareEl"
        class="relative mx-auto mt-12 aspect-[4/3] w-full max-w-4xl touch-none overflow-hidden rounded-2xl border border-border select-none md:aspect-video"
        @pointerdown="startDrag"
      >
        <!-- BEFORE: generic business site (base layer, full width) -->
        <div class="absolute inset-0 flex flex-col bg-surface">
          <div class="flex items-center gap-2 border-b border-border-strong/40 px-4 py-3">
            <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
            <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
            <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
            <span class="ml-3 font-mono text-[0.65rem] text-muted">yourbusiness.com</span>
          </div>
          <div class="flex flex-1 flex-col gap-3 p-6">
            <div class="h-20 w-full rounded-md bg-white/10" />
            <div class="h-4 w-2/3 rounded bg-white/10" />
            <div class="h-3 w-full rounded bg-white/5" />
            <div class="h-3 w-5/6 rounded bg-white/5" />
            <div class="mt-2 h-8 w-28 rounded bg-white/10" />
          </div>
        </div>

        <!-- AFTER: VibeCheckKits redesign (clipped reveal layer) -->
        <div
          class="absolute inset-y-0 left-0 overflow-hidden"
          :style="{ width: `${sliderPos}%` }"
        >
          <div
            class="absolute inset-y-0 left-0 flex flex-col bg-bg-elevated"
            :style="{ width: `${containerWidth}px` }"
          >
            <div
              class="absolute inset-0 opacity-60"
              style="
                background: radial-gradient(
                  60% 60% at 20% 0%,
                  color-mix(in srgb, var(--color-glow-emerald) 18%, transparent),
                  transparent
                );
              "
            />
            <div
              class="relative flex items-center gap-2 border-b border-border-strong/40 px-4 py-3"
            >
              <span class="h-2.5 w-2.5 rounded-full bg-glow-emerald" />
              <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
              <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
              <span class="ml-3 font-mono text-[0.65rem] text-ink-dim">vibecheckkits.com</span>
            </div>
            <div class="relative flex flex-1 flex-col gap-3 p-6">
              <div class="h-2 w-24 rounded-full bg-glow-emerald/60" />
              <div class="h-7 w-4/5 rounded bg-white" />
              <div class="h-3 w-full rounded bg-white/20" />
              <div class="h-3 w-2/3 rounded bg-white/20" />
              <div
                class="mt-2 h-8 w-32 rounded-full bg-glow-emerald text-center text-xs leading-8 font-semibold text-[#04120f]"
              >
                Book a Call
              </div>
            </div>
          </div>
        </div>

        <!-- Drag handle -->
        <div
          class="pointer-events-none absolute inset-y-0 z-10 flex items-center"
          :style="{ left: `${sliderPos}%` }"
        >
          <div class="absolute inset-y-0 w-px -translate-x-1/2 bg-white/40" />
          <div
            ref="handleEl"
            role="slider"
            tabindex="0"
            aria-label="Drag to compare the before and after website"
            :aria-valuenow="Math.round(sliderPos)"
            aria-valuemin="0"
            aria-valuemax="100"
            class="glass-panel-light pointer-events-auto flex h-11 w-11 -translate-x-1/2 cursor-ew-resize items-center justify-center rounded-full border border-glow-emerald/50 text-glow-emerald shadow-[0_0_20px_rgba(52,211,153,0.35)] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-glow-emerald"
            @keydown="handleKeydown"
          >
            <ArrowsRightLeftIcon class="h-5 w-5" />
          </div>
        </div>
      </div>

      <div
        ref="metricsEl"
        class="mt-14 grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-5"
      >
        <div
          v-for="metric in METRICS"
          :key="metric.label"
          class="glass-panel-light flex flex-col items-center gap-1 px-4 py-6 text-center"
        >
          <span class="font-display text-3xl font-bold text-glow-emerald">
            <MetricCounter
              :value="metric.value"
              :prefix="metric.prefix"
              :suffix="metric.suffix"
              :decimals="metric.decimals ?? 0"
            />
          </span>
          <span class="text-xs tracking-wide text-ink-dim uppercase">{{ metric.label }}</span>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { ArrowsRightLeftIcon } from '@heroicons/vue/24/outline'
import MetricCounter from '@/components/ui/MetricCounter.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE, STAGGER } from '@/constants/motion'

interface Metric {
  label: string
  value: number
  prefix: string
  suffix: string
  decimals?: number
}

const METRICS: Metric[] = [
  { label: 'Bounce Rate ↓', value: 62, prefix: '-', suffix: '%' },
  { label: 'Page Speed ↑', value: 4.2, prefix: '', suffix: 'x', decimals: 1 },
  { label: 'Conversions ↑', value: 180, prefix: '+', suffix: '%' },
  { label: 'SEO Score ↑', value: 96, prefix: '', suffix: '/100' },
  { label: 'Bookings ↑', value: 210, prefix: '+', suffix: '%' },
]

const sectionEl = ref<HTMLElement>()
const headingEl = ref<HTMLElement>()
const compareEl = ref<HTMLElement>()
const metricsEl = ref<HTMLElement>()

const sliderPos = ref(50)
const containerWidth = ref(0)
let dragging = false
let resizeObserver: ResizeObserver | undefined

function updateFromClientX(clientX: number) {
  if (!compareEl.value) return
  const rect = compareEl.value.getBoundingClientRect()
  const pct = ((clientX - rect.left) / rect.width) * 100
  sliderPos.value = Math.min(100, Math.max(0, pct))
}

function startDrag(e: PointerEvent) {
  dragging = true
  updateFromClientX(e.clientX)
}

function onDrag(e: PointerEvent) {
  if (!dragging) return
  updateFromClientX(e.clientX)
}

function endDrag() {
  dragging = false
}

function handleKeydown(e: KeyboardEvent) {
  if (e.key === 'ArrowLeft') sliderPos.value = Math.max(0, sliderPos.value - 5)
  if (e.key === 'ArrowRight') sliderPos.value = Math.min(100, sliderPos.value + 5)
}

const { prefersReducedMotion } = useReducedMotion()
let revealTween: gsap.core.Tween | undefined

onMounted(() => {
  if (compareEl.value) {
    resizeObserver = new ResizeObserver(([entry]) => {
      containerWidth.value = entry?.contentRect.width ?? 0
    })
    resizeObserver.observe(compareEl.value)
  }

  window.addEventListener('pointermove', onDrag)
  window.addEventListener('pointerup', endDrag)

  if (!prefersReducedMotion.value) {
    revealTween = gsap.from([headingEl.value, compareEl.value, metricsEl.value], {
      opacity: 0,
      y: 32,
      duration: DURATION.slow,
      ease: EASE.outExpo,
      stagger: STAGGER.base,
      scrollTrigger: { trigger: sectionEl.value, start: 'top 75%' },
    })
  }
})

onUnmounted(() => {
  resizeObserver?.disconnect()
  window.removeEventListener('pointermove', onDrag)
  window.removeEventListener('pointerup', endDrag)
  revealTween?.scrollTrigger?.kill()
  revealTween?.kill()
})
</script>
