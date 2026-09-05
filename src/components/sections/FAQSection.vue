<template>
  <section
    id="faq"
    ref="sectionEl"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div class="mx-auto max-w-2xl text-center">
        <p class="eyebrow text-ink-dim">
          <span class="h-1.5 w-1.5 rounded-full bg-ink-faint" />
          Common Questions
        </p>
        <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
          Still Have Questions?
        </h2>
      </div>

      <div class="mx-auto mt-12 flex max-w-2xl flex-col gap-4">
        <div
          v-for="(item, i) in FAQS"
          :key="item.question"
          :ref="(el) => setItemRef(el as HTMLElement | null, i)"
        >
          <Disclosure
            v-slot="{ open }"
            as="div"
            class="glass-panel-light overflow-hidden"
          >
            <DisclosureButton
              class="flex w-full items-center justify-between gap-4 px-6 py-5 text-left focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary"
            >
              <span class="font-display font-semibold text-white">{{ item.question }}</span>
              <ChevronDownIcon
                :class="
                  cn(
                    'h-5 w-5 shrink-0 text-ink-faint transition-transform duration-300',
                    open && 'rotate-180',
                  )
                "
              />
            </DisclosureButton>

            <div
              :class="
                cn(
                  'grid transition-[grid-template-rows] duration-400 ease-out-expo',
                  open ? 'grid-rows-[1fr]' : 'grid-rows-[0fr]',
                )
              "
            >
              <div class="overflow-hidden">
                <DisclosurePanel
                  static
                  class="px-6 pb-5 text-ink-dim"
                >
                  {{ item.answer }}
                </DisclosurePanel>
              </div>
            </div>
          </Disclosure>
        </div>
      </div>

      <p class="mt-10 text-center text-ink-dim">
        Still have questions?
        <a
          href="#audit"
          class="font-medium text-primary hover:underline"
        >Book a discovery call</a>.
      </p>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { Disclosure, DisclosureButton, DisclosurePanel } from '@headlessui/vue'
import { ChevronDownIcon } from '@heroicons/vue/24/outline'
import { cn } from '@/utils/cn'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { DURATION, EASE, STAGGER } from '@/constants/motion'

interface Faq {
  question: string
  answer: string
}

const FAQS: Faq[] = [
  {
    question: 'How fast can you ship a site?',
    answer:
      'Most builds ship in 2-4 weeks from Discover to Deploy, depending on scope. The free audit gives us enough to quote an exact timeline.',
  },
  {
    question: 'Do you handle hosting and domains?',
    answer:
      'Yes — every project ships on AWS (S3, CloudFront, ECS) that we provision and manage. Point your existing domain at it or register a new one, either way.',
  },
  {
    question: 'What does the free audit actually check?',
    answer:
      'SEO health, page speed, mobile UX, and where AI automation could save you the most time — the same checklist from the audit section above.',
  },
  {
    question: 'Can you redesign an existing site without breaking my SEO?',
    answer:
      'Yes. We map every existing URL to its new equivalent and set up redirects before launch, so rankings carry over instead of resetting.',
  },
  {
    question: 'Do I own the code?',
    answer: "Yes, fully. It's a custom build in your own repository, not a locked page builder.",
  },
  {
    question: 'What if I need changes after launch?',
    answer:
      'Every project includes a support window after launch, and ongoing retainers are available for teams that want continuous updates.',
  },
]

const sectionEl = ref<HTMLElement>()
const itemRefs = ref<(HTMLElement | null)[]>([])

function setItemRef(el: HTMLElement | null, i: number) {
  itemRefs.value[i] = el
}

const { prefersReducedMotion } = useReducedMotion()
let tween: gsap.core.Tween | undefined

onMounted(() => {
  const items = itemRefs.value.filter((el): el is HTMLElement => Boolean(el))
  if (prefersReducedMotion.value || items.length === 0) return

  tween = gsap.from(items, {
    opacity: 0,
    y: 24,
    duration: DURATION.slow,
    ease: EASE.outExpo,
    stagger: STAGGER.tight,
    scrollTrigger: { trigger: sectionEl.value, start: 'top 80%' },
  })
})

onUnmounted(() => {
  tween?.scrollTrigger?.kill()
  tween?.kill()
})
</script>
