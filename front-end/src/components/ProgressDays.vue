<script setup lang="ts">
import { computed, ref } from 'vue';
import ProgressBar from './ProgressBar.vue';

// Utilisation de 'ref' pour créer un state réactif
const progressValues = ref([100, 40, 20, 70, 95, 70, 95, 40, 20, 70, 95, 70, 95, 40, 20, 70, 95, 70, 95, 40, 20, 70, 95, 70, 95]);

// Fonction pour mettre à jour une valeur de progression
const updateProgress = (index: number, newValue: number) => {
  progressValues.value[index] = newValue;
};

// Utilisation de defineProps sans changer sa forme
const props = defineProps({
  title: {
    type: String,
    required: true,
    default: "Default Title",
  },
  data: {
    type: Array as ()=> number[],
    required: true,
    default: () => [10, 20],
  },
});

// Calcul du pourcentage total basé sur les données
const totalPercentage = computed(() => {
  // Typage explicite des valeurs dans reduce
  const total = (props.data as number[]).reduce((acc, value) => acc + value, 0);
  const maxTotal = props.data.length * 100; // 100% pour chaque élément
  return Math.round((total / maxTotal) * 100);
});
</script>

<template>
  <div class="w-full bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20  min-h-10 h-auto rounded shadow py-4 px-4 flex flex-col gap-1 flex-wrap">
    <p class="select-none text-slate-300 font-semibold whitespace-nowrap">{{ title }}</p>  
     <p class="select-none text-2xl bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-600">{{totalPercentage}}%</p>
    <div class="flex flex-row justify-start items-center gap-3 flex-wrap">
      <ProgressBar 
      v-for="(value, index) in data" 
       :key="index" 
       :value="value" 
     />
    </div>
  </div>
</template>
