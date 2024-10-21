<template>
  <nav class="flex items-center justify-between h-16 px-8 min-h-16 backdrop-blur-md sticky shadow-amber-400 shadow-sm top-0 z-50">
    <!-- Logo -->
    <RouterLink to="/home" class="flex items-center">
     <img src="@/assets/timemanager.png" alt="TimeManager Logo" class="h-10 w-auto transition-transform duration-300 hover:scale-105 filter invert" />
    </RouterLink>

    <!-- Navigation links -->
    <div class="flex items-center space-x-6">
      <!-- If the user is connected -->
      <div v-if="isConnected" class="flex items-center space-x-4">
        <RouterLink to="/User" class="flex items-center">
          <img src="../assets/img/batMask.png" alt="User Icon" class="h-10 w-auto rounded-full shadow-sm transition-transform hover:scale-110" />
        </RouterLink>
        <Button text="Admin" type="outlined" to="/admin" rounded textColor="gold" color="gold"/>
        <Button text="Dashboard" type="contained" to="/dashboard" rounded textColor="white" color="gold" />
        <button @click="logoutUser" class="py-2 pl-3 pr-2 flex items-center justify-center bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all duration-300">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h6a2 2 0 012 2v1"/>
    </svg>
</button>

      </div>

      <!-- If the user is not connected -->
      <div v-else class="flex items-center space-x-4">
        <Button to="/workingtimes" text="Bat Time" type="contained" rounded textColor="white" color="gold" />
        <Button to="/auth" text="Authentication" type="contained" rounded textColor="white" color="gold"/>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import Button from './Button.vue';
import { logoutUser, useUser } from '../store/userStore';
const { isConnected } = useUser();
</script>

<style scoped>
</style>
