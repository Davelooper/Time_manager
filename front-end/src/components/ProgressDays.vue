<script setup lang="ts">
import { computed, ref } from 'vue';
import ProgressBar from './ProgressBar.vue';

// Utilisation de 'ref' pour créer un state réactif
const progressValues = ref([100, 40, 20, 70, 95, 70, 95, 40, 20, 70, 95, 70, 95, 40, 20, 70, 95, 70, 95, 40, 20, 70, 95]);

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
    type: Array as () => number[],
    required: true,
    default: () => [10, 20],
  },
});

// Calcul du pourcentage total basé sur les données
const totalPercentage = computed(() => {
  const total = (props.data as number[]).reduce((acc, value) => acc + value, 0);
  const maxTotal = props.data.length * 100; // 100% pour chaque élément
  return Math.round((total / maxTotal) * 100);
});

// Fonction pour regrouper les données en sous-tableaux de 7 éléments
const chunkedData = computed(() => {
  const chunks = [];
  const dataArray = props.data;
  for (let i = 0; i < dataArray.length; i += 7) {
    chunks.push(dataArray.slice(i, i + 7));
  }
  return chunks;
});
</script>

<template>
  <div class="w-full h-full items-center justify-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 min-h-10 rounded shadow py-4 px-4 flex flex-col gap-1">
    <p class="select-none text-slate-300 font-semibold whitespace-nowrap">{{ title }}</p>
    <p class="select-none text-2xl bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-600">{{ totalPercentage }}%</p>
    <!-- Conteneur pour les lignes -->
    <div class="flex flex-col gap-2">
      <!-- Boucle sur chaque ligne -->
      <div
        v-for="(chunk, chunkIndex) in chunkedData"
        :key="chunkIndex"
        class="flex flex-row justify-start items-center gap-3"
      >
        <!-- Boucle sur chaque ProgressBar dans la ligne -->
        <ProgressBar
          v-for="(value, index) in chunk"
          :key="index + '-' + chunkIndex"
          :value="value"
        />
      </div>
    </div>
  </div>
</template>
