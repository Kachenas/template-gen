<template>
  <section class="relative flex min-h-[80vh] flex-col items-center justify-center overflow-hidden px-6 py-32 text-center">
    <AnimatedBackground />

    <div class="content-shell relative z-10 flex flex-col items-center">
      <p
        ref="eyebrowEl"
        class="eyebrow text-primary"
      >
        <span class="h-1.5 w-1.5 rounded-full bg-primary" />
        Ready When You Are
      </p>

      <h2
        ref="headlineEl"
        class="mt-6 max-w-4xl text-balance font-display text-5xl font-bold text-white md:text-7xl"
      >
        Let's Turn Your Website Into a
        <span class="text-glow text-primary">Sales Machine.</span>
      </h2>

      <p
        ref="subheadEl"
        class="mt-6 max-w-xl text-lg text-ink-dim md:text-xl"
      >
        One free audit. No pressure. Just a clear picture of what's costing you conversions right
        now.
      </p>

      <div
        ref="ctaEl"
        class="mt-10"
      >
        <GlowButton
          href="#audit"
          class="animate-pulse-glow"
        >
          Book a Free Website Audit
        </GlowButton>
      </div>
    </div>
  </section>

  <footer class="relative border-t border-border bg-bg">
    <div
      class="content-shell flex flex-col items-center gap-6 py-10 text-center md:flex-row md:justify-between md:text-left"
    >
      <router-link
        to="/"
        class="font-display text-lg font-bold text-white"
      >
        VibeCheckKits
      </router-link>

      <nav class="flex flex-wrap items-center justify-center gap-x-6 gap-y-2 text-sm text-ink-dim">
        <a
          href="#work"
          class="transition-colors hover:text-white"
        >Work</a>
        <a
          href="#services"
          class="transition-colors hover:text-white"
        >Services</a>
        <a
          href="#process"
          class="transition-colors hover:text-white"
        >Process</a>
        <a
          href="#faq"
          class="transition-colors hover:text-white"
        >FAQ</a>
        <a
          href="#audit"
          class="transition-colors hover:text-white"
        >Free Audit</a>
      </nav>

      <p class="text-xs text-ink-faint">
        &copy; {{ year }} VibeCheckKits. All rights reserved.
      </p>
    </div>
  </footer>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import AnimatedBackground from '@/components/ui/AnimatedBackground.vue'
import GlowButton from '@/components/ui/GlowButton.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE } from '@/constants/motion'

const year = new Date().getFullYear()

const eyebrowEl = ref<HTMLElement>()
const headlineEl = ref<HTMLElement>()
const subheadEl = ref<HTMLElement>()
const ctaEl = ref<HTMLElement>()

const { prefersReducedMotion } = useReducedMotion()
let timeline: gsap.core.Timeline | undefined

onMounted(() => {
  if (prefersReducedMotion.value) return

  timeline = gsap
    .timeline({
      defaults: { ease: EASE.outExpo },
      scrollTrigger: { trigger: headlineEl.value, start: 'top 80%' },
    })
    .from(eyebrowEl.value ?? [], { opacity: 0, y: 12, duration: DURATION.base })
    .from(
      headlineEl.value ?? [],
      { opacity: 0, y: 24, filter: 'blur(12px)', duration: DURATION.cinematic },
      '-=0.15',
    )
    .from(subheadEl.value ?? [], { opacity: 0, y: 16, duration: DURATION.slow }, '-=0.7')
    .from(ctaEl.value ?? [], { opacity: 0, y: 16, duration: DURATION.slow }, '-=0.4')
})

onUnmounted(() => {
  timeline?.scrollTrigger?.kill()
  timeline?.kill()
})
</script>
