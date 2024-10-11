<template>
    <div class="container mx-auto p-6 max-w-md form-batman">
            <img class="w-40 mx-auto" src="../assets/img/batman-character.png" alt="batman">
      <form v-if="status === 1" @submit.prevent="registerForm" class="shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <h2 class="text-1xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white">Gotham Register !</h2>
        <div class="mb-4">
          <label for="name" class="block text-gray-700 text-sm font-bold mb-2">Nom :</label>
          <input
            type="text"
            id="name"
            v-model="user.name"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="Votre nom"
          />
        </div>
  
        <div class="mb-4">
          <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email :</label>
          <input
            type="email"
            id="email"
            v-model="user.email"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="Votre email"
          />
        </div>
  
        <div class="mb-6">
          <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Mot de passe :</label>
          <input
            type="password"
            id="password"
            v-model="user.password"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
          />
        </div>
  
        <div class="flex items-center justify-between">
          <button
            type="submit"
            class="bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          >
            Send a BatRequest
          </button>
        </div>
      </form>
      <form v-else-if="status === 2" @submit.prevent="loginForm" class="shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <h2 class="text-1xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white">Gotham Login !</h2>
        <div class="mb-4">
          <label for="name" class="block text-gray-700 text-sm font-bold mb-2">Nom :</label>
          <input
            type="text"
            id="name"
            v-model="user.name"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="Votre nom"
          />
        </div>
  
        <div class="mb-4">
          <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email :</label>
          <input
            type="email"
            id="email"
            v-model="user.email"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            placeholder="Votre email"
          />
        </div>
  
        <div class="mb-6">
          <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Mot de passe :</label>
          <input
            type="password"
            id="password"
            v-model="user.password"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
          />
        </div>
  
        <div class="flex items-center justify-between">
          <button
            type="submit"
            class="bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          >
            Send a BatRequest
          </button>
        </div>
      </form>
      <span class=" text-gray-900 md:text-1xl" v-if="status === 1">Already BatAccount ? <button @click="toggleStatus">Click here</button></span>
      <span class=" text-gray-900 md:text-1xl" v-else-if="status === 2">No BatAccount ? <button @click="toggleStatus">Click here</button></span>

    </div>
  </template>

<script setup lang="ts">
import router from '@/router';
import { getuserId } from '@/store/userStore';
import { ref } from 'vue';
 interface User {
    email: string;
    name: string;
    password: string;

}
// je me flingue si j'ai pas trouvé de soluce aux <any>
const user = ref<User>({ email: '', name: '', password:'' });
    let status = ref(1)

function toggleStatus(){
    status.value = status.value === 1 ? 2 : 1;
}


const loading = ref(false);

function loginForm() {
    console.log("LOGIN")
    router.push('/workingtimes');

}
function registerForm() {
    console.log("REGISTER")
    router.push('/workingtimes');

}

async function fetchUsers() {
  loading.value = true;
  const result = await getuserId(1);
  loading.value = false;
  console.log(result);
  console.log(user.value);
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