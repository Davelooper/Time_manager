<script setup lang="ts">
import { ref } from 'vue';
import ProgressBar from './ProgressBar.vue';

// Utilisation de 'ref' pour créer un state réactif
const progressValues = ref([100, 40, 20, 70, 95, 70, 95]);

// Fonction pour mettre à jour une valeur de progression
const updateProgress = (index: number, newValue: number) => {
  progressValues.value[index] = newValue;
};
</script>

<template>
  <div class="bg-gradient-to-br backdrop-blur-md from-slate-200/20 to-white/10 w-min min-h-10 rounded shadow py-2 px-4 flex flex-col gap-1">
    <p class="select-none text-slate-300 font-semibold">This Week</p>  
     <p class="select-none text-2xl bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-600">80%</p>
    <div class="flex flex-row justify-center items-center gap-3">
      <ProgressBar 
       v-for="(value, index) in progressValues" 
       :key="index" 
       :value="value" 
     />
    </div>
  </div>
</template>
