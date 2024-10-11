
<template >
  <nav class="flex flex-row h-20 items-center justify-evenly bg-slate-50">
  
    <RouterLink to="/" class="overflow-hidden">
      <img src="@/assets/timemanager.png" alt="Logo TimeManager" class="h-14 w-full" />
    </RouterLink>
    <div>
    </div>
    <div class="flex flex-row gap-4 " v-if="isConnected">
      <Button text="Admin" type="outlined" to="/login" color="black" textColor="black" rounded/>
      <Button text="Dashboard" type="contained" to="/register" textColor="white" color="black" rounded/>
    </div>
    <div class="flex flex-row gap-4 " v-else>
      <Button text="Login" type="outlined" to="/login" color="black" textColor="black" rounded/>
      <Button to="/register" text="Register" type="contained" textColor="white" color="black" rounded/>
    </div>
    
    
  </nav>
</template>
<script setup lang="ts" >
  import Button from "./Button.vue"
  import { useUser } from '../store/userStore';
  const { isConnected } = useUser();
</script>
<style lang="ts">
  
</style>