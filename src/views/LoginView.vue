<template>
  <div class="flex flex-1 items-center justify-center px-6 py-12">
    <div class="glass-panel-light w-full max-w-sm p-8">
      <h1 class="font-display text-2xl font-bold text-white">
        Log in
      </h1>
      <p class="mt-1 text-sm text-ink-dim">
        Log in to submit and track your support tickets.
      </p>

      <form
        class="mt-6 space-y-4"
        @submit.prevent="onSubmit"
      >
        <GlowInput
          v-model="form.email"
          type="email"
          label="Email"
          placeholder="you@example.com"
          autocomplete="email"
          :error-message="errors.email"
        />
        <GlowInput
          v-model="form.password"
          type="password"
          label="Password"
          placeholder="••••••••"
          autocomplete="current-password"
          :error-message="errors.password"
        />

        <GlowButton
          type="submit"
          :disabled="loading"
          class="w-full justify-center"
        >
          {{ loading ? 'Logging in…' : 'Log in' }}
        </GlowButton>
      </form>

      <p class="mt-6 text-center text-sm text-ink-dim">
        Don't have an account?
        <router-link
          to="/register"
          class="font-medium text-primary hover:underline"
        >
          Sign up
        </router-link>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { useAuth } from '@/composables/useAuth'
import { getErrorMessage } from '@/utils/errorHandler'
import type { ILoginPayload } from '@/types/authInterface'
import GlowButton from '@/components/ui/GlowButton.vue'
import GlowInput from '@/components/ui/GlowInput.vue'

const route = useRoute()
const router = useRouter()
const { login, loading } = useAuth()

const form = reactive<ILoginPayload>({ email: '', password: '' })
const errors = ref<Record<string, string>>({})

function validate(): boolean {
  errors.value = {}
  if (!form.email) errors.value.email = 'Email is required'
  if (!form.password) errors.value.password = 'Password is required'
  return Object.keys(errors.value).length === 0
}

async function onSubmit() {
  if (!validate()) return

  try {
    await login({ ...form })
    toast.success('Welcome back')
    router.push((route.query.redirect as string) || '/dashboard')
  } catch (err: unknown) {
    toast.error(getErrorMessage(err))
  }
}
</script>
