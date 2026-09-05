<template>
  <section
    id="work"
    ref="sectionEl"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div class="mx-auto max-w-2xl text-center">
        <p class="eyebrow text-glow-emerald">
          <span class="h-1.5 w-1.5 rounded-full bg-glow-emerald" />
          Real Results
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Built for Real Businesses.
        </h2>
        <p class="mt-4 text-lg text-ink-dim">
          Five rebuilds, five different industries, one thing in common: measurable results.
        </p>
      </div>

      <div class="mt-12 flex flex-col gap-4">
        <div
          v-for="(study, i) in CASE_STUDIES"
          :key="study.id"
          :ref="(el) => setRowRef(el as HTMLElement | null, i)"
          class="glass-panel-light overflow-hidden rounded-2xl"
        >
          <button
            type="button"
            class="flex w-full items-center justify-between gap-4 px-6 py-5 text-left focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-glow-emerald"
            :aria-expanded="activeId === study.id"
            @click="toggle(study.id)"
          >
            <div class="flex flex-col gap-1 sm:flex-row sm:items-center sm:gap-4">
              <span class="font-mono text-xs text-glow-emerald">{{ study.industry }}</span>
              <span class="font-display text-lg font-semibold text-white md:text-xl">{{
                study.title
              }}</span>
            </div>
            <ChevronDownIcon
              :class="
                cn(
                  'h-5 w-5 shrink-0 text-ink-dim transition-transform duration-300',
                  activeId === study.id && 'rotate-180',
                )
              "
            />
          </button>

          <div
            :class="
              cn(
                'grid transition-[grid-template-rows] duration-500 ease-out-expo',
                activeId === study.id ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]',
              )
            "
          >
            <div class="overflow-hidden">
              <div class="px-6 pb-8">
                <div class="grid gap-8 md:grid-cols-2 md:items-center">
                  <div
                    class="flex items-end justify-center gap-4"
                    @mousemove="handleTilt"
                    @mouseleave="resetTilt"
                  >
                    <div
                      class="w-full max-w-xs rounded-lg border border-border-strong/40 bg-surface shadow-glass transition-transform duration-200"
                    >
                      <div class="flex items-center gap-1.5 border-b border-border-strong/40 px-3 py-2">
                        <span class="h-2 w-2 rounded-full bg-white/15" />
                        <span class="h-2 w-2 rounded-full bg-white/15" />
                        <span class="h-2 w-2 rounded-full bg-white/15" />
                      </div>
                      <div class="flex flex-col gap-2 p-4">
                        <div class="h-14 w-full rounded bg-glow-emerald/15" />
                        <div class="h-3 w-2/3 rounded bg-white/15" />
                        <div class="h-2.5 w-full rounded bg-white/5" />
                        <div class="h-2.5 w-5/6 rounded bg-white/5" />
                      </div>
                    </div>
                    <div
                      class="h-28 w-14 shrink-0 rounded-xl border border-border-strong/40 bg-surface p-1.5 shadow-glass"
                    >
                      <div class="flex h-full flex-col gap-1.5 rounded-lg bg-bg-elevated p-1.5">
                        <div class="h-6 w-full rounded bg-glow-emerald/20" />
                        <div class="h-1.5 w-2/3 rounded bg-white/15" />
                        <div class="h-1.5 w-full rounded bg-white/5" />
                      </div>
                    </div>
                  </div>

                  <div class="grid grid-cols-2 gap-3">
                    <div
                      v-for="metric in study.metrics"
                      :key="metric.label"
                      class="glass-panel-light rounded-xl px-4 py-3 text-center"
                    >
                      <p class="font-display text-2xl font-bold text-glow-emerald">
                        <MetricCounter
                          :value="metric.value"
                          :prefix="metric.prefix ?? ''"
                          :suffix="metric.suffix ?? ''"
                          :decimals="metric.decimals ?? 0"
                        />
                      </p>
                      <p class="mt-1 text-[0.65rem] tracking-wide text-ink-dim uppercase">
                        {{ metric.label }}
                      </p>
                    </div>
                  </div>
                </div>

                <div class="mt-8 grid gap-6 sm:grid-cols-2">
                  <div>
                    <p class="text-xs font-semibold tracking-wide text-ink-faint uppercase">
                      Problem
                    </p>
                    <p class="mt-2 text-sm text-ink-dim">
                      {{ study.problem }}
                    </p>
                  </div>
                  <div>
                    <p class="text-xs font-semibold tracking-wide text-glow-emerald uppercase">
                      Solution
                    </p>
                    <p class="mt-2 text-sm text-ink-dim">
                      {{ study.solution }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-14 flex justify-center">
        <GlowButton href="#audit">
          Get Results Like These
        </GlowButton>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
import GlowButton from '@/components/ui/GlowButton.vue'
import MetricCounter from '@/components/ui/MetricCounter.vue'
import { cn } from '@/utils/cn'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE, STAGGER } from '@/constants/motion'

