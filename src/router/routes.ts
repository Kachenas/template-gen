import type { RouteRecordRaw } from 'vue-router'
import LandingLayout from '@/layouts/LandingLayout.vue'
import DefaultLayout from '@/layouts/DefaultLayout.vue'
import DashboardLayout from '@/layouts/DashboardLayout.vue'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import RegisterView from '@/views/RegisterView.vue'
import DashboardView from '@/views/DashboardView.vue'

export const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: LandingLayout,
    children: [{ path: '', name: 'home', component: HomeView }],
  },
  {
    path: '/login',
    component: DefaultLayout,
    children: [{ path: '', name: 'login', component: LoginView }],
  },
  {
    path: '/register',
    component: DefaultLayout,
    children: [{ path: '', name: 'register', component: RegisterView }],
  },
  {
    path: '/dashboard',
    component: DashboardLayout,
    meta: { requiresAuth: true },
    children: [{ path: '', name: 'dashboard', component: DashboardView }],
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/404View.vue'),
  },
]
