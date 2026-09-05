<template>
  <div class="flex flex-1 items-center justify-center px-6 py-12">
    <div class="glass-panel-light w-full max-w-sm p-8">
      <h1 class="font-display text-2xl font-bold text-white">
        Create an account
      </h1>
      <p class="mt-1 text-sm text-ink-dim">
        Register to submit and track your support tickets.
      </p>

      <form
        class="mt-6 space-y-4"
        @submit.prevent="onSubmit"
      >
        <GlowInput
          v-model="form.name"
          label="Name"
          placeholder="Jane Customer"
          :error-message="errors.name"
        />
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
          autocomplete="new-password"
          :error-message="errors.password"
        />
        <GlowInput
          v-model="form.password_confirmation"
          type="password"
          label="Confirm password"
          placeholder="••••••••"
          autocomplete="new-password"
          :error-message="errors.password_confirmation"
        />

        <GlowButton
          type="submit"
          :disabled="loading"
          class="w-full justify-center"
        >
          {{ loading ? 'Creating account…' : 'Sign up' }}
        </GlowButton>
      </form>

      <p class="mt-6 text-center text-sm text-ink-dim">
        Already have an account?
        <router-link
          to="/login"
          class="font-medium text-primary hover:underline"
        >
          Log in
        </router-link>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { useAuth } from '@/composables/useAuth'
import { getErrorMessage } from '@/utils/errorHandler'
import type { IRegisterPayload } from '@/types/authInterface'
import GlowButton from '@/components/ui/GlowButton.vue'
import GlowInput from '@/components/ui/GlowInput.vue'

const router = useRouter()
const { register, loading } = useAuth()

const form = reactive<IRegisterPayload>({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
})
const errors = ref<Record<string, string>>({})

function validate(): boolean {
  errors.value = {}
  if (!form.name) errors.value.name = 'Name is required'
  if (!form.email) errors.value.email = 'Email is required'
  if (!form.password) errors.value.password = 'Password is required'
  if (form.password && form.password !== form.password_confirmation) {
    errors.value.password_confirmation = 'Passwords do not match'
  }
  return Object.keys(errors.value).length === 0
}

async function onSubmit() {
  if (!validate()) return

  try {
    await register({ ...form })
    toast.success('Account created')
    router.push('/dashboard')
  } catch (err: unknown) {
    toast.error(getErrorMessage(err))
  }
}
</script>
