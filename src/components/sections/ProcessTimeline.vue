<template>
  <section
    id="process"
    ref="wrapperEl"
    class="relative bg-bg"
    :style="prefersReducedMotion ? {} : { height: '300vh' }"
  >
    <div
      :class="
        cn(
          'flex flex-col justify-center overflow-hidden px-6',
          prefersReducedMotion ? 'gap-10 py-24' : 'sticky top-0 h-screen',
        )
      "
    >
      <div class="content-shell w-full">
        <div class="mx-auto max-w-2xl text-center">
          <p class="eyebrow text-primary">
            <span class="h-1.5 w-1.5 rounded-full bg-primary" />
            How We Work
          </p>
          <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
            From Audit to Scale in Five Steps.
          </h2>
          <p class="mt-4 text-lg text-ink-dim">
            No mystery process, no 12-week discovery phase — just the steps that actually ship a
            site.
          </p>
        </div>

        <!-- Interactive version: nodes always visible, description swaps as you scroll -->
        <template v-if="!prefersReducedMotion">
          <div class="relative mx-auto mt-20 flex max-w-3xl items-start justify-between">
            <div class="absolute top-6 right-0 left-0 h-px bg-border-strong/40" />
            <div
              ref="progressLineEl"
              class="absolute top-6 left-0 h-px w-full origin-left scale-x-0 bg-primary shadow-glow-sm"
            />

            <div
              v-for="(step, i) in STEPS"
              :key="step.label"
              class="relative z-10 flex flex-1 flex-col items-center text-center"
            >
              <div
                :class="
                  cn(
                    'flex h-12 w-12 items-center justify-center rounded-full border bg-bg font-mono text-sm transition-colors duration-300',
                    i <= activeIndex
                      ? 'border-primary text-primary'
                      : 'border-border-strong/40 text-ink-faint',
                  )
                "
              >
                {{ String(i + 1).padStart(2, '0') }}
              </div>
              <p
                :class="
                  cn(
                    'mt-4 font-display text-sm font-semibold transition-colors duration-300 md:text-base',
                    i === activeIndex ? 'text-white' : 'text-ink-dim',
                  )
                "
              >
                {{ step.label }}
              </p>
            </div>
          </div>

          <p class="mx-auto mt-10 max-w-xl text-center text-lg text-ink-dim">
            {{ STEPS[activeIndex]?.description }}
          </p>
        </template>

        <!-- Reduced motion: every step's detail visible at once, no scroll-jacking -->
        <ol
          v-else
          class="mx-auto mt-16 flex max-w-2xl flex-col gap-6"
        >
          <li
            v-for="(step, i) in STEPS"
            :key="step.label"
            class="flex gap-4"
          >
            <div
              class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full border border-primary bg-bg font-mono text-sm text-primary"
            >
              {{ String(i + 1).padStart(2, '0') }}
            </div>
            <div>
              <p class="font-display font-semibold text-white">
                {{ step.label }}
              </p>
              <p class="mt-1 text-ink-dim">
                {{ step.description }}
              </p>
            </div>
          </li>
        </ol>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { cn } from '@/utils/cn'
import { useReducedMotion } from '@/composables/useReducedMotion'

const STEPS = [
  {
    label: 'Discover',
    description:
      "We audit your current site, market, and competitors to find exactly where you're losing conversions.",
  },
  {
    label: 'Design',
    description:
      'Wireframes and a visual system built around your brand — reviewed with you before a single line of code ships.',
  },
  {
    label: 'Build',
    description:
      'Production Vue and TypeScript, built section by section, tested against real devices as we go.',
  },
  {
    label: 'Deploy',
    description:
      'Shipped to AWS — S3, CloudFront, ECS — with SSL, CDN, and monitoring wired in from day one.',
  },
  {
    label: 'Scale',
    description: 'Ongoing SEO, automation, and performance tuning as your traffic and business grow.',
  },
]

const wrapperEl = ref<HTMLElement>()
const progressLineEl = ref<HTMLElement>()
const activeIndex = ref(0)
const { prefersReducedMotion } = useReducedMotion()

let scrollTrigger: ScrollTrigger | undefined

onMounted(() => {
  if (prefersReducedMotion.value || !wrapperEl.value || !progressLineEl.value) return

  const tween = gsap.to(progressLineEl.value, {
    scaleX: 1,
    ease: 'none',
    scrollTrigger: {
      trigger: wrapperEl.value,
      start: 'top top',
      end: 'bottom bottom',
      scrub: 1,
      onUpdate: (self) => {
        activeIndex.value = Math.min(STEPS.length - 1, Math.floor(self.progress * STEPS.length))
      },
    },
  })
  scrollTrigger = tween.scrollTrigger
})

onUnmounted(() => scrollTrigger?.kill())
</script>
