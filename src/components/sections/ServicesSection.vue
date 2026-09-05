<template>
  <section
    id="services"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div class="mx-auto max-w-2xl text-center">
        <p class="eyebrow text-primary">
          <span class="h-1.5 w-1.5 rounded-full bg-primary" />
          What We Build
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Every Service Is Its Own Experience.
        </h2>
        <p class="mt-4 text-lg text-ink-dim">
          Not a checklist of deliverables — six things we build that actually move revenue.
        </p>
      </div>

      <div class="mt-8 divide-y divide-border">
        <!-- 1. AI Websites -->
        <ServiceRow
          kicker="Scrolling Mockup"
          title="AI Websites"
          description="Websites built with AI-assisted design and copy, then hand-tuned by us — live in days, not months."
          :icon="GlobeAltIcon"
        >
          <div class="glass-panel-light overflow-hidden rounded-2xl">
            <div class="flex items-center gap-2 border-b border-border-strong/40 px-4 py-3">
              <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
              <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
              <span class="h-2.5 w-2.5 rounded-full bg-white/15" />
              <span class="ml-3 font-mono text-[0.65rem] text-muted">yoursite.ai</span>
            </div>
            <div class="relative h-64 overflow-hidden">
              <div
                ref="mockupScrollEl"
                class="absolute inset-x-0 top-0 flex flex-col gap-3 p-5"
              >
                <div class="h-20 w-full rounded-lg bg-primary/20" />
                <div class="h-4 w-1/2 rounded bg-white/20" />
                <div class="h-3 w-full rounded bg-white/10" />
                <div class="h-3 w-5/6 rounded bg-white/10" />
                <div class="mt-2 grid grid-cols-3 gap-2">
                  <div class="h-16 rounded bg-white/10" />
                  <div class="h-16 rounded bg-white/10" />
                  <div class="h-16 rounded bg-white/10" />
                </div>
                <div class="mt-2 h-16 w-full rounded-lg bg-white/10" />
                <div class="h-3 w-2/3 rounded bg-white/10" />
                <div class="h-24 w-full rounded-lg bg-white/10" />
              </div>
            </div>
          </div>
        </ServiceRow>

        <!-- 2. Landing Pages -->
        <ServiceRow
          kicker="Interactive Conversion Funnel"
          title="Landing Pages"
          description="Every landing page is built around one job: turning a click into a booked call, tracked stage by stage."
          :icon="FunnelIcon"
          reverse
        >
          <div class="glass-panel-light flex flex-col gap-4 rounded-2xl p-6">
            <div
              v-for="stage in FUNNEL"
              :key="stage.label"
              class="group cursor-default"
            >
              <div class="mb-1 flex items-center justify-between text-sm">
                <span class="font-medium text-white">{{ stage.label }}</span>
                <span class="text-ink-dim">{{ stage.pct }}%</span>
              </div>
              <div class="h-3 w-full overflow-hidden rounded-full bg-white/5">
                <div
                  class="h-full rounded-full bg-primary/70 transition-[width] duration-300 group-hover:bg-primary"
                  :style="{ width: `${stage.pct}%` }"
                />
              </div>
            </div>
            <p class="mt-1 text-xs text-ink-dim">
              Hover a stage to see where visitors drop off.
            </p>
          </div>
        </ServiceRow>

        <!-- 3. SEO -->
        <ServiceRow
          kicker="Animated Google Search"
          title="SEO"
          description="Technical SEO baked into the build — not bolted on after. We've moved client sites from page 2 to the top result."
          :icon="MagnifyingGlassIcon"
        >
          <div class="glass-panel-light rounded-2xl p-5">
            <div
              class="mb-4 flex items-center gap-2 rounded-full border border-border-strong/40 px-4 py-2"
            >
              <MagnifyingGlassIcon class="h-4 w-4 text-muted" />
              <span class="font-mono text-xs text-ink-dim">best hotel website near me</span>
            </div>
            <div class="flex flex-col gap-2">
              <div class="h-8 w-full rounded bg-white/5" />
              <div class="h-8 w-11/12 rounded bg-white/5" />
              <div
                ref="serpRowEl"
                class="flex h-10 items-center gap-2 rounded-lg border border-primary/40 bg-primary/10 px-3"
              >
                <span class="rounded-full bg-primary px-2 py-0.5 text-[0.65rem] font-bold text-[#04120f]">#1</span>
                <span class="text-sm font-medium text-white">Your Hotel — VibeCheckKits Client</span>
              </div>
            </div>
          </div>
        </ServiceRow>

        <!-- 4. AI Automation (purple exception) -->
        <ServiceRow
          kicker="Workflow Animation"
          title="AI Automation"
          description="Leads route themselves. Follow-ups send themselves. We wire n8n workflows so nothing falls through."
          :icon="BoltIcon"
          glow="purple"
          reverse
        >
          <div class="glass-panel-light rounded-2xl p-6">
            <svg
              viewBox="0 0 400 120"
              class="w-full"
              aria-hidden="true"
            >
              <path
                v-for="(seg, i) in WORKFLOW_LINES"
                :key="i"
                :ref="(el) => setLineRef(el as SVGPathElement | null, i)"
                :d="seg"
                fill="none"
                stroke="var(--color-glow-purple)"
                stroke-width="2"
                stroke-linecap="round"
              />
              <g
                v-for="node in WORKFLOW_NODES"
                :key="node.label"
              >
                <circle
                  :cx="node.x"
                  :cy="node.y"
                  r="22"
                  fill="var(--color-surface)"
                  stroke="var(--color-glow-purple)"
                  stroke-width="1.5"
                />
                <text
                  :x="node.x"
                  :y="node.y + 40"
                  text-anchor="middle"
                  font-size="10"
                  fill="var(--color-ink-dim)"
                >
                  {{ node.label }}
                </text>
              </g>
            </svg>
          </div>
        </ServiceRow>

        <!-- 5. Cloud Infrastructure -->
        <ServiceRow
          kicker="AWS Architecture Visualization"
          title="Cloud Infrastructure"
          description="S3, CloudFront, ECS, and RDS — provisioned with Terraform so scaling is a config change, not a rebuild."
          :icon="CloudIcon"
        >
          <div class="glass-panel-light relative rounded-2xl p-6">
            <div class="flex items-center justify-between">
              <div
                v-for="node in ['S3', 'CloudFront', 'ECS', 'RDS']"
                :key="node"
                class="flex h-14 w-16 items-center justify-center rounded-lg border border-border-strong/40 bg-bg-elevated text-xs font-semibold text-ink-dim"
              >
                {{ node }}
              </div>
            </div>
            <div class="relative mt-[-38px] mb-[24px] h-px bg-border-strong/40">
              <div
                v-if="!prefersReducedMotion"
                ref="pulseEl"
                class="absolute top-1/2 left-[4%] h-2 w-2 -translate-y-1/2 rounded-full bg-primary shadow-glow-sm"
              />
            </div>
            <p class="mt-6 text-xs text-ink-dim">
              Traffic flows edge-to-database, fully managed.
            </p>
          </div>
        </ServiceRow>

        <!-- 6. Custom Systems -->
        <ServiceRow
          kicker="Dashboard Mockups"
          title="Custom Systems"
          description="Internal tools, booking dashboards, client portals — bespoke software when off-the-shelf stops fitting."
          :icon="Squares2X2Icon"
          reverse
        >
          <div class="glass-panel-light flex overflow-hidden rounded-2xl">
            <div class="flex w-14 flex-col gap-2 border-r border-border-strong/40 bg-bg-elevated p-3">
              <div class="h-2 w-full rounded-full bg-primary/60" />
              <div class="h-2 w-full rounded-full bg-white/10" />
              <div class="h-2 w-full rounded-full bg-white/10" />
              <div class="h-2 w-full rounded-full bg-white/10" />
            </div>
            <div class="flex-1 p-4">
              <div class="grid grid-cols-3 gap-2">
                <div
                  v-for="stat in DASHBOARD_STATS"
                  :key="stat.label"
                  class="rounded-lg bg-white/5 px-2 py-3 text-center"
                >
                  <p class="font-display text-lg font-bold text-primary">
                    <MetricCounter
                      :value="stat.value"
                      :suffix="stat.suffix"
                      :decimals="stat.decimals ?? 0"
                    />
                  </p>
                  <p class="mt-1 text-[0.6rem] text-ink-dim uppercase">
                    {{ stat.label }}
                  </p>
                </div>
              </div>
              <div class="mt-3 flex h-16 items-end gap-1.5">
                <div
                  v-for="(h, i) in [40, 65, 50, 80, 60, 90]"
                  :key="i"
                  class="flex-1 rounded-t bg-primary/40"
                  :style="{ height: `${h}%` }"
                />
              </div>
            </div>
          </div>
        </ServiceRow>
      </div>

      <div class="mt-16 flex justify-center">
        <GlowButton href="#audit">
          See How We'd Improve Yours
        </GlowButton>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import {
  GlobeAltIcon,
  FunnelIcon,
  MagnifyingGlassIcon,
  BoltIcon,
  CloudIcon,
  Squares2X2Icon,
} from '@heroicons/vue/24/outline'
import ServiceRow from '@/components/sections/ServiceRow.vue'
import GlowButton from '@/components/ui/GlowButton.vue'
import MetricCounter from '@/components/ui/MetricCounter.vue'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { EASE } from '@/constants/motion'

