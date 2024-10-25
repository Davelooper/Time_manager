<template>
  <div class="border-gray-200 rounded-lg text-center shadow p-5 dark:border-gray-700">
    <ul class="flex border-b text-center">
      <li @click="activeTab = 1" class="cursor-pointer py-2 px-4 text-gray-600 dark:text-gray-400 border-b-2"
        :class="activeTab === 1 ? 'border-blue-500 text-blue-500' : 'border-transparent'">
        Monthly
      </li>
      <li @click="activeTab = 2" class="cursor-pointer py-2 px-4 text-gray-600 dark:text-gray-400 border-b-2"
        :class="activeTab === 2 ? 'border-blue-500 text-blue-500' : 'border-transparent'">
        Weekly
      </li>
      <button @click="fetchClocks(userId)" class="text-blue-800"> TEST CLOCKS </button>
      <button @click="fetchWorkingTime(teamId)" class="text-blue-800"> TEST workingTime </button>

    </ul>
    <div class="p-4 flex flex-row justify-center">
      <div class="size-96" v-if="activeTab === 1">
        <Pie :data="chartDataMonth" :options="pieChartOptions" />
      </div>
      <div class="h-96 w-[700px]" v-if="activeTab === 2">
        <Bar :data="chartDataWeek" :options="barChartOptions" />
      </div>
      <div class="w-[700px] h-96" v-if="activeTab === 3">
        <Line :data="chartDataHours" :options="lineChartOptions" />
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import { Bar, Line, Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, LineElement, ArcElement, CategoryScale, LinearScale } from 'chart.js';
import type { ChartOptions, ChartData } from 'chart.js';
import { getClocksByUserId } from '../store/clocksStore';
import { getDecodedToken } from '../store/userStore';
import { getAllWorkingTimeByUser } from '../store/workingTimeStore';
interface HoursWorkedPerDay {
  Monday: number;
  Tuesday: number;
  Wednesday: number;
  Thursday: number;
  Friday: number;
  Saturday: number;
  Sunday: number;
}

interface Clocks {
  Monday: number;
  Tuesday: number;
  Wednesday: number;
  Thursday: number;
  Friday: number;
  Saturday: number;
  Sunday: number;
}

const decodedToken = getDecodedToken();
const userId = decodedToken.id;
const teamId = decodedToken.team_id

async function fetchClocks(iduser: string) {
  try {
    const response = await getClocksByUserId(iduser);
    console.log('Response from getClocksByUserId:', response);
    if (!Array.isArray(response.data)) {
      throw new Error("La réponse n'est pas un tableau.");
    }

    const clocks = response.data;

    const hoursWorkedByDayClocks: { [key: string]: number } = {
      Monday: 0,
      Tuesday: 0,
      Wednesday: 0,
      Thursday: 0,
      Friday: 0,
      Saturday: 0,
      Sunday: 0,
    };

    // Stocker temporairement les pointages pour traiter les paires (entrée/sortie)
    let dailyClocks: { [key: string]: string[] } = {};

    // Organiser les clocks par jour
    clocks.forEach((entry: { time: string }) => {
      const day = new Date(entry.time).toLocaleDateString('en-US', { weekday: 'long' });
      if (!dailyClocks[day]) {
        dailyClocks[day] = [];
      }
      dailyClocks[day].push(entry.time);
    });

    // Calculer les heures travaillées par jour (paire entrée/sortie)
    Object.keys(dailyClocks).forEach(day => {
      const times = dailyClocks[day];
      if (times.length >= 2) {
        const startTime = new Date(times[0]);
        const endTime = new Date(times[1]);
        const hoursWorked = calculateWorkingHours(startTime.toISOString(), endTime.toISOString());

        hoursWorkedByDayClocks[day] += hoursWorked;
      }
    });

    return hoursWorkedByDayClocks; // Assurez-vous de retourner les heures travaillées par jour
  } catch (error) {
    console.error('Erreur lors de la récupération des heures de travail:', error);
    // Retourner un objet vide ou une structure par défaut si l'erreur se produit
    return {
      Monday: 0,
      Tuesday: 0,
      Wednesday: 0,
      Thursday: 0,
      Friday: 0,
      Saturday: 0,
      Sunday: 0,
    };
  }
}
async function fetchWorkingTime(idteam: string): Promise<HoursWorkedPerDay> {
  try {
    const response = await getAllWorkingTimeByUser(idteam);

    if (!response || !response.data) {
      throw new Error("Aucune donnée disponible.");
    }

    const workingTimes = response.data;

    // Calculer les heures travaillées par jour
    const hoursWorkedPerDay: HoursWorkedPerDay = {
      Monday: 0,
      Tuesday: 0,
      Wednesday: 0,
      Thursday: 0,
      Friday: 0,
      Saturday: 0,
      Sunday: 0,
    };

    workingTimes.forEach((entry: { start: string; end: string }) => {
      const dayOfWeek = new Date(entry.start).toLocaleDateString('en-US', { weekday: 'long' });
      const hoursWorked = calculateWorkingHours(entry.start, entry.end);

      if (hoursWorkedPerDay[dayOfWeek] !== undefined) {
        hoursWorkedPerDay[dayOfWeek] = hoursWorked;
      }
    });

    return hoursWorkedPerDay; // Retourne un objet contenant les jours de la semaine
  } catch (error) {
    console.error('Erreur lors de la récupération des heures travaillées:', error);
    throw error;
  }
}

function calculateWorkingHours(start: string, end: string): number {
  const startTime = new Date(start);
  const endTime = new Date(end);
  const hours = (endTime.getTime() - startTime.getTime()) / (1000 * 60 * 60);
  return hours;
}
ChartJS.register(Title, Tooltip, Legend, BarElement, LineElement, ArcElement, CategoryScale, LinearScale);

const activeTab = ref(1);
const chartDataMonth: ChartData<'pie'> = {
  labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
  datasets: [
    {
      label: 'heures travaillées',
      backgroundColor: ['#ff9523', '#ffe177', '#ff7795', '#161616'],
      data: [30, 45, 40, 35],
    },
  ],
};


const chartDataWeek = ref<ChartData<'bar'>>({
  labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
  datasets: [
    {
      label: 'Clocks Working Hours',
      backgroundColor: '#41B883',
      data: [0, 0, 0, 0, 0, 0, 0],
    },
    {
      label: 'Working Time',
      backgroundColor: '#E46651',
      data: [0, 0, 0, 0, 0, 0, 0],
    },
  ],
});


const chartDataHours: ChartData<'line'> = {
  labels: ['00 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM', '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM', '12 AM', '00 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM', '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM', '12 PM'],
  datasets: [
    {
      label: 'heures travaillées',
      borderColor: '#ff9523',
      backgroundColor: 'rgba(255, 149, 35, 0.2)',
      borderWidth: 3,
      pointBackgroundColor: '#ff9523',
      data: [0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
    },
  ],
};

const barChartOptions: ChartOptions<'bar'> = {
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

const pieChartOptions: ChartOptions<'pie'> = {
  responsive: true,
  plugins: {
    legend: {
      position: 'top',
      labels: {
        color: '#4b5563',
      },
    },
  },
};

const lineChartOptions: ChartOptions<'line'> = {
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

async function updateChartData(iduser: string, idteam: string) {
  try {
    // Fetch clocks and working time data
    const clocksData = await fetchClocks(iduser);
    const workingTimeData = await fetchWorkingTime(idteam);

    // Debug: Affiche les données pour vérifier leur contenu
    console.log('Clocks Data:', clocksData);  // Vérifier le format des clocks
    console.log('Working Time Data:', workingTimeData);  // Vérifier le format des working times

    // Update the chart's dataset with the individual data for clocks and workingTime
    chartDataWeek.value.datasets[0].data = [
      clocksData.Monday || 0,
      clocksData.Tuesday || 0,
      clocksData.Wednesday || 0,
      clocksData.Thursday || 0,
      clocksData.Friday || 0,
      clocksData.Saturday || 0,
      clocksData.Sunday || 0,
    ];

    chartDataWeek.value.datasets[1].data = [
      workingTimeData.Monday || 0,
      workingTimeData.Tuesday || 0,
      workingTimeData.Wednesday || 0,
      workingTimeData.Thursday || 0,
      workingTimeData.Friday || 0,
      workingTimeData.Saturday || 0,
      workingTimeData.Sunday || 0,
    ];

    console.log('Chart data updated:', chartDataWeek.value);
  } catch (error) {
    console.error('Error updating chart data:', error);
  }
}



onMounted(() => {
  updateChartData(userId, teamId);
});


</script>

<style scoped>
.batCard {
  border-radius: 12px;
  padding: 20px;
}
</style>
