<template>
  <Navbar />
  <div class="p-4 md:p-10 flex flex-col gap-4">

    <h1 class="text-2xl md:text-4xl font-bold mb-4 text-white">Welcome to your profile</h1>
    <!-- <p class="text-lg md:text-xl mb-8 text-white">Here you can see your personal information</p> -->

     <div class="flex flex-row gap-4">
       <div class="flex flex-col md:flex-row items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg">
         <!-- Image mascotte -->
          <div class="flex-col items-center justify-center md:flex-row flex p-2">
            <BatPing />
            </div>
   
          </div>

       <ProgressDays title="This Month" :data="[10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]"/>
     </div>

    <!-- Progression hebdomadaire et mensuelle -->
    <div class="flex flex-col md:flex-row justify-between gap-6">
        <ProgressDays title="This Week" :data="[10, 20, 30, 40, 50, 60, 70]"/>
    </div>
  </div>
  
<ListUserByTeamsComponent />
</template>

<script setup lang="ts">
import ProgressDays from "@/components/ProgressDays.vue";
import ListUserByTeamsComponent from "@/components/ListUserByTeamsComponent.vue"
import Navbar from "../components/Navbar.vue"
import { getToken } from "../store/userStore";
import BatPing from "../components/BatPing.vue"
// # define the props
const props = defineProps({
  token: {
    type: String,
    required: true,
    default: getToken(),
  },
});
</script>