interface Metric {
  label: string
  value: number
  prefix?: string
  suffix?: string
  decimals?: number
}

interface CaseStudy {
  id: string
  industry: string
  title: string
  problem: string
  solution: string
  metrics: Metric[]
}

const CASE_STUDIES: CaseStudy[] = [
  {
    id: 'hotel',
    industry: 'Hospitality',
    title: 'Hotel & Resort Site',
    problem: 'Bookings only came through phone calls — no way to check availability online.',
    solution:
      'A booking-first site with live availability, instant confirmation, and mobile checkout in under 30 seconds.',
    metrics: [
      { label: 'Bookings', value: 210, prefix: '+', suffix: '%' },
      { label: 'Load Time', value: 1.1, suffix: 's', decimals: 1 },
    ],
  },
  {
    id: 'dashboard',
    industry: 'SaaS',
    title: 'Startup Dashboard',
    problem: 'Founders tracked metrics across three spreadsheets shared over Slack.',
    solution: 'A real-time analytics dashboard wired directly into their product data.',
    metrics: [
      { label: 'Reporting Time', value: 80, prefix: '-', suffix: '%' },
      { label: 'Metrics Automated', value: 12, suffix: '' },
    ],
  },
  {
    id: 'ecommerce',
    industry: 'E-Commerce',
    title: 'E-Commerce Rebuild',
    problem: 'Checkout took six steps and cart abandonment sat above 70%.',
    solution: 'A two-step checkout with saved payment methods and one-click reorder.',
    metrics: [
      { label: 'Conversions', value: 64, prefix: '+', suffix: '%' },
      { label: 'Cart Abandonment', value: 35, prefix: '-', suffix: '%' },
    ],
  },
  {
    id: 'booking',
    industry: 'Services',
    title: 'Booking Platform',
    problem: 'Manual scheduling over email and phone caused double-bookings every week.',
    solution: 'A booking platform with real-time calendar sync and automated reminders.',
    metrics: [
      { label: 'Double-Bookings', value: 0, suffix: '' },
      { label: 'Repeat Clients', value: 45, prefix: '+', suffix: '%' },
    ],
  },
  {
    id: 'automation',
    industry: 'AI Automation',
    title: 'Lead Automation Build',
    problem: 'Leads sat in a shared inbox for days before anyone followed up.',
    solution: 'An n8n workflow that qualifies, routes, and follows up with new leads instantly.',
    metrics: [
      { label: 'Response Time', value: 2, prefix: '<', suffix: 'min' },
      { label: 'Lead-to-Close', value: 38, prefix: '+', suffix: '%' },
    ],
  },
]

const activeId = ref(CASE_STUDIES[0]!.id)

function toggle(id: string) {
  activeId.value = id
}

const { prefersReducedMotion } = useReducedMotion()

function handleTilt(e: MouseEvent) {
  if (prefersReducedMotion.value) return
  const el = e.currentTarget as HTMLElement
  const rect = el.getBoundingClientRect()
  const px = (e.clientX - rect.left) / rect.width - 0.5
  const py = (e.clientY - rect.top) / rect.height - 0.5
  const laptop = el.firstElementChild as HTMLElement | null
  if (laptop) laptop.style.transform = `perspective(800px) rotateY(${px * 8}deg) rotateX(${-py * 8}deg)`
}

function resetTilt(e: MouseEvent) {
  const el = e.currentTarget as HTMLElement
  const laptop = el.firstElementChild as HTMLElement | null
  if (laptop) laptop.style.transform = ''
}

const sectionEl = ref<HTMLElement>()
const rowRefs = ref<(HTMLElement | null)[]>([])

function setRowRef(el: HTMLElement | null, i: number) {
  rowRefs.value[i] = el
}

let tween: gsap.core.Tween | undefined

onMounted(() => {
  const rows = rowRefs.value.filter((el): el is HTMLElement => Boolean(el))
  if (prefersReducedMotion.value || rows.length === 0) return
  tween = gsap.from(rows, {
    opacity: 0,
    y: 32,
    duration: DURATION.slow,
    ease: EASE.outExpo,
    stagger: STAGGER.base,
    scrollTrigger: { trigger: sectionEl.value, start: 'top 80%' },
  })
})

onUnmounted(() => {
  tween?.scrollTrigger?.kill()
  tween?.kill()
})
</script>
