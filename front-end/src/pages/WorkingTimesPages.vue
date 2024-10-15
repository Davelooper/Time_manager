<script setup lang="ts">
import { onMounted, ref } from 'vue';
import i18n from '@/store/i18n';
import router from '@/router';
import Navbar from '@/components/Navbar.vue';
import {createWorkingTime} from'../store/workingTimeStore';

interface workingTime {
  start: string;
  end: string;
}
const workingTimeModel = ref<workingTime>({
  start: '',
  end:'',
});


function updateTime() {
  console.log("Date et heure mises à jour :");
}

function addNewDate(iduser: number){
  //  createWorkingTime(iduser,)

  }

const showForm = ref(false);
onMounted(() => {
  setTimeout(() => {
    showForm.value = true;
  }, 1000); 
});
</script>

<template>
  <div>
    <Navbar />
    <div class="mt-5">
      <h1 class="mb-4 text-4xl text-center font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl dark:text-white">Badge her for gotham !</h1>
      <div class="batman-timer mx-auto ">
        <form @submit.prevent="addNewDate(1)" class="form-gotham" id="gothamTime"v-if="showForm">
          <div class="date-picker flex flex-wrap justify-evenly w-3/4 mx-auto">
            <div class="workingTime w-1/2">
              <label for="starting">Start</label>
              <input type="datetime-local" @change="updateTime" v-model="workingTimeModel.start" id="start-time" class="bg-gray-50 border leading-none border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" min="09:00" max="18:00" value="00:00" required />

            </div>
            <div class="workingTime w-1/2">
              <label for="ending">End</label>
              <input type="datetime-local" @change="updateTime" v-model="workingTimeModel.end" id="start-time" class="bg-gray-50 border leading-none border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" min="09:00" max="18:00" value="00:00" required />
            </div>
            <button class="w-1/3 mt-5 rounded-md bg-yellow-300 py-2 px-4 border border-transparent text-center text-sm text-white transition-all shadow-md hover:shadow-lg focus:bg-slate-700 focus:shadow-none active:bg-slate-700 hover:bg-neutral-500 active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none ml-2" type="submit">
            Valider
          </button>
          </div>
        </form>
        <div class="w-80 mx-auto bat-pos text-center" v-if="showForm">
        <RouterLink to="/WorkingTime" class="rounded-md bg-yellow-300 py-2 px-4 border border-transparent text-center text-sm text-white transition-all shadow-md hover:shadow-lg focus:bg-slate-700 focus:shadow-none active:bg-slate-700 hover:bg-neutral-500 active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none ml-2">
          Manage Bat Time User 
        </RouterLink>
      </div>
      </div>
    </div>
  
  </div>
</template>

<style scoped>
main{
  background-color: #161616 !important;
}
.bat-pos{
  position: relative;
  top: 300px;
}

.batman-timer {
  background-image: url(../assets/img/batman.png);
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  width: 40rem;
  height: 400px;
  animation: rotate-scale-up 1s linear both;
  position: relative;
  top: 200px;
  transition: all ease-in-out 0.2s ;
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

</style>  
