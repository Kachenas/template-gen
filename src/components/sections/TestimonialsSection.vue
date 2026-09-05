<template>
  <section
    ref="sectionEl"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div class="mx-auto max-w-2xl text-center">
        <p class="eyebrow text-glow-emerald">
          <span class="h-1.5 w-1.5 rounded-full bg-glow-emerald" />
          What Clients Say
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Real Businesses. Real Wins.
        </h2>
        <p class="mt-4 text-lg text-ink-dim">
          Not stock quotes — the actual outcomes clients hired us to get.
        </p>
      </div>

      <div class="mt-12 grid gap-6 md:grid-cols-3">
        <div
          v-for="(testimonial, i) in TESTIMONIALS"
          :key="testimonial.company"
          :ref="(el) => setCardRef(el as HTMLElement | null, i)"
          class="glass-panel-light group flex flex-col gap-4 p-6"
        >
          <div
            class="relative flex h-32 w-full items-center justify-center overflow-hidden rounded-xl bg-gradient-to-br from-glow-emerald/20 to-bg-elevated"
          >
            <PlayCircleIcon
              class="h-12 w-12 text-white/90 transition-transform duration-300 group-hover:scale-110"
            />
          </div>
          <p class="text-ink-dim">
            &ldquo;{{ testimonial.quote }}&rdquo;
          </p>
          <div class="mt-auto pt-2">
            <p class="font-display font-semibold text-white">
              {{ testimonial.role }}
            </p>
            <p class="text-sm text-glow-emerald">
              {{ testimonial.company }}
            </p>
          </div>
        </div>
      </div>

      <div
        ref="metricsEl"
        class="mt-14 grid grid-cols-2 gap-6 sm:grid-cols-4"
      >
        <div
          v-for="metric in METRICS"
          :key="metric.label"
          class="text-center"
        >
          <p class="font-display text-3xl font-bold text-glow-emerald">
            <MetricCounter
              :value="metric.value"
              :suffix="metric.suffix"
              :decimals="metric.decimals ?? 0"
            />
          </p>
          <p class="mt-1 text-xs tracking-wide text-ink-dim uppercase">
            {{ metric.label }}
          </p>
        </div>
      </div>

      <div class="mt-16">
        <p class="mb-6 text-center text-xs tracking-wide text-ink-faint uppercase">
          Trusted Across Industries
        </p>

        <div
          v-if="!prefersReducedMotion"
          class="overflow-hidden"
        >
          <div class="flex w-max animate-marquee gap-12 hover:[animation-play-state:paused]">
            <span
              v-for="(logo, i) in [...LOGOS, ...LOGOS]"
              :key="`${logo}-${i}`"
              class="font-display text-lg font-semibold whitespace-nowrap text-ink-faint"
            >
              {{ logo }}
            </span>
          </div>
        </div>
        <div
          v-else
          class="flex flex-wrap justify-center gap-x-10 gap-y-4"
        >
          <span
            v-for="logo in LOGOS"
            :key="logo"
            class="font-display text-lg font-semibold text-ink-faint"
          >
            {{ logo }}
          </span>
        </div>
      </div>

      <div class="mt-16 flex justify-center">
        <GlowButton href="#audit">
          Book a Discovery Call
        </GlowButton>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { PlayCircleIcon } from '@heroicons/vue/24/outline'
import GlowButton from '@/components/ui/GlowButton.vue'
import MetricCounter from '@/components/ui/MetricCounter.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE, STAGGER } from '@/constants/motion'

interface Testimonial {
  quote: string
  role: string
  company: string
}

const TESTIMONIALS: Testimonial[] = [
  {
    quote:
      'Bookings doubled in six weeks — and the site finally looks like the resort actually feels.',
    role: 'Owner',
    company: 'Cape View Resort',
  },
  {
    quote: 'Investors finally see a product that matches how good the platform actually is.',
    role: 'Founder',
    company: 'Nimbus Analytics',
  },
  {
    quote: 'The automation alone saved us fifteen hours a week we used to spend on follow-ups.',
    role: 'Head Coach',
    company: 'BrightPath Coaching',
  },
]

interface Metric {
  label: string
  value: number
  suffix: string
  decimals?: number
}

const METRICS: Metric[] = [
  { label: 'Sites Shipped', value: 50, suffix: '+' },
  { label: 'Avg. Rating', value: 4.9, suffix: '/5', decimals: 1 },
  { label: 'Industries Served', value: 12, suffix: '' },
  { label: 'Avg. Lighthouse', value: 95, suffix: '+' },
]

const LOGOS = [
  'Cape View Resort',
  'Nimbus Analytics',
  'BrightPath Coaching',
  'Fenwick Realty',
  'Aurelia Studio',
  'Northfield Goods',
  'Halcyon Labs',
  'Loop & Co.',
]

const sectionEl = ref<HTMLElement>()
const metricsEl = ref<HTMLElement>()
const cardRefs = ref<(HTMLElement | null)[]>([])

function setCardRef(el: HTMLElement | null, i: number) {
  cardRefs.value[i] = el
}

const { prefersReducedMotion } = useReducedMotion()
let tween: gsap.core.Tween | undefined

onMounted(() => {
  const cards = cardRefs.value.filter((el): el is HTMLElement => Boolean(el))
  if (prefersReducedMotion.value || cards.length === 0) return

  tween = gsap.from([...cards, metricsEl.value], {
    opacity: 0,
    y: 32,
    scale: 0.97,
    duration: DURATION.slow,
    ease: EASE.outExpo,
    stagger: STAGGER.base,
    scrollTrigger: { trigger: sectionEl.value, start: 'top 75%' },
  })
})

onUnmounted(() => {
  tween?.scrollTrigger?.kill()
  tween?.kill()
})
</script>
