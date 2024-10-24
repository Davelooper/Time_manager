<template>
  <div>
    <!-- Votre contenu pour le premier onglet -->
    <div class="flex flex-row gap-4 justify-center flex-wrap">
      <div class="flex flex-col md:flex-row items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg">
        <BatPing />
      </div>
      <div class="max-w-[600px] w-full flex flex-col md:flex-row items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg gap-6">
        <ProgressDays title="This Month" :data="[10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]"/>
      </div>
      <div class="flex flex-col md:flex-row justify-between gap-6">
        <ProgressDays title="This Week" :data="[10, 20, 30, 40, 50, 60, 70]"/>
      </div>
      <div class="flex flex-col md:flex-row justify-between gap-6">
        <TimeChartComponent />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { getDecodedToken } from "../store/userStore";
import BatPing from "../components/BatPing.vue";
import TimeChartComponent from "@/components/TimeChartComponent.vue";
import ProgressDays from "@/components/ProgressDays.vue";

const decodedToken = getDecodedToken(); 
const username = decodedToken.username; 
</script>
