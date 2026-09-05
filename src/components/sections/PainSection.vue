<template>
  <section
    ref="wrapperEl"
    class="relative bg-bg"
    :style="prefersReducedMotion ? {} : { height: `${PAIN_POINTS.length * 100}vh` }"
  >
    <!-- Dramatic vignette — this section deliberately withholds the brand glow. -->
    <div
      class="pointer-events-none absolute inset-0"
      style="
        background: radial-gradient(circle at 50% 45%, transparent 20%, rgba(0, 0, 0, 0.65) 100%);
      "
    />

    <div
      :class="
        cn(
          'relative flex flex-col items-center justify-center overflow-hidden px-6',
          prefersReducedMotion ? 'gap-8 py-24' : 'sticky top-0 h-screen',
        )
      "
    >
      <div
        :class="
          cn(
            'content-shell relative flex w-full flex-1 items-center justify-center',
            prefersReducedMotion && 'flex-col gap-6',
          )
        "
      >
        <div
          v-for="(point, i) in PAIN_POINTS"
          :key="point.text"
          :ref="(el) => setCardRef(el as HTMLElement | null, i)"
          :class="
            cn(
              'glass-panel-light mx-auto flex max-w-2xl flex-col items-center gap-6 px-8 py-12 text-center md:flex-row md:text-left',
              prefersReducedMotion ? 'relative opacity-100' : 'absolute inset-x-0 opacity-0',
            )
          "
        >
          <div
            class="flex h-16 w-16 shrink-0 items-center justify-center rounded-full border border-rose-400/30 bg-rose-500/10"
          >
            <component
              :is="point.icon"
              class="h-8 w-8 text-rose-300"
            />
          </div>
          <p class="font-display text-2xl font-semibold text-white md:text-3xl">
            {{ point.text }}
          </p>
        </div>
      </div>

      <div
        v-if="!prefersReducedMotion"
        class="relative flex gap-2"
      >
        <span
          v-for="(point, i) in PAIN_POINTS"
          :key="point.text"
          :class="
            cn(
              'h-1.5 w-6 rounded-full transition-colors duration-300',
              i === activeIndex ? 'bg-white/80' : 'bg-white/15',
            )
          "
        />
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import {
  ClockIcon,
  ArrowTrendingDownIcon,
  EyeSlashIcon,
  MegaphoneIcon,
} from '@heroicons/vue/24/outline'
import { cn } from '@/utils/cn'
import { useReducedMotion } from '@/composables/useReducedMotion'

const PAIN_POINTS = [
  { icon: ClockIcon, text: 'Your homepage takes 8 seconds to load.' },
  { icon: ArrowTrendingDownIcon, text: 'Google stops recommending slow websites.' },
  { icon: EyeSlashIcon, text: 'Visitors leave before seeing your offer.' },
  {
    icon: MegaphoneIcon,
    text: "You're paying for ads that send people to a website that doesn't convert.",
  },
] as const

const wrapperEl = ref<HTMLElement>()
const cardRefs = ref<(HTMLElement | null)[]>([])
const activeIndex = ref(0)
const { prefersReducedMotion } = useReducedMotion()

function setCardRef(el: HTMLElement | null, i: number) {
  cardRefs.value[i] = el
}

let scrollTrigger: ScrollTrigger | undefined

onMounted(() => {
  if (prefersReducedMotion.value || !wrapperEl.value) return

  const cards = cardRefs.value.filter((el): el is HTMLElement => Boolean(el))
  if (cards.length === 0) return

  gsap.set(cards[0]!, { opacity: 1 })

  const timeline = gsap.timeline({
    defaults: { ease: 'none', duration: 1 },
    scrollTrigger: {
      trigger: wrapperEl.value,
      start: 'top top',
      end: 'bottom bottom',
      scrub: 1,
      onUpdate: (self) => {
        activeIndex.value = Math.min(cards.length - 1, Math.floor(self.progress * cards.length))
      },
    },
  })
  scrollTrigger = timeline.scrollTrigger

  cards.forEach((card, i) => {
    if (i === 0) return
    timeline.to(cards[i - 1]!, { opacity: 0, y: -24 }, i - 1)
    timeline.fromTo(card, { opacity: 0, y: 24 }, { opacity: 1, y: 0 }, i - 1)
  })
})

onUnmounted(() => scrollTrigger?.kill())
</script>
