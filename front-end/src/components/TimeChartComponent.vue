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
      <li @click="activeTab = 3" class="cursor-pointer py-2 px-4 text-gray-600 dark:text-gray-400 border-b-2"
        :class="activeTab === 3 ? 'border-blue-500 text-blue-500' : 'border-transparent'">
        Daily
      </li>
      <button @click="fetchClocksWeek(userId)" class="text-blue-800"> TEST CLOCKS </button>
      <button @click="fetchWorkingTimeWeek(teamId)" class="text-blue-800"> TEST workingTime </button>

    </ul>
    <div class="p-4 flex flex-row justify-center">
      <div class="size-96" v-if="activeTab === 1">
        <Pie :data="chartDataMonth" :options="pieChartOptions" />
      </div>
      <div class="h-96 w-[700px]" v-if="activeTab === 2">
        <Bar :data="chartDataWeek" :options="barChartOptions" />
      </div>
      <div class="w-[700px] h-96" v-if="activeTab === 3">
        <Bar :data="chartDataHours" :options="lineChartOptions" />
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import { Bar, Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, LineElement, ArcElement, CategoryScale, LinearScale } from 'chart.js';
import type { ChartOptions, ChartData } from 'chart.js';
import { getClocksByUserId } from '../store/clocksStore';
import { getDecodedToken } from '../store/userStore';
import { getAllWorkingTimeByUser } from '../store/workingTimeStore';
import dayjs from 'dayjs';
import isBetween from 'dayjs/plugin/isBetween';

interface HoursWorkedPerDay {
  Monday: number;
  Tuesday: number;
  Wednesday: number;
  Thursday: number;
  Friday: number;
  Saturday: number;
  Sunday: number;
}
dayjs.extend(isBetween);

const decodedToken = getDecodedToken();
const userId = decodedToken.id;
const teamId = decodedToken.team_id

async function fetchClocksWeek(iduser: string) {
  try {
    const response = await getClocksByUserId(iduser);
    console.log('GET CLOCKS RESPONSE:', response);

    // Validate the response structure
    if (!response || !response.data || !Array.isArray(response.data)) {
      console.error('Invalid response structure:', response);
      throw new Error("Response is not an array or contains no data.");
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

    for (let i = 0; i < clocks.length; i += 2) {
      if (i + 1 < clocks.length) {
        const startEntry = clocks[i];
        const endEntry = clocks[i + 1];

        const startDay = dayjs(startEntry.time).format('dddd');
        const endDay = dayjs(endEntry.time).format('dddd');
        if (
          ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'].includes(startDay) &&
          startDay === endDay // Ensure start and end are on the same day
        ) {
          const hoursWorked = calculateWorkingHours(dayjs(startEntry.time), dayjs(endEntry.time));
          hoursWorkedByDayClocks[startDay] = hoursWorked; // Add hours worked to the corresponding day
        } else if (startDay !== endDay) {
          console.warn('Start and end times are on different days:', startDay, endDay);
        }
      } else {
        console.warn(`Unpaired start time found at index ${i}, skipping entry.`);
      }
    }
    console.log('Calculated Hours Worked by Day:', hoursWorkedByDayClocks);
    return hoursWorkedByDayClocks;
  } catch (error) {
    console.error('Error fetching clocks:', error);
    return null; // Return null to indicate failure
  }
}
async function fetchWorkingTimeWeek(idteam: string): Promise<HoursWorkedPerDay> {
  try {
    const response = await getAllWorkingTimeByUser(idteam);

    if (!response || !response.data) {
      throw new Error("Aucune donnée disponible.");
    }

    const workingTimes = response.data;

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
      const dayOfWeek = dayjs(entry.start).format('dddd'); // Utilisation de day.js pour obtenir le jour
      const hoursWorked = calculateWorkingHours(dayjs(entry.start), dayjs(entry.end)); // Appel avec day.js

      if (hoursWorkedPerDay[dayOfWeek] !== undefined) {
        hoursWorkedPerDay[dayOfWeek] += hoursWorked / 2;
      }
    });

    return hoursWorkedPerDay; // Retourne un objet contenant les jours de la semaine
  } catch (error) {
    console.error('Erreur lors de la récupération des heures travaillées:', error);
    throw error;
  }

}

