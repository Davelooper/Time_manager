<template>
  <div>
    <!-- Votre contenu pour le premier onglet -->
    <div class="flex flex-row gap-4 justify-center flex-wrap gap-y-4 mt-4">
      <div class="w-full md:max-w-min flex items-center ">
        <ProgressDays title="This Month" :data="[10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 10, 20, 30, 40, 50, 60, 70, 80]"/>
      </div> 
      <div class="flex-grow-[5] justify-center flex flex-col items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg">
        <p class="text-gray-700 font-thin">Click on button to make a clock</p>
        <BatPing />
      </div>
      <div class="w-full md:max-w-min flex items-center">
        <ProgressDays title="This Week" :data="[10, 20, 30, 40, 50, 60, 70]"/>
      </div>
    </div>
    <div class="flex flex-col md:flex-row justify-center gap-6">
      <DaysJsComponent />  
    </div>
  </div>
</template>

<script setup lang="ts">
import { getDecodedToken } from "../store/userStore";
import BatPing from "../components/BatPing.vue";
import TimeChartComponent from "@/components/TimeChartComponent.vue";
import ProgressDays from "@/components/ProgressDays.vue";
import DaysJsComponent from "./DaysJsComponent.vue";

const decodedToken = getDecodedToken(); 
const {username} = decodedToken; 

</script>
