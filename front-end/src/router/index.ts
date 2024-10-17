import { createRouter, createWebHistory } from 'vue-router'
import PortalView from '../pages/Portal.vue'
import ChartManager from '@/pages/ChartManagerPages.vue'
import ClockManager from '@/pages/ClockManagerPages.vue'
import User from '@/pages/UserPages.vue'
import WorkingTime from '@/pages/WorkingTimePages.vue'
import WorkingTimes from '@/pages/WorkingTimesPages.vue'
import Register from '@/pages/RegisterPages.vue'
import Home from '@/pages/Home.vue'

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
      path: '/charManager',
      name: 'ChartManager',
      component: ChartManager
    },
    {
      path: '/ClockManager',
      name: 'ClockManager',
      component: ClockManager
    },
    {
      path: '/User',
      name: 'User',
      component: User
    },
    {
      path: '/auth',
      name: 'auth',
      component: Register
    },
    {
      path: '/WorkingTime',
      name: 'WorkingTime',
      component: WorkingTime
    },
    {
      path: '/WorkingTimes',
      name: 'WorkingTimes',
      component: WorkingTimes
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
