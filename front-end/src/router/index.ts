import { createRouter, createWebHistory } from 'vue-router'
import PortalView from '../pages/Portal.vue'
import User from '@/pages/UserPages.vue'
import WorkingTime from '@/pages/WorkingTimePages.vue'
import Home from '@/pages/Home.vue'
import LoginPage from '@/pages/LoginPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'portal',
      component: PortalView
    },
    {
      path: '/home',
      name: 'home',
      component: Home
    },
    {
      path: '/User',
      name: 'User',
      component: User
    },
    {
      path: '/auth',
      name: 'auth',
      component: LoginPage
    },
    {
      path: '/WorkingTime',
      name: 'WorkingTime',
      component: WorkingTime
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: () => import('@/pages/Profile.vue')
    },
    {
      path: '/notfound',
      name: 'notFound',
      component: () => import('@/pages/NotFound.vue')
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'notFound' }
    }
  ]
})

export default router
