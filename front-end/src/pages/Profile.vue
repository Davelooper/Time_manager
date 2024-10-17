<template>
  <Navbar />
  <div class="md:p-10">

    <h1 class="text-2xl md:text-4xl font-bold mb-4 text-white">Welcome to your profile</h1>
    <p class="text-lg md:text-xl mb-8 text-white">Here you can see your personal information</p>

   <div class="bg-gradient-to-br from-slate-200/20 to-white/10 w-full min-h-10 rounded shadow p-2">
      <div class="flex flex-row justify-center items-center gap-4">
        <p class="text-white">Week</p>  
        <Progress7Days />
        <p class="text-2xl bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-600">80%</p>
      </div>  
    </div>
  </div>
</template>

<script setup lang="ts">
	import ProgressBar from "@/components/ProgressBar.vue";
import Navbar from "../components/Navbar.vue"
import Progress7Days from "@/components/Progress7Days.vue";
</script>