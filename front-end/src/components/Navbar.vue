<template>
  <nav class="flex items-center justify-between h-16 px-8 min-h-16 backdrop-blur-md sticky shadow-amber-400 shadow-sm top-0 z-50">
    <!-- Logo -->
     <div class="flex flex-row gap-4 items-end text-xl md:text-2xl  ">
       <RouterLink to="/home" class="flex items-center">
        <img src="@/assets/timemanager.png" alt="TimeManager Logo" class="h-10 w-auto transition-transform duration-300 hover:scale-105 filter invert" />
       </RouterLink> 
       <p v-if="isConnected" class="text-white hidden md:block">Welcome {{username}}</p>
     </div>

    <!-- Navigation links -->
    <div class="flex items-center space-x-6">
      <!-- If the user is connected -->
      <div v-if="isConnected" class="flex items-center space-x-4">
        <RouterLink to="/User" class="flex items-center">
          <img src="../assets/img/batMask.png" alt="User Icon" class="h-10 w-auto rounded-full shadow-sm transition-transform hover:scale-110" />
        </RouterLink>
        <!-- <Button text="Admin" type="outlined" to="/admin" rounded textColor="gold" color="gold"/> -->
        <Button text="Dashboard" type="contained" to="/dashboard" rounded textColor="white" color="gold" />
        <button @click="logoutUser" class="py-2 pl-3 pr-2 flex items-center justify-center bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all duration-300">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <path stroke-linecap="round" stroke-linejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h6a2 2 0 012 2v1"/>
    </svg>
</button>
<button 
    v-if="['admin', 'manager'].includes(decodedToken.role)"
    @click="toggleModal" 
    class="py-2 pl-3 pr-2 flex items-center justify-center bg-red-500 text-white rounded-lg hover:bg-red-600 transition-all duration-300">
    Create User
</button>
      </div>
      <div v-else class="flex items-center space-x-4">
        <Button to="/workingtimes" text="Bat Time" type="contained" rounded textColor="white" color="gold" />
        <Button to="/auth" text="Authentication" type="contained" rounded textColor="white" color="gold"/>
      </div>
    </div>
  </nav>
  <div v-if="showModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50">
    <div class= "rounded-lg p-6 w-96 relative z-50">
      <RegisterUsersComponent :showModal="showModal" @update:showModal="showModal = $event" /> 
    </div>
  </div>
</template>

<script setup lang="ts">
import Button from './Button.vue';
import { logoutUser, useUser } from '../store/userStore';
import { ref,onMounted } from 'vue';
import RegisterUsersComponent from './RegisterUsersComponent.vue';
import {getDecodedToken} from "../store/userStore";
const { isConnected } = useUser();
const showModal = ref(false);

function toggleModal(){
  showModal.value = !showModal.value;
}
const decodedToken = getDecodedToken() || {};
// const {username} = decodedToken; 

</script>

<style scoped>
</style>
