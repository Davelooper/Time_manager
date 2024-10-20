<script setup lang="ts">
import { onMounted, ref } from 'vue';
import i18n from '@/store/i18n';
import router from '@/router';
import Navbar from '@/components/Navbar.vue';
import { createWorkingTime } from '../store/workingTimeStore';

interface WorkingTime {
  date: string;
}
interface CurrentUser {
  id: number;
}

const workingTimeModel = ref<WorkingTime>({
  date: '',
});
const currentUserModel = ref<CurrentUser>({
  id: 0,
});


function updateTime() {
  console.log("Date et heure mises à jour :");
}


function formatDateTime() {
  const parsedDate = new Date();
  const year = parsedDate.getFullYear();
  const month = String(parsedDate.getMonth() + 1).padStart(2, '0');
  const day = String(parsedDate.getDate()).padStart(2, '0');
  const hours = String(parsedDate.getHours()).padStart(2, '0');
  const minutes = String(parsedDate.getMinutes()).padStart(2, '0');
  const seconds = String(parsedDate.getSeconds()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

function addNewDate(iduser: number) {
  workingTimeModel.value.date = formatDateTime();
  console.log(workingTimeModel.value.date, iduser)
  // j envoi ma requete 
 // createWorkingTime(iduser, workingTimeModel.value)

 const currentTime = new Date().toLocaleTimeString('en-US', { 
    hour: '2-digit', 
    minute: '2-digit', 
    hour12: false 
  });
}

const showForm = ref(false);
const dateToday = ref('');

onMounted(() => {
  const today = new Date();
  const optionsDate: Intl.DateTimeFormatOptions = { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  };
  const optionsTime: Intl.DateTimeFormatOptions = { 
    hour: '2-digit', 
    minute: '2-digit', 
    hour12: true
  };

  dateToday.value = `${today.toLocaleDateString('en-US', optionsDate)} - ${today.toLocaleTimeString('en-US', optionsTime)}`;
  
  setTimeout(() => {
    showForm.value = true;
  }, 1000);
});

</script>

<template>
    <Navbar />
    <div class="mt-5 text-center">
      <h1
        class="mb-4 text-4xl text-center font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl dark:text-white">
        Badge her for gotham !</h1>
        <RouterLink to="/WorkingTime"
        class="rounded-md bg-yellow-300 w-48 py-2 px-4 border border-transparent text-center text-sm text-white transition-all shadow-md hover:shadow-lg focus:bg-slate-700 focus:shadow-none active:bg-slate-700 hover:bg-neutral-500 active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none ml-2">
        Manage Bat Time User
      </RouterLink>
      <div class="mx-auto w-full flex justify-center">
        <button @click="addNewDate(currentUserModel.id)" class="batman-button">
          <div class="batman-timer">
          </div>
        </button>
      </div>
      <h2 class="text-white text-2xl font-bold mt-5 today-date text-center">{{ dateToday }}</h2>
    </div>
</template>

<style scoped>
main {
  background-color: #161616 !important;
  overflow: hidden;
}


.batman-timer {
  background-image: url(../assets/img/batman.png);
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  width: 40rem;
  height: 400px;
  animation: rotate-scale-up 1s linear both;
  transition: all ease-in-out 0.2s;
}
@keyframes rotate-scale-up {
  0% {
    transform: scale(1) rotateZ(0)
  }

  50% {
    transform: scale(2) rotateZ(720deg)
  }

  100% {
    transform: scale(1) rotateZ(1080deg)
  }
}

.workingTime {
  display: flex;
  flex-direction: column;
}

.workingTime label {
  color: rgb(245 245 244);
}

.date-picker {
  position: relative;
  top: 150px;
  left: 10px;
}
.batman-button{
  position: relative;
  top: 100px;
  transition: all ease-in-out 0.2s;
}
.batman-button:hover{
  transform: scale(1.1);
}
.batman-button:active:hover {
  transform: scale(1);
  transition: all ease-in-out 0.1s;
}

.today-date{
  position: relative;
  top: 100px;
}
</style>
