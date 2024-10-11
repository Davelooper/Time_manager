import { createRouter, createWebHistory } from 'vue-router'
import PortalView from '../pages/Portal.vue'
import ChartManager from '@/pages/ChartManagerPages.vue'
import ClockManager from '@/pages/ClockManagerPages.vue'
import User from '@/pages/User.Pages.vue'
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
      path: '/Register',
      name: 'register',
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
  ]
})

export default router
