<template>
  <Navbar />

    <h1 class="text-2xl md:text-4xl font-bold mb-4 text-white">Welcome to your profile</h1>
    <!-- <p class="text-lg md:text-xl mb-8 text-white">Here you can see your personal information</p> -->

     <div class="flex flex-row gap-4 justify-center flex-wrap">
       <div class="flex flex-col md:flex-row items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg">
            <BatPing />
          </div>
          <div class="max-w-[600px] w-full flex flex-col md:flex-row items-center bg-gradient-to-br backdrop-blur-lg from-slate-800/10 to-slate-500/20 rounded-lg p-2 shadow-lg gap-6">

       <ProgressDays title="This Month" :data="[10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]"/>
     </div>
    <div class="flex flex-col md:flex-row justify-between gap-6">
        <ProgressDays title="This Week" :data="[10, 20, 30, 40, 50, 60, 70]"/>
    </div>
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
// # define the props
const props = defineProps({
  token: {
    type: String,
    required: true,
    default: getToken(),
  },
});
</script>
