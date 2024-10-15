<template>
  <div class="border-gray-200 rounded-lg  text-center shadow batCard dark:border-gray-700 p-4">
        <div class="p-4">
      <div v-if="activeTab === 1">
        <Pie :data="chartDataMonth" />
    </div>
      <div v-if="activeTab === 2">
        <Bar :data="chartDataWeek" />

    </div>
      <div v-if="activeTab === 3">
        <Line :data="chartDataHours" />

    </div>
    </div>
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
  </div>

</template>

<script lang="ts" setup>
import * as chartConfig from '../store/chartConfig'

import { ref } from 'vue';
let activeTab = ref(1);
import { Bar, Line,Pie } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, LineElement, RadialLinearScale,PointElement,ArcElement} from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale,LineElement,RadialLinearScale,PointElement,ArcElement)

const chartDataMonth = ref({
    labels: [
      'Week 1',
      'Week 2',
      'Week 3',
      'Week 4',
    ],  datasets: [
    {
      label: 'heures travaillé',
        backgroundColor: ['#ff9523', '#ffe177', '#ff7795', '#161616'],
      
      data: [30, 45, 40, 35] 
    },

  ]
});

const chartDataHours = ref({
    labels: [
      '00 AM',
      '01 AM',
      '02 AM',
      '03 AM',
      '04 AM',
      '05 AM',
      '06 AM',
      '07 AM',
      '08 AM',
      '09 AM',
      '10 AM',
      '11 AM',
      '12 AM',
      '00 PM',
      '01 PM',
      '02 PM',
      '03 PM',
      '04 PM',
      '05 PM',
      '06 PM',
      '07 PM',
      '08 PM',
      '09 PM',
      '10 PM',
      '11 PM',
      '12 PM',
    ],  datasets: [
    {
      label: 'heure travaillé',
      backgroundColor: ['#ff9523', '#ffe177'],
      color: '#ff9523',
      data: [0, 0, 0, 1, 1, 1, 1,1,1,0,0,0,0,0,0,0,0,0,0,1,1] 
    }
  ]
});

const chartDataWeek = ref({
  labels: [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ],
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
    }
  ]
});

interface User {
    isAdmin:boolean;
}

</script>