const FUNNEL = [
  { label: 'Visitors', pct: 100 },
  { label: 'Leads', pct: 42 },
  { label: 'Customers', pct: 18 },
]

const WORKFLOW_NODES = [
  { label: 'Lead Form', x: 40, y: 40 },
  { label: 'n8n', x: 150, y: 40 },
  { label: 'CRM', x: 260, y: 40 },
  { label: 'Email / SMS', x: 360, y: 40 },
]

const WORKFLOW_LINES = ['M62,40 L128,40', 'M172,40 L238,40', 'M282,40 L338,40']

interface DashboardStat {
  label: string
  value: number
  suffix: string
  decimals?: number
}

const DASHBOARD_STATS: DashboardStat[] = [
  { label: 'Bookings', value: 128, suffix: '' },
  { label: 'Revenue', value: 24, suffix: 'k' },
  { label: 'Uptime', value: 99.9, suffix: '%', decimals: 1 },
]

const { prefersReducedMotion } = useReducedMotion()

const mockupScrollEl = ref<HTMLElement>()
const serpRowEl = ref<HTMLElement>()
const pulseEl = ref<HTMLElement>()
const lineRefs = ref<(SVGPathElement | null)[]>([])

function setLineRef(el: SVGPathElement | null, i: number) {
  lineRefs.value[i] = el
}

