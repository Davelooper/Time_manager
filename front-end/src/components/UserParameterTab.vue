<template>
  <h2 class="text-slate-200 text-2xl pb-2 "> There is your personal data. Only you and your manager can see them</h2>
  <Input type="text" :value="props.data.user.id" label="ID" placeholder="Your id" v-if="role === 'admin'" disabled/>
  <div class="flex flex-row gap-4">
    <Input type="text" :value="props.data.user.username" label="Username" placeholder="Your username" />
    <Input type="text" :value="props.data.user.email" label="Email" placeholder="Your Email" />
  </div>
  <Input type="text" value="***********" label="Password" placeholder="Your Password" :disabled="!props.data || (props.data.id !== id)"/>
  <div class="flex flex-row gap-4">
    <Input type="select" :value="props.data.user.role" label="Role" :disabled="role !== 'admin'">
      <option value="admin">Admin</option>
      <option value="manager">Manager</option>
      <option value="user">User</option>
    </Input>
    <Input type="select" :value="team_id" label="Team" disabled >
      <option v-for="team in teams" :key="team.value" :value="team.value">
        {{ team.label }}
      </option>
    </Input>
  </div>
</template>
<script setup lang="ts">
import { getAllTeams, getDecodedToken, getToken } from '@/store/userStore';
import Button from './Button.vue';
import Input from './Input.vue';
import axios from 'axios';
import { data } from '@/store/chartConfig';
import { onMounted, ref } from 'vue';
const decodedToken = getDecodedToken(); 
const { username, email, role, team_id, id } = decodedToken;
const props = defineProps({
  data: {
    type: Object,
    required: true,
  },  
}
);

const getTeamsList = async () => {
  const response = await getAllTeams();
  console.log('response', response.data);
  
  if (!Array.isArray(response?.data)) return [];
  if (!response?.data) return [];
  
  return response.data.map((team: any) => ({
    value: team.id,
    label: team.username,
  }));
};
const teams = ref<{ value: any; label: any }[]>([]);
onMounted(async () => {
  const dataTeams = await getTeamsList();
  console.log('dataTeams', dataTeams);
  
  if (!dataTeams || !Array.isArray(dataTeams)) return;
  teams.value = dataTeams;
});
</script > 