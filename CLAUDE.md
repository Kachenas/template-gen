# Sample Frontend — Claude Configuration

## Stack

| Layer            | Technology                                        |
| ----------------- | -------------------------------------------------- |
| Framework        | Vue 3.5 (`<script setup lang="ts">`)              |
| Language         | TypeScript ~6.0 (strict)                          |
| Build            | Vite 8                                            |
| State Management | Pinia 4 (setup function syntax) + persisted state |
| Router           | Vue Router 5 (history mode)                       |
| Styling          | Tailwind CSS 4 (utility-first)                    |
| Icons            | Heroicons (`@heroicons/vue`)                      |
| Headless UI      | Headless UI (`@headlessui/vue`) for accessible unstyled primitives (Dialog, Menu, Listbox, Combobox, Switch, Tabs, Disclosure, Popover, Transition) |
| HTTP Client      | Axios (centralized in `src/composables/useApi.ts`) |
| Toasts           | vue-sonner                                        |
| Linting          | ESLint 10 (flat config) + Prettier                |
| Formatting       | Prettier (no semicolons, single quotes, 100 print width) + `prettier-plugin-tailwindcss` |

## Folder Structure

```
src/
├── assets/              # Static assets (images, global CSS)
│   ├── images/
│   └── main.css         # Tailwind import
├── components/
│   ├── ui/               # Shared UI primitives (Button, Input, Dialog, Badge, etc.)
│   └── domains/          # Domain-grouped feature components
├── composables/         # `use*` composables (bridge stores + local state)
│   └── useApi.ts        #   Axios instance + generic get/post/put/del/upload
├── constants/           # App-wide constant values
├── guards/              # Route guard functions
├── layouts/             # Route-level layout wrappers
├── plugins/             # Vue plugin registration (if any)
├── router/
│   └── index.ts         #   Router instance + route definitions
├── services/            # Stateless API service functions
├── stores/              # Pinia stores (setup function syntax)
├── types/               # TypeScript interfaces & types
├── utils/
│   ├── cn.ts             #   clsx + tailwind-merge helper
│   └── errorHandler.ts   #   getErrorMessage()
├── views/               # Page-level components (one per route)
│   └── HomeView.vue
├── App.vue              # Root component (`<router-view />`)
├── env.d.ts             # Vite client type reference
└── main.ts              # App bootstrap (Pinia, Router)
```

## Architecture Flow

```
Component → Composable → Store → Service → useApi (Axios)
               ↑              ↑
          local form      reactive state
          state (ref)     (items, loading, error)
```

1. **Services** (`src/services/`) — stateless async functions that call API endpoints via `useApi.ts` helpers (`get`, `post`, `put`, `del`, `upload`).
2. **Stores** (`src/stores/`) — Pinia stores hold reactive state (`items`, `current`, `loading`, `error`) and delegate to services.
3. **Composables** (`src/composables/`) — wrap stores with `storeToRefs()`, add local form state, and proxy CRUD actions.
4. **Components** use composables to access both global state and local form state.

## Naming Conventions

### Files

| Type         | Convention                | Example                         |
| ------------- | -------------------------- | -------------------------------- |
| Component    | PascalCase `.vue`          | `ProductForm.vue`               |
| UI primitive | PascalCase in `ui/`        | `ui/Button.vue`, `ui/Input.vue` |
| View         | PascalCase + `View`        | `ProductView.vue`               |
| Layout       | PascalCase + `Layout`      | `DashboardLayout.vue`           |
| Composable   | camelCase `use*.ts`        | `useProduct.ts`                 |
| Store        | camelCase `*Store.ts`      | `productStore.ts`               |
| Service      | PascalCase `*Service.ts`   | `ProductService.ts`             |
| Type         | camelCase `*Interface.ts`  | `productInterface.ts`           |
| Utility      | camelCase `.ts`            | `errorHandler.ts`               |

### TypeScript

| Kind           | Convention                | Example                             |
| ---------------- | -------------------------- | ------------------------------------- |
| Interface       | `I` prefix                 | `IProduct`, `IUser`, `IOrder`        |
| Create type     | `ICreate*` (Omit pattern)  | `ICreateOrder`, `ICreateBundle`      |
| Union type      | No prefix, PascalCase      | `OrderStatus`, `PaymentMethod`       |
| Response type   | Descriptive PascalCase     | `LoginResponse`, `AuditLogResponse` |

