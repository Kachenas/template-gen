<template>
  <div class="flex min-h-screen flex-col bg-bg">
    <header class="border-b border-border">
      <div class="content-shell flex items-center justify-between py-4">
        <router-link
          to="/"
          class="font-display text-lg font-bold text-white"
        >
          VibeCheckKits
        </router-link>
        <nav class="flex items-center gap-4 text-sm font-medium">
          <template v-if="isAuthenticated">
            <router-link
              to="/dashboard"
              class="text-ink-dim transition-colors hover:text-white"
            >
              Dashboard
            </router-link>
          </template>
          <template v-else>
            <router-link
              to="/login"
              class="text-ink-dim transition-colors hover:text-white"
            >
              Log in
            </router-link>
            <router-link
              to="/register"
              class="btn-primary-glow inline-flex items-center gap-1.5 px-5 py-2 text-sm focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 focus-visible:ring-offset-bg focus-visible:outline-none"
            >
              Sign up
            </router-link>
          </template>
        </nav>
      </div>
    </header>

    <main class="flex flex-1 flex-col">
      <router-view />
    </main>

    <footer class="border-t border-border py-6 text-center text-sm text-ink-faint">
      &copy; {{ year }} VibeCheckKits
    </footer>
  </div>
</template>

<script setup lang="ts">
import { useAuth } from '@/composables/useAuth'

const { isAuthenticated } = useAuth()
const year = new Date().getFullYear()
</script>