async function fetchClocksMonth(iduser: string) {
  try {
    const response = await getClocksByUserId(iduser);
    console.log('Clocks Data:', response);

    // Validate response structure
    if (!response || !response.data || !Array.isArray(response.data)) {
      console.error('Invalid response structure:', response);
      throw new Error("The response is not an array or contains no data.");
    }

    const clocks = response.data;

    // Initialize hours worked by month
    const hoursWorkedByMonth: { [key: string]: number } = {};

    // Iterate through clocks in pairs of start and end times
    for (let i = 0; i < clocks.length; i += 2) {
      if (i + 1 < clocks.length) {
        const startEntry = clocks[i];
        const endEntry = clocks[i + 1];

        // Format month as "MMMM YYYY"
        const month = dayjs(startEntry.time).format('MMMM YYYY');

        // Calculate hours worked between start and end
        const hoursWorked = calculateWorkingHours(dayjs(startEntry.time), dayjs(endEntry.time));

        // Add hours to the respective month
        if (!hoursWorkedByMonth[month]) {
          hoursWorkedByMonth[month] = 0;
        }
        hoursWorkedByMonth[month] += hoursWorked;
      } else {
        console.warn(`Unpaired start time found at index ${i}, skipping entry.`);
      }
    }

    console.log('Calculated Monthly Clocked Hours:', hoursWorkedByMonth);
    return hoursWorkedByMonth;

  } catch (error) {
    console.error('Error fetching clocks by month:', error);
  }
}

async function fetchWorkingTimeMonth(idteam: string) {
  try {
    const response = await getAllWorkingTimeByUser(idteam);
    console.log('Working Time Data:', response);

    // Validate response structure
    if (!response || !response.data || !Array.isArray(response.data)) {
      console.error('Invalid response structure:', response);
      throw new Error("The response is not an array or contains no data.");
    }

    const workingTimes = response.data;

    // Initialize hours worked by month
    const hoursWorkedByMonth: { [key: string]: number } = {};

    workingTimes.forEach((entry: { start: string; end: string }) => {
      const startMonth = dayjs(entry.start).format('MMMM YYYY'); // Month and year format

      // Calculate hours worked in this entry
      const hoursWorked = calculateWorkingHours(dayjs(entry.start), dayjs(entry.end));

      // Add to the corresponding month
      if (!hoursWorkedByMonth[startMonth]) {
        hoursWorkedByMonth[startMonth] = 0;
      }
      hoursWorkedByMonth[startMonth] += hoursWorked;
    });

    console.log('Calculated Monthly Working Hours:', hoursWorkedByMonth);
    return hoursWorkedByMonth;

  } catch (error) {
    console.error('Error fetching working time by month:', error);
  }
}