### Variables & Functions

| Kind              | Convention                                            | Example                                 |
| ------------------- | -------------------------------------------------------- | ------------------------------------------ |
| Reactive state    | `ref<T>()` with camelCase                             | `const loading = ref(false)`           |
| Computed          | `computed(() => ...)` camelCase                        | `const isAuthenticated = computed(...)` |
| Boolean refs      | `is*`, `show*`, `has*` prefix                          | `isScrolled`, `showForm`               |
| Event handlers    | `handle*` or `on*` prefix                              | `handleLogout()`, `onSubmit()`         |
| Dialog functions  | `open*Dialog`, `close*Dialog`                          | `openEditDialog()`, `closeDialog()`    |
| CRUD actions      | `fetchAll`, `fetchOne`, `create`, `update`, `remove`   | Standard across all stores             |
| Store export      | `use*Store`                                            | `useAuthStore`, `useProductStore`      |
| Composable export | `use*`                                                 | `useProduct()`, `useAuth()`            |

### Components (SFC)

- Always `<script setup lang="ts">` — never `defineComponent()`
- Template order: `<template>` → `<script setup>` (no `<style>` block — use Tailwind utility classes)
- Props: `defineProps<{ prop: Type }>()` (type-only, no runtime validation)
- Emits: `defineEmits<{ (e: 'event', payload: T): void }>()`

## Store Pattern (Pinia) — MANDATORY

Every domain store MUST follow this exact pattern:

```ts
import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { IEntity } from '@/types/entityInterface'
import * as entityService from '@/services/EntityService'
import { getErrorMessage } from '@/utils/errorHandler'

export const useEntityStore = defineStore('entity', () => {
  const items = ref<IEntity[]>([])
  const current = ref<IEntity | undefined>()
  const loading = ref(false)
  const error = ref<string | null>(null)

  async function fetchAll() {
    loading.value = true // 1. Set loading
    error.value = null // 2. Clear previous error
    try {
      items.value = await entityService.fetchEntities() // 3. Perform operation
    } catch (err: unknown) {
      error.value = getErrorMessage(err) // 4. Store error message
      throw err // 5. Re-throw for caller
    } finally {
      loading.value = false // 6. Clear loading in finally
    }
  }

  // fetchOne, create, update, remove follow identical try/catch/finally pattern

  function clear() {
    items.value = []
    current.value = undefined
    error.value = null
  }

  return { items, current, loading, error, fetchAll, /* ... */ clear }
})
```

**Key rules:**

- Always use setup function syntax (not options API)
- Standard state quartet: `items`, `current`, `loading`, `error` — every domain store has these four core refs
- Standard CRUD actions: `fetchAll`, `fetchOne`, `create`, `update`, `remove`, `clear`
- `loading` is set `true` before the operation and reset to `false` in `finally` — **never** in `try` or `catch`
- `error` is reset to `null` before the operation
- Errors are **both** stored in the `error` ref **and** re-thrown (`throw err`) so callers can react too

## Composable Pattern — MANDATORY

```ts
import { ref } from 'vue'
import { storeToRefs } from 'pinia'
import { useEntityStore } from '@/stores/entityStore'
import type { IEntity } from '@/types/entityInterface'

export function useEntity() {
  const store = useEntityStore()
  const { items, current, loading, error } = storeToRefs(store) // storeToRefs is MANDATORY

  // Local form state
  const entity = ref<IEntity>({ /* defaults */ })

  // Proxy CRUD methods from store
  async function fetchAll() { return store.fetchAll() }
  async function create(e: IEntity) { return store.create(e) }
  // ...

  return {
    // Store state (reactive refs) — always first
    items, current, loading, error,
    // Local state — always second
    entity,
    // Actions — always last
    fetchAll, create, /* ... */
  }
}
```

**CRITICAL — `storeToRefs()` is mandatory.** Destructuring store state directly (`const { items } = store`) breaks reactivity — the UI will not update. Actions (functions) do NOT need `storeToRefs` — only state refs do.

