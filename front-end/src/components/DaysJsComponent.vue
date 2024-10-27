<template>

    <h1>TEST</h1>
</template>
<script setup lang="ts">
import { getClocksByUserId } from '../store/clocksStore';
import { getDecodedToken } from '../store/userStore';
import { getAllWorkingTimeByUser } from '../store/workingTimeStore';
import * as dayjs from 'dayjs'

interface HoursWorkedPerDay {
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


    return clocks;
  } catch (error) {
    console.error('Erreur lors de la récupération des heures de travail:', error)
  }
}
async function fetchWorkingTime(idteam: string): Promise<HoursWorkedPerDay> {
  try {
    const response = await getAllWorkingTimeByUser(idteam);

    if (!response || !response.data) {
      throw new Error("Aucune donnée disponible.");
    }

    const workingTimes = response.data;
return workingTimes;
  } catch (error) {
    console.error('Erreur lors de la récupération des heures travaillées:', error);
    throw error;
  }
}
</script>