<template>
  <Navbar />
  <div class="w-full h-full flex flex-col justify-center items-center text-center text-white">
    <div class="flex justify-center mb-8">
      <img src="../assets/img/batMask.png" alt="Logo TimeManager"  class="w-64 h-64 md:w-80 md:h-80" />
    </div>
    <p class="text-lg md:text-xl mb-8">
      The page you're looking for doesn't exist
    </p>

    <h1 class="text-2xl md:text-4xl font-bold mb-4">
      You're not the hero Gotham needs, nor the one it deserves
    </h1>
    <button
      @click="$router.push('/home')"
      class="bg-yellow-500 hover:bg-yellow-400 text-gray-900 font-bold py-3 px-6 rounded-full transition-all duration-300 ease-in-out shadow-lg"
    >
      Back to Home
    </button>
  </div>
</template>
<script setup>
import Navbar from '@/components/Navbar.vue';
</script>
