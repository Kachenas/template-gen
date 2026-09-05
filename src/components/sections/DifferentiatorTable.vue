<template>
  <section
    ref="sectionEl"
    class="section-shell overflow-hidden bg-bg"
  >
    <div class="content-shell">
      <div class="mx-auto max-w-2xl text-center">
        <p class="eyebrow text-primary">
          <span class="h-1.5 w-1.5 rounded-full bg-primary" />
          Why We're Different
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Same Budget. Different League.
        </h2>
        <p class="mt-4 text-lg text-ink-dim">
          This is what actually changes when you stop hiring a template shop.
        </p>
      </div>

      <div
        ref="floatEl"
        class="glass-panel-light mx-auto mt-12 max-w-3xl overflow-hidden"
      >
        <div class="grid grid-cols-2 border-b border-border-strong/40">
          <div class="px-6 py-4 text-center text-xs font-semibold tracking-wide text-ink-faint uppercase">
            Traditional Agency
          </div>
          <div class="px-6 py-4 text-center text-xs font-semibold tracking-wide text-primary uppercase">
            VibeCheckKits
          </div>
        </div>

        <div
          v-for="(row, i) in ROWS"
          :key="row.bad"
          :ref="(el) => setRowRef(el as HTMLElement | null, i)"
          class="grid grid-cols-2 divide-x divide-border border-b border-border last:border-b-0"
        >
          <div class="flex items-center gap-3 px-6 py-4">
            <XCircleIcon class="h-5 w-5 shrink-0 text-ink-faint" />
            <span class="text-sm text-ink-dim">{{ row.bad }}</span>
          </div>
          <div class="flex items-center gap-3 px-6 py-4">
            <span
              :ref="(el) => setCheckRef(el as HTMLElement | null, i)"
              class="inline-flex shrink-0"
            >
              <CheckCircleIcon class="h-5 w-5 text-primary" />
            </span>
            <span class="text-sm font-medium text-white">{{ row.good }}</span>
          </div>
        </div>
      </div>

      <div class="mt-10 flex justify-center">
        <GlowButton href="#audit">
          See the Difference for Yourself
        </GlowButton>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { CheckCircleIcon, XCircleIcon } from '@heroicons/vue/24/outline'
import GlowButton from '@/components/ui/GlowButton.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE, STAGGER } from '@/constants/motion'

interface ComparisonRow {
  bad: string
  good: string
}

const ROWS: ComparisonRow[] = [
  { bad: 'WordPress Templates', good: 'Custom Vue + TypeScript' },
  { bad: 'Shared Hosting', good: 'AWS CloudFront + ECS + S3' },
  { bad: 'Manual Workflows', good: 'AI Automation + n8n' },
  { bad: 'Slow Sites', good: '95+ Lighthouse Scores' },
  { bad: 'SEO Bolted On Later', good: 'SEO Built Into Every Page' },
  { bad: 'Pricing Buried in Fine Print', good: 'One Flat Scope, No Upsells' },
]

const sectionEl = ref<HTMLElement>()
const floatEl = ref<HTMLElement>()
const rowRefs = ref<(HTMLElement | null)[]>([])
const checkRefs = ref<(HTMLElement | null)[]>([])

function setRowRef(el: HTMLElement | null, i: number) {
  rowRefs.value[i] = el
}
function setCheckRef(el: HTMLElement | null, i: number) {
  checkRefs.value[i] = el
}

const { prefersReducedMotion } = useReducedMotion()
let tweens: gsap.core.Tween[] = []

onMounted(() => {
  if (prefersReducedMotion.value) return

  if (floatEl.value && sectionEl.value) {
    tweens.push(
      gsap.fromTo(
        floatEl.value,
        { y: 40 },
        {
          y: -40,
          ease: 'none',
          scrollTrigger: {
            trigger: sectionEl.value,
            start: 'top bottom',
            end: 'bottom top',
            scrub: true,
          },
        },
      ),
    )
  }

  const rows = rowRefs.value.filter((el): el is HTMLElement => Boolean(el))
  const checks = checkRefs.value.filter((el): el is HTMLElement => Boolean(el))

  if (rows.length) {
    tweens.push(
      gsap.from(rows, {
        opacity: 0,
        y: 24,
        duration: DURATION.slow,
        ease: EASE.outExpo,
        stagger: STAGGER.base,
        scrollTrigger: { trigger: floatEl.value, start: 'top 80%' },
      }),
    )
  }

  if (checks.length) {
    gsap.set(checks, { opacity: 0, scale: 0.4 })
    tweens.push(
      gsap.to(checks, {
        opacity: 1,
        scale: 1,
        duration: DURATION.base,
        delay: 0.3,
        ease: 'back.out(2)',
        stagger: STAGGER.base,
        scrollTrigger: { trigger: floatEl.value, start: 'top 80%' },
      }),
    )
  }
})

onUnmounted(() => {
  tweens.forEach((t) => {
    t.scrollTrigger?.kill()
    t.kill()
  })
})
</script>
