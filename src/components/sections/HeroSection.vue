<template>
  <section class="bg-bg relative flex min-h-screen flex-col overflow-hidden">
    <AnimatedBackground />

    <div
      class="content-shell relative z-10 flex flex-1 flex-col items-center justify-center py-32 text-center"
    >
      <p
        ref="eyebrowEl"
        class="eyebrow text-primary"
      >
        <span class="bg-primary h-1.5 w-1.5 rounded-full" />
        AI-Powered Web Design Studio
      </p>

      <h1
        ref="headlineEl"
        class="mt-6 max-w-4xl text-[clamp(2.5rem,6vw,5rem)] leading-[1.05] font-bold text-balance text-white"
      >
        Your Website Should Be Your
        <span class="text-glow text-primary">Best Salesperson.</span>
      </h1>

      <p
        ref="subheadEl"
        class="text-ink-dim mt-6 max-w-2xl text-lg md:text-xl"
      >
        We build AI-powered websites that convert visitors into customers — fast, beautiful,
        SEO-ready, and built to scale on AWS.
      </p>

      <div
        ref="ctaEl"
        class="mt-10 flex flex-col gap-4 sm:flex-row"
      >
        <GlowButton href="#audit">
          Book a Free Website Audit
        </GlowButton>
        <GlowButton
          href="#work"
          variant="secondary"
        >
          See Live Projects
        </GlowButton>
      </div>

      <!-- Mobile: simple flow row. Desktop: scattered/floating (see the absolute block below). -->
      <div class="mt-12 flex max-w-md flex-wrap items-center justify-center gap-3 md:hidden">
        <FloatingGlassCard :delay="0.9">
          <MetricCounter
            :value="300"
            prefix="+"
            suffix="% Faster Websites"
          />
        </FloatingGlassCard>
        <FloatingGlassCard :delay="1.05">
          <MetricCounter
            :value="95"
            suffix="+ Lighthouse Scores"
          />
        </FloatingGlassCard>
        <FloatingGlassCard :delay="1.2">
          AI Automation
        </FloatingGlassCard>
        <FloatingGlassCard :delay="1.35">
          AWS Cloud Ready
        </FloatingGlassCard>
      </div>
    </div>

    <div class="pointer-events-none absolute inset-0 z-10 hidden md:block">
      <FloatingGlassCard
        :delay="0.9"
        class="absolute top-[20%] left-[4%]"
      >
        <MetricCounter
          :value="300"
          prefix="+"
          suffix="% Faster Websites"
        />
      </FloatingGlassCard>
      <FloatingGlassCard
        :delay="1.05"
        class="absolute top-[38%] right-[4%]"
      >
        <MetricCounter
          :value="95"
          suffix="+ Lighthouse Scores"
        />
      </FloatingGlassCard>
      <FloatingGlassCard
        :delay="1.2"
        class="absolute bottom-[16%] left-[16%]"
      >
        AI Automation
      </FloatingGlassCard>
      <FloatingGlassCard
        :delay="1.35"
        class="absolute right-[14%] bottom-[10%]"
      >
        AWS Cloud Ready
      </FloatingGlassCard>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import AnimatedBackground from '@/components/ui/AnimatedBackground.vue'
import FloatingGlassCard from '@/components/ui/FloatingGlassCard.vue'
import GlowButton from '@/components/ui/GlowButton.vue'
import MetricCounter from '@/components/ui/MetricCounter.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE } from '@/constants/motion'

const eyebrowEl = ref<HTMLElement>()
const headlineEl = ref<HTMLElement>()
const subheadEl = ref<HTMLElement>()
const ctaEl = ref<HTMLElement>()

const { prefersReducedMotion } = useReducedMotion()

let timeline: gsap.core.Timeline | undefined

onMounted(() => {
  if (prefersReducedMotion.value) return

  timeline = gsap
    .timeline({ defaults: { ease: EASE.outExpo } })
    .from(eyebrowEl.value ?? [], { opacity: 0, y: 12, duration: DURATION.base })
    .from(
      headlineEl.value ?? [],
      { opacity: 0, y: 24, filter: 'blur(12px)', duration: DURATION.cinematic },
      '-=0.15',
    )
    .from(subheadEl.value ?? [], { opacity: 0, y: 16, duration: DURATION.slow }, '-=0.7')
    .from(ctaEl.value ?? [], { opacity: 0, y: 16, duration: DURATION.slow }, '-=0.4')
})

onUnmounted(() => timeline?.kill())
</script>
