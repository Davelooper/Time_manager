
<template >
  <nav class="gotham-nav flex flex-row h-20 min-h-20 items-center justify-evenly  bg-gradient-to-br from-amber-200 to-amber-400">
  
    <RouterLink to="/home" class="overflow-hidden">
      <img src="@/assets/timemanager.png" alt="Logo TimeManager" class="h-14 w-full" />
    </RouterLink>
    <div>
    </div>
    <div class="flex flex-row gap-4 " v-if="isConnected">
      <Button text="Admin" type="outlined" to="/admin" color="black" textColor="black" rounded/>
      <Button text="Dashboard" type="contained" to="/dashboard" textColor="white" color="black" rounded/>
    </div>
    <div class="flex flex-row gap-4 " v-else>
      <RouterLink to="/User" class="overflow-hidden">
      <img src="../assets/img/batMask.png" alt="Logo TimeManager" class="size-10" />
    </RouterLink>
      <Button to="/workingtimes" text="Bat Time" type="contained" textColor="white" color="black" rounded/>

      <Button to="/auth" text="Authentication" type="contained" textColor="white" color="black" rounded/>
    </div>
    
    
  </nav>
</template>
<script setup lang="ts" >
import Button from './Button.vue';
  import { useUser } from '../store/userStore';
  const { isConnected } = useUser();
</script>
<style scoped>
  .gotham-nav{
    background-color: #ffe177;

  }
</style>