<template >
    <RouterLink to="/home">
      <div class="w-10 m-8 absolute">
        <svg xmlns="http://www.w3.org/2000/svg" fill="#FFF" viewBox="0 0 32 32"><path d="M32 15H3.41l8.29-8.29-1.41-1.42-10 10a1 1 0 0 0 0 1.41l10 10 1.41-1.41L3.41 17H32z" data-name="4-Arrow Left"/></svg>
      </div>
    </RouterLink>
    <div class="flex flex-row justify-center items-center w-full h-full">
      <div class="p-6 max-w-md bg-gradient-to-tr from-amber-200 to-amber-400 rounded-lg shadow-lg dark:bg-gray-800">
              <img class="w-40 mx-auto" src="../assets/img/batman-character.png" alt="batman">
        <form v-if="status === 1" @submit.prevent="registerForm" class="rounded px-8 pt-6 pb-8 mb-4">
          <h2 class="text-1xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white">Gotham Register !</h2>
          <div class="mb-4">
            <label for="name" class="block text-gray-700 text-sm font-bold mb-2">Name</label>
            <input
              type="text"
              id="name"
              v-model="user.username"
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              placeholder="Your name"
            />
          </div>
    
          <div class="mb-4">
            <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email</label>
            <input
              type="email"
              id="email"
              v-model="user.email"
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              placeholder="Your email"
            />
          </div>
    
          <div class="mb-6">
            <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password</label>
            <input
              type="password"
              id="password"
              v-model="user.password"
              placeholder="Your password"
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
            />
          </div>
    
          <div class="flex items-center justify-between w-full">
            <button
              type="submit"
              class="w-full bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            >
              Send a BatRequest
            </button>
          </div>
        </form>
        <form v-else-if="status === 2" @submit.prevent="loginForm" class="rounded px-8 pt-6 pb-8 mb-4">
          <h2 class="text-1xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white">Gotham Login !</h2>
    
          <div class="mb-4">
            <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email</label>
            <input
              type="email"
              id="email"
              v-model="user.email"
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              placeholder="Your email"
            />
          </div>
    
          <div class="mb-6">
            <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password</label>
            <input
              type="password"
              id="password"
              placeholder="Your password"
              v-model="user.password"
              class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
            />
          </div>
    
          <div class="flex items-center justify-between w-full">
            <button
              type="submit"
              class="w-full bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            >
              Send a BatRequest
            </button>
          </div>
        </form>
        <button v-if="status === 1" @click="toggleStatus">Already BatAccount ? Click here</button>
        <button  v-else-if="status === 2" @click="toggleStatus">No BatAccount ? Click here</button>
  
      </div>
    </div>
  </template>

<script setup lang="ts">
import router from '@/router';
import { createUser,authUser } from '@/store/userStore';
import { ref } from 'vue';
 

let status = ref(1)

function toggleStatus(){
    status.value = status.value === 1 ? 2 : 1;
}


const loading = ref(false);

interface User {
    email: string;
    username: string;
    password: string;
}
const user = ref<User>({email: '', username: '', password:'' });
   

async function loginForm() {
  console.log("REGISTER");
  try {
   await authUser(user.value); 
    // Redirection vers la page /workingtimes après la création de l'utilisateur
    router.push('/workingtimes');
  } catch (error) {
    console.error('Erreur lors de la création du compte:', error);
  }
}
async function registerForm() {
  console.log("REGISTER");
  try {
    await createUser(user.value);
    // Redirection vers la page /workingtimes après la création de l'utilisateur
    router.push('/workingtimes');
  } catch (error) {
    console.error('Erreur lors de la création du compte:', error);
  }
}
</script>

<style>
.form-batman{
    position: relative;
    top: 150px;
    background-color: #ffe177;
    border-radius: 15px
}
.test{
    text-align: center;
}

</style>