async function fetchClocksForToday(iduser: string): Promise<number> {
  try {
    const response = await getClocksByUserId(iduser);
    console.log('GET CLOCKS RESPONSE FOR TODAY:', response);

    // Validate response structure
    if (!response || !response.data || !Array.isArray(response.data)) {
      console.error('Invalid response structure:', response);
      throw new Error("Response is not an array or contains no data.");
    }

    const clocks = response.data;
    console.log('Raw Clocks Data:', clocks); // Log raw clocks data

    const today = dayjs().startOf('day');

    // Filter clocks to only include today's entries
    const clocksToday = clocks.filter((entry: { time: string }) =>
      dayjs(entry.time).isSame(today, 'day')
    );

    // Log the clocks for today to see if they are filtered correctly
    console.log('Clocks Today:', clocksToday);

    // Sort the clocks today by time (ascending)
    clocksToday.sort((a: { time: string }, b: { time: string }) =>
      dayjs(a.time).diff(dayjs(b.time))
    );

    // Take only the last two clock entries
    const lastTwoClocks = clocksToday.slice(-2);
    console.log('Last Two Clocks:', lastTwoClocks);

    let totalHoursWorkedToday = 0;

    // Ensure we have exactly two entries for a valid calculation
    if (lastTwoClocks.length === 2) {
      const startEntry = lastTwoClocks[0];
      const endEntry = lastTwoClocks[1];

      const startTime = dayjs(startEntry.time);
      const endTime = dayjs(endEntry.time);

      // Log each pair of start and end times
      console.log(`Start Entry: ${startEntry.time}, End Entry: ${endEntry.time}`);

      // Calculate working hours
      const hoursWorked = calculateWorkingHours(startTime, endTime);
      totalHoursWorkedToday += hoursWorked;

      console.log(`Calculated Hours Worked: ${hoursWorked}`); // Log calculated hours
    } else {
      console.warn('Not enough clock entries to calculate hours worked for today.');
    }

    console.log('Total Hours Worked Today:', totalHoursWorkedToday);
    return totalHoursWorkedToday;
  } catch (error) {
    console.error('Error fetching clocks for today:', error);
    return 0; // Return 0 hours if there’s an error
  }
}

async function fetchWorkingTimeToday(idteam: string): Promise<number> {
  try {
    // Fetch all working time data for the team
    const response = await getAllWorkingTimeByUser(idteam);

    // Handle empty or invalid response data
    if (!response || !response.data || !Array.isArray(response.data)) {
      console.error("Invalid response structure or no data available:", response);
      return 0; // Return 0 if response is invalid
    }

    // Define the start and end of the current day
    const todayStart = dayjs().startOf('day');
    const todayEnd = dayjs().endOf('day');

    let hoursWorkedToday = 0;

    response.data.forEach((entry: { start: string; end: string }) => {
      const entryStart = dayjs(entry.start);
      const entryEnd = dayjs(entry.end);

      // Log the entry being processed
      console.log(`Processing entry: Start - ${entry.start}, End - ${entry.end}`);

      // Check if the entry starts and ends within today
      if (entryStart.isBetween(todayStart, todayEnd, null, '[]')) {
        const hoursWorked = calculateWorkingHours(entryStart, entryEnd);
        hoursWorkedToday += hoursWorked;

        console.log(`Hours worked for this entry: ${hoursWorked}`); // Log calculated hours
      }
    });

    console.log(`Total hours worked today: ${hoursWorkedToday}`); // Log total hours worked
    return hoursWorkedToday; // Returns total hours worked today
  } catch (error) {
    console.error('Error fetching working time for today:', error);
    return 0; // Return 0 on error
  }
}


function calculateWorkingHours(start: dayjs.Dayjs, end: dayjs.Dayjs): number {
  const hours = end.diff(start, 'hour'); // Utilisation de day.js pour calculer les heures
  return hours;
}

ChartJS.register(Title, Tooltip, Legend, ArcElement, BarElement, LineElement, ArcElement, CategoryScale, LinearScale);

