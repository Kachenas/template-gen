<template>
  <section
    id="audit"
    class="section-shell bg-bg"
  >
    <div class="content-shell">
      <div
        ref="panelEl"
        class="glass-panel mx-auto max-w-4xl p-8 shadow-[var(--shadow-glow-sm)] transition-shadow duration-500 hover:shadow-[var(--shadow-glow-md)] md:p-14"
      >
        <div class="grid gap-12 md:grid-cols-2 md:items-center">
          <div>
            <p class="eyebrow text-primary">
              <span class="h-1.5 w-1.5 rounded-full bg-primary" />
              No Cost. No Catch.
            </p>
            <h2 class="mt-4 text-balance font-display text-4xl font-bold text-white md:text-5xl">
              Get Your Free Website Audit.
            </h2>
            <p class="mt-4 text-lg text-ink-dim">
              SEO, speed, UX, and AI opportunities — reviewed by a person, not a bot, within 24
              hours.
            </p>

            <ul class="mt-8 flex flex-col gap-3">
              <li
                v-for="item in INCLUDES"
                :key="item"
                class="flex items-center gap-3"
              >
                <CheckCircleIcon class="h-5 w-5 shrink-0 text-primary" />
                <span class="text-ink-dim">{{ item }}</span>
              </li>
            </ul>
          </div>

          <div>
            <Transition
              enter-active-class="transition duration-300 ease-out"
              enter-from-class="opacity-0"
              enter-to-class="opacity-100"
              mode="out-in"
            >
              <div
                v-if="current"
                key="success"
                class="glass-panel-light p-8 text-center"
              >
                <CheckCircleIcon class="mx-auto h-12 w-12 text-primary" />
                <h3 class="mt-4 font-display text-xl font-bold text-white">
                  You're all set.
                </h3>
                <p class="mt-2 text-ink-dim">
                  We'll email your audit to <span class="text-white">{{ current.email }}</span>
                  within 24 hours.
                </p>
              </div>

              <form
                v-else
                key="form"
                class="flex flex-col gap-4"
                novalidate
                @submit.prevent="onSubmit"
              >
                <div>
                  <label
                    for="audit-name"
                    class="mb-1.5 block text-sm font-medium text-ink-dim"
                  >
                    Name
                  </label>
                  <input
                    id="audit-name"
                    v-model="form.name"
                    type="text"
                    autocomplete="name"
                    placeholder="Jane Cooper"
                    :class="inputClass"
                  >
                  <p
                    v-if="errors.name"
                    class="mt-1 text-xs text-rose-300"
                  >
                    {{ errors.name }}
                  </p>
                </div>

                <div>
                  <label
                    for="audit-email"
                    class="mb-1.5 block text-sm font-medium text-ink-dim"
                  >
                    Work Email
                  </label>
                  <input
                    id="audit-email"
                    v-model="form.email"
                    type="email"
                    autocomplete="email"
                    placeholder="jane@yourbusiness.com"
                    :class="inputClass"
                  >
                  <p
                    v-if="errors.email"
                    class="mt-1 text-xs text-rose-300"
                  >
                    {{ errors.email }}
                  </p>
                </div>

                <div>
                  <label
                    for="audit-website"
                    class="mb-1.5 block text-sm font-medium text-ink-dim"
                  >
                    Website URL
                  </label>
                  <input
                    id="audit-website"
                    v-model="form.website"
                    type="text"
                    autocomplete="url"
                    placeholder="yourbusiness.com"
                    :class="inputClass"
                  >
                  <p
                    v-if="errors.website"
                    class="mt-1 text-xs text-rose-300"
                  >
                    {{ errors.website }}
                  </p>
                </div>

                <GlowButton
                  type="submit"
                  :disabled="loading"
                  class="mt-2 w-full justify-center"
                >
                  {{ loading ? 'Sending…' : 'Get My Free Audit' }}
                </GlowButton>

                <p class="text-center text-xs text-ink-faint">
                  No spam. No sales calls. Just the audit.
                </p>
              </form>
            </Transition>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import gsap from 'gsap'
import { toast } from 'vue-sonner'
import { CheckCircleIcon } from '@heroicons/vue/24/outline'
import GlowButton from '@/components/ui/GlowButton.vue'
import { useAudit } from '@/composables/useAudit'
import { useReducedMotion } from '@/composables/useReducedMotion'
import { getErrorMessage } from '@/utils/errorHandler'
import { DURATION, EASE } from '@/constants/motion'

const INCLUDES = ['SEO report', 'Speed report', 'UX report', 'AI opportunities', 'Mobile optimization']

const inputClass =
  'w-full rounded-xl border border-border-strong bg-white/5 px-4 py-2.5 text-sm text-white outline-none transition-colors placeholder:text-muted focus:border-primary focus:ring-2 focus:ring-primary/20'

const panelEl = ref<HTMLElement>()
const { form, current, loading, submit } = useAudit()
const { prefersReducedMotion } = useReducedMotion()

const errors = ref<Record<string, string>>({})

let tween: gsap.core.Tween | undefined

onMounted(() => {
  if (prefersReducedMotion.value || !panelEl.value) return
  tween = gsap.from(panelEl.value, {
    opacity: 0,
    y: 40,
    scale: 0.96,
    duration: DURATION.cinematic,
    ease: EASE.outExpo,
    scrollTrigger: { trigger: panelEl.value, start: 'top 80%' },
  })
})

onUnmounted(() => {
  tween?.scrollTrigger?.kill()
  tween?.kill()
})

function validate(): boolean {
  errors.value = {}
  if (!form.name.trim()) errors.value.name = 'Name is required'
  if (!form.email.trim()) errors.value.email = 'Email is required'
  else if (!/^\S+@\S+\.\S+$/.test(form.email)) errors.value.email = 'Enter a valid email'
  if (!form.website.trim()) errors.value.website = 'Website URL is required'
  return Object.keys(errors.value).length === 0
}

async function onSubmit() {
  if (!validate()) return

  try {
    await submit()
    toast.success("You're all set — check your inbox soon.")
  } catch (err: unknown) {
    toast.error(getErrorMessage(err))
  }
}
</script>
