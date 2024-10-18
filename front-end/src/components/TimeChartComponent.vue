<template>
  <div class="border-gray-200 rounded-lg text-center shadow p-5 bg-white bg-opacity-10 dark:border-gray-700">
    <ul class="flex border-b text-center">
    <li
      @click="activeTab = 1"
      class="cursor-pointer py-2 px-4 text-gray-600 dark:text-gray-400 border-b-2"
      :class="activeTab === 1 ? 'border-blue-500 text-blue-500' : 'border-transparent'"
    >
      Monthly
    </li>
    <li
      @click="activeTab = 2"
      class="cursor-pointer py-2 px-4 text-gray-600 dark:text-gray-400 border-b-2"
      :class="activeTab === 2 ? 'border-blue-500 text-blue-500' : 'border-transparent'"
    >
      Weekly
    </li>
    <li
      @click="activeTab = 3"
      class="cursor-pointer py-2 px-4 text-gray-600 dark:text-gray-400 border-b-2"
      :class="activeTab === 3 ? 'border-blue-500 text-blue-500' : 'border-transparent'"
    >
      Daily
    </li>
  </ul>
    <div class="p-4 flex flex-row justify-center">
      <div class="size-96" v-if="activeTab === 1">
        <Pie :data="chartDataMonth" :options="chartOptions" />
      </div>
      <div class="h-96 w-[700px]" v-if="activeTab === 2">
        <Bar :data="chartDataWeek" :options="chartOptions" />
      </div>
      <div class="w-[700px] h-96" v-if="activeTab === 3">
        <Line :data="chartDataHours" :options="lineChartOptions" />
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import * as chartConfig from '../store/chartConfig'
import { ref } from 'vue';
import { Bar, Line, Pie } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, RadialLinearScale, PointElement, ArcElement } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, RadialLinearScale, PointElement, ArcElement)

let activeTab = ref(1);

const chartDataMonth = ref({
  labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
  datasets: [
    {
      label: 'heures travaillé',
      backgroundColor: ['#ff9523', '#ffe177', '#ff7795', '#161616'],
      data: [30, 45, 40, 35],
    },
  ],
});

const chartDataHours = ref({
  labels: ['00 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM', '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM', '12 AM', '00 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM', '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM', '12 PM'],
  datasets: [
    {
      label: 'heures travaillé',
      borderColor: '#ff9523',
      backgroundColor: 'rgba(255, 149, 35, 0.2)',
      borderWidth: 3,
      pointBackgroundColor: '#ff9523',
      data: [0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    },
  ],
});

const chartDataWeek = ref({
  labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  datasets: [
    {
      label: 'Heures travaillées',
      backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
      data: [8, 7.5, 8.5, 9, 7, 4, 0],
    },
    {
      label: 'Objectif (heures)',
      backgroundColor: '#ef4444',
      data: [8, 8, 8, 8, 8, 8, 0],
    },
  ],
});

const chartOptions = {
  responsive: true,
  plugins: {
    legend: {
      position: 'top',
      labels: {
        color: '#4b5563',
      },
    },
  },
  scales: {
    x: {
      ticks: {
        color: '#6b7280',
      },
    },
    y: {
      ticks: {
        color: '#6b7280',
      },
    },
  },
};

const lineChartOptions = {
  responsive: true,
  plugins: {
    legend: {
      position: 'top',
      labels: {
        color: '#4b5563',
      },
    },
  },
  scales: {
    x: {
      ticks: {
        color: '#6b7280',
      },
    },
    y: {
      ticks: {
        color: '#6b7280',
      },
    },
  },
};

interface User {
  isAdmin: boolean;
}
</script>

<style scoped>
/* Style optionnel pour affiner l'apparence de tes graphiques et composants */
.batCard {
  border-radius: 12px;
  padding: 20px;
}
</style>