let tweens: gsap.core.Tween[] = []

onMounted(() => {
  if (prefersReducedMotion.value) return

  if (mockupScrollEl.value) {
    tweens.push(
      gsap.to(mockupScrollEl.value, {
        y: -140,
        duration: 6,
        ease: 'sine.inOut',
        repeat: -1,
        yoyo: true,
        scrollTrigger: { trigger: mockupScrollEl.value, start: 'top 85%' },
      }),
    )
  }

  if (serpRowEl.value) {
    tweens.push(
      gsap.fromTo(
        serpRowEl.value,
        { y: 72, opacity: 0.3 },
        {
          y: 0,
          opacity: 1,
          duration: 1,
          ease: EASE.outExpo,
          scrollTrigger: { trigger: serpRowEl.value, start: 'top 85%' },
        },
      ),
    )
  }

  lineRefs.value
    .filter((el): el is SVGPathElement => Boolean(el))
    .forEach((line, i) => {
      const length = line.getTotalLength()
      gsap.set(line, { strokeDasharray: length, strokeDashoffset: length })
      tweens.push(
        gsap.to(line, {
          strokeDashoffset: 0,
          duration: 0.6,
          delay: i * 0.2,
          ease: EASE.outExpo,
          scrollTrigger: { trigger: line, start: 'top 85%' },
        }),
      )
    })

  if (pulseEl.value) {
    tweens.push(
      gsap.to(pulseEl.value, {
        left: '92%',
        duration: 2.4,
        ease: 'power1.inOut',
        repeat: -1,
        yoyo: true,
        scrollTrigger: { trigger: pulseEl.value, start: 'top 85%' },
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
