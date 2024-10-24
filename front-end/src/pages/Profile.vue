<template>
  <Navbar />
  <div class="md:px-20 px-4 py-4">
    <h1 class="text-2xl md:text-4xl font-bold p-2 text-white">Welcome {{ username }}</h1>
    <Tabs :tabs="tabs" />
  </div>
</template>

<script setup lang="ts">
import ProgressDays from "@/components/ProgressDays.vue";
import RegisterUsersComponent from "@/components/RegisterUsersComponent.vue"
import Button from "@/components/Button.vue";
import ListUserByTeamsComponent from "@/components/ListUserByTeamsComponent.vue"
import Navbar from "../components/Navbar.vue"
import { getToken } from "../store/userStore";
import BatPing from "../components/BatPing.vue"
import TimeChartComponent from "@/components/TimeChartComponent.vue";
import {getDecodedToken} from "../store/userStore";
import Tabs from "@/components/Tabs.vue";
import { ref } from "vue";
import Progress7Days from "@/components/Progress7Days.vue";
import UserDataTab from "@/components/UserDataTab.vue";
import UserParameterTab from "@/components/UserParameterTab.vue";
// # define the props
const props = defineProps({
  token: {
    type: String,
    required: true,
    default: getToken(),
  },
});
const tabs = ref([
  { title: 'User', component: UserDataTab },
  { title: 'Parameters', component: UserParameterTab },
  { title: 'Biometric', component: Progress7Days   },
]);
const decodedToken = getDecodedToken(); 
const username = decodedToken.username; 

</script>