```ts
// WRONG — breaks reactivity
const store = useEntityStore()
const { items, current, loading, error } = store
```

**Return order is mandatory:** store state (via `storeToRefs`) → local state → actions.

## Service Pattern

```ts
import { get, post, put, del } from '@/composables/useApi'
import type { IEntity } from '@/types/entityInterface'

export async function fetchEntities(): Promise<IEntity[]> {
  return await get<IEntity[]>('/entities')
}
export async function createEntity(data: IEntity): Promise<IEntity> {
  return await post<IEntity>('/entities', data)
}
```

**No response envelope.** The backend returns direct data — never `{ success: true, data: ... }`.

```ts
// CORRECT — backend returns the entity directly
const created = await entityService.createEntity(data) // returns IEntity
items.value.unshift(created)

// WRONG — do not destructure a success/data wrapper
const { data } = await entityService.createEntity(data) // NEVER — no envelope exists
```

## Routing

- `src/router/index.ts` — `createWebHistory()` + `routes` array
- The router MUST always have at least a `/` route — an empty `routes: []` triggers a Vue Router warning
- Add route guards in `src/guards/` and register them via `router.beforeEach` in `router/index.ts`
- Lazy-load views for routes outside the critical path: `component: () => import('@/views/SomeView.vue')`

## Styling

- **Framework:** Tailwind CSS 4 — utility-first, all styling via class attributes, configured via `@tailwindcss/vite` (no `tailwind.config.js` needed by default)
- **Headless UI:** `@headlessui/vue` for Dialog, Menu, Listbox, Switch, Tabs, Popover, Disclosure
- **No `<style>` blocks** unless truly necessary — Tailwind utilities handle everything
- **Class merging:** Use `cn()` utility (`src/utils/cn.ts`, clsx + tailwind-merge) for conditional classes
- **Icons:** Heroicons (`@heroicons/vue/24/outline`, `@heroicons/vue/24/solid`)
- **Prettier:** `prettier-plugin-tailwindcss` auto-sorts class order

## API Layer (`src/composables/useApi.ts`)

- Central Axios instance with base URL from `VITE_API_BASE_URL`
- Request interceptor: attaches Bearer token from Pinia/sessionStorage/localStorage
- Response interceptor: dispatches `auth:unauthorized` custom event on 401
- Custom `ApiError` class with HTTP status code
- Generic typed helpers: `get<T>`, `post<T>`, `put<T>`, `del<T>`, `upload<T>`
- File uploads use `multipart/form-data`

## Error Handling

- `getErrorMessage(err)` utility (`src/utils/errorHandler.ts`) for safe error extraction from `ApiError` / `Error` / unknown
- Stores catch errors, store them in the `error` ref, and re-throw
- Components use try/catch around composable methods
- Toast notifications for user-facing feedback via `vue-sonner`

## Environment Variables

| Variable            | Purpose               |
| --------------------- | ------------------------ |
| `VITE_API_BASE_URL` | Backend API base URL |

## Commands

| Command              | Purpose                       |
| ---------------------- | -------------------------------- |
| `npm run dev`        | Start Vite dev server         |
| `npm run build`      | Type check + production build |
| `npm run type-check` | Run `vue-tsc --build`         |
| `npm run lint`       | ESLint with auto-fix          |
| `npm run format`     | Prettier format `src/`        |
| `npm run preview`    | Preview production build      |

## Path Alias

`@` resolves to `src/`. All imports within `src/` use `@/...` (e.g. `import HomeView from '@/views/HomeView.vue'`), never relative paths like `../../views/HomeView.vue`.

## `cn()` Utility

```ts
import { type ClassValue, clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

Usage:

```vue
<button
  :class="cn('px-4 py-2 rounded-lg font-medium', variant === 'primary' && 'bg-primary text-white', disabled && 'opacity-50 cursor-not-allowed')"
>
```

## Project-Specific Skills

See `.claude/commands/` for detailed conventions on composables, state management, routing, styling, Vue components, and git hooks — invoked as `/project:skill-*` inside this project.
