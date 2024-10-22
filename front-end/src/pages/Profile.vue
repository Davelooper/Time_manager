<template>
  <Navbar />
  <div class="p-4 md:p-10 flex flex-col gap-4">

    <!-- Titre de la page -->
    <h1 class="text-2xl md:text-4xl font-bold mb-4 text-white">Welcome to your profile</h1>
    <!-- <p class="text-lg md:text-xl mb-8 text-white">Here you can see your personal information</p> -->

    <!-- Conteneur Time Pick -->
     <div class="flex flex-row gap-4">
       <div class="max-w-[600px] w-full flex flex-col md:flex-row items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg gap-6">
          <div class="flex-col items-center justify-around md:flex-row flex">
            <img src="@/assets/mascotte.png" alt="User Icon" class="h-32 w-32 transition-transform duration-300 hover:scale-110" />
            <div class="flex flex-col items-center md:items-start text-center md:text-left gap-4">
              <h2 class="text-white  text-sm sm:text-lg md:text-3xl uppercase font-bold">You need to time pick</h2>
               <div class="flex flex-col md:flex-row flex-wrap items-center justify-between w-full">
                 <Button text="PICK" type="contained" to="/timepick" rounded textColor="white" color="gold" class="hover:shadow-lg transition-shadow duration-300"/>
                 <p class="text-gray-300  font-semibold text-5xl">{{new Date().toLocaleTimeString()}}</p>
               </div>
            </div>
          </div>
       </div>
       <ProgressDays title="This Month" :data="[10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]"/>
     </div>

    <!-- Progression hebdomadaire et mensuelle -->
    <div class="flex flex-col md:flex-row justify-between gap-6">
        <ProgressDays title="This Week" :data="[10, 20, 30, 40, 50, 60, 70]"/>
    </div>
  </div>
</template>

<script setup lang="ts">
import ProgressDays from "@/components/ProgressDays.vue";
import RegisterUsersComponent from "@/components/RegisterUsersComponent.vue"
import Button from "@/components/Button.vue";
import Navbar from "../components/Navbar.vue"
import { getToken } from "../store/userStore";

const props = defineProps({
  token: {
    type: String,
    required: true,
    default: getToken(),
  },
});
</script>
