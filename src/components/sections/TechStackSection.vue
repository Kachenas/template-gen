<template>
  <section
    ref="sectionEl"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div class="mx-auto max-w-2xl text-center">
        <p class="eyebrow text-primary">
          <span class="h-1.5 w-1.5 rounded-full bg-primary" />
          What You Actually Get
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Not a Website. A Complete Stack.
        </h2>
        <p class="mt-4 text-lg text-ink-dim">
          No pricing tiers to decode — every project ships with the full stack below, as one
          flat scope.
        </p>
      </div>

      <div class="glass-panel-light mx-auto mt-12 max-w-2xl divide-y divide-border overflow-hidden">
        <div
          v-for="(item, i) in STACK_ITEMS"
          :key="item.label"
          :ref="(el) => setRowRef(el as HTMLElement | null, i)"
          class="flex items-center gap-4 px-6 py-4"
        >
          <div
            class="flex h-10 w-10 shrink-0 items-center justify-center rounded-full border border-primary/30 bg-primary/10"
          >
            <component
              :is="item.icon"
              class="h-5 w-5 text-primary"
            />
          </div>
          <div class="min-w-0 flex-1">
            <p class="font-display font-semibold text-white">
              {{ item.label }}
            </p>
            <p class="mt-0.5 truncate text-sm text-ink-dim">
              {{ item.description }}
            </p>
          </div>
          <CheckCircleIcon class="h-5 w-5 shrink-0 text-primary" />
        </div>
      </div>

      <p class="mx-auto mt-8 max-w-xl text-center text-ink-dim">
        Everything above. One flat scope. No "SEO add-on" upsell three months in.
      </p>

      <div class="mt-8 flex justify-center">
        <GlowButton href="#audit">
          Get My Free Audit
        </GlowButton>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, type Component } from 'vue'
import gsap from 'gsap'
import {
  GlobeAltIcon,
  MagnifyingGlassIcon,
  ChartBarIcon,
  SignalIcon,
  ServerStackIcon,
  EnvelopeIcon,
  LockClosedIcon,
  ClipboardDocumentListIcon,
  BoltIcon,
  CpuChipIcon,
  CheckCircleIcon,
} from '@heroicons/vue/24/outline'
import GlowButton from '@/components/ui/GlowButton.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE, STAGGER } from '@/constants/motion'

interface StackItem {
  label: string
  description: string
  icon: Component
}

const STACK_ITEMS: StackItem[] = [
  { label: 'Website', description: 'Custom Vue site, not a template.', icon: GlobeAltIcon },
  { label: 'SEO', description: 'Technical SEO baked into every page.', icon: MagnifyingGlassIcon },
  { label: 'Analytics', description: 'Real visitor data, not guesses.', icon: ChartBarIcon },
  {
    label: 'CloudFront CDN',
    description: 'Content served from the edge, globally.',
    icon: SignalIcon,
  },
  {
    label: 'AWS Hosting',
    description: 'S3 and ECS, provisioned with Terraform.',
    icon: ServerStackIcon,
  },
  { label: 'Email', description: 'Transactional email, delivered reliably.', icon: EnvelopeIcon },
  { label: 'SSL', description: 'HTTPS everywhere, auto-renewed.', icon: LockClosedIcon },
  {
    label: 'Forms',
    description: 'Lead capture that actually reaches you.',
    icon: ClipboardDocumentListIcon,
  },
  { label: 'Performance', description: '95+ Lighthouse, monitored continuously.', icon: BoltIcon },
  { label: 'Automation', description: 'Workflows that run without you.', icon: CpuChipIcon },
]

const sectionEl = ref<HTMLElement>()
const rowRefs = ref<(HTMLElement | null)[]>([])

function setRowRef(el: HTMLElement | null, i: number) {
  rowRefs.value[i] = el
}

const { prefersReducedMotion } = useReducedMotion()
let tween: gsap.core.Tween | undefined

onMounted(() => {
  const rows = rowRefs.value.filter((el): el is HTMLElement => Boolean(el))
  if (prefersReducedMotion.value || rows.length === 0) return

  rows.forEach((row, i) => {
    gsap.set(row, { x: i % 2 === 0 ? -24 : 24, y: 20, rotate: i % 2 === 0 ? -3 : 3, opacity: 0 })
  })

  tween = gsap.to(rows, {
    x: 0,
    y: 0,
    rotate: 0,
    opacity: 1,
    duration: DURATION.slow,
    ease: EASE.outExpo,
    stagger: STAGGER.tight,
    scrollTrigger: { trigger: sectionEl.value, start: 'top 75%' },
  })
})

onUnmounted(() => {
  tween?.scrollTrigger?.kill()
  tween?.kill()
})
</script>