const activeTab = ref(1);
const chartDataMonth: ChartData<'pie'> = {
  labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
  datasets: [
    {
      label: 'Total Hours (Clock + Working)',
      backgroundColor: ['#ff9523', '#ffe177', '#ff7795', '#161616'], // Distinct colors for each week
      data: [0, 0, 0, 0], // Combined hours for each week
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

const chartDataHours: ChartData<'bar'> = {
  labels: ['00 AM', '01 AM', '02 AM', '03 AM', '04 AM', '05 AM', '06 AM', '07 AM', '08 AM', '09 AM', '10 AM', '11 AM', '12 AM', '00 PM', '01 PM', '02 PM', '03 PM', '04 PM', '05 PM', '06 PM', '07 PM', '08 PM', '09 PM', '10 PM', '11 PM', '12 PM'],
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

const lineChartOptions: ChartOptions<'bar'> = {
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

async function updateChartDataByWeek(iduser: string, idteam: string) {
  try {
    const workingTimeData = await fetchWorkingTimeWeek(idteam);
    const clocksTimeData = await fetchClocksWeek(iduser);  // Now holds the correct data from fetchClocks

    // Check clocksTimeData to make sure it's correctly returned
    if (!clocksTimeData) {
      console.error('Clocks data could not be fetched or is empty.');
      return;
    }

    // Structure data for each day of the week from workingTimeData
    const workingTimeDataArray = [
      workingTimeData.Monday || 0,
      workingTimeData.Tuesday || 0,
      workingTimeData.Wednesday || 0,
      workingTimeData.Thursday || 0,
      workingTimeData.Friday || 0,
      workingTimeData.Saturday || 0,
      workingTimeData.Sunday || 0,
    ];

    // Map the clocksTimeData to an array matching days of the week
    const clocksTimeArray = [
      clocksTimeData.Monday || 0,
      clocksTimeData.Tuesday || 0,
      clocksTimeData.Wednesday || 0,
      clocksTimeData.Thursday || 0,
      clocksTimeData.Friday || 0,
      clocksTimeData.Saturday || 0,
      clocksTimeData.Sunday || 0,
    ];

    // Update chart datasets with the fetched data
    chartDataWeek.value.datasets[0].data = clocksTimeArray;
    chartDataWeek.value.datasets[1].data = workingTimeDataArray;

    console.log('Chart data successfully updated:', chartDataWeek.value);

  } catch (error) {
    console.error('Error updating chart data:', error);
  }
}
async function updateChartDataByMonth(iduser: string, idteam: string) {
  try {
    // Fetch monthly clock data and working time data
    const clocksData = await fetchClocksMonth(iduser);
    const workingTimeData = await fetchWorkingTimeMonth(idteam);

    // Define arrays for storing weekly worked hours and scheduled hours
    const totalHoursPerWeek = [0, 0, 0, 0]; // Combined hours per week

    // Aggregate the hours worked by week
    Object.entries(clocksData).forEach(([day, hoursWorked]) => {
      const weekIndex = getWeekIndexFromDay(day);
      if (weekIndex >= 0 && weekIndex < 4) {
        totalHoursPerWeek[weekIndex] += hoursWorked; // Add clock hours
      }
    });

    // Aggregate the scheduled working hours by week
    Object.entries(workingTimeData).forEach(([day, hours]) => {
      const weekIndex = getWeekIndexFromDay(day);
      if (weekIndex >= 0 && weekIndex < 4) {
        totalHoursPerWeek[weekIndex] += hours; // Add working hours
      }
    });

    // Update the pie chart data for the combined dataset
    chartDataMonth.datasets[0].data = totalHoursPerWeek; // Combined total hours for each week

    console.log('Monthly chart data updated:', chartDataMonth);
  } catch (error) {
    console.error('Error updating monthly chart data:', error);
  }
}

async function updateChartDataByDay(iduser: string, idteam: string) {
  try {
    const clocksData = await fetchClocksForToday(iduser); // Assumes it returns total hours worked today
    const workingTimeData = await fetchWorkingTimeToday(idteam); // Assumes it returns total planned hours today

    // Prepare total hours for the chart
    const totalHours = [
      clocksData, // Total hours from clocks
      workingTimeData // Total hours from working time
    ];

    // Update the chart data
    chartDataHours.datasets[0].data = [totalHours[0], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // Hours worked
    chartDataHours.datasets[1].data = [totalHours[1], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; // Planned working hours

    console.log('Chart data updated for today:', chartDataHours);
  } catch (error) {
    console.error('Error updating daily chart data:', error);
  }
}


function getWeekIndexFromDay(day: string): number {
  const date = dayjs(day);
  return Math.floor((date.date() - 1) / 7); // Returns 0 for week 1, 1 for week 2, etc.
}

onMounted(() => {
  updateChartDataByWeek(userId, teamId);
  updateChartDataByMonth(userId, teamId)
  updateChartDataByDay(userId,teamId)
});
</script>

<style scoped>
.batCard {
  border-radius: 12px;
  padding: 20px;
}
</style>
