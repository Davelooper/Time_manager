<script setup lang="ts">
import { ref } from 'vue';
import i18n from '@/store/i18n';
interface workingTime {
  start: string;
  end: string;
}
const workingTime = ref<workingTime>({
  start: '',
  end: ''    
});
function submitForm() {
  console.log('test')
}
const currentDate = ref(new Date()); // Crée une nouvelle date

console.log(currentDate.value)
</script>

<template>
  <div>
    <div class="mt-5">
      <h1 class="mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl dark:text-white">Badge her for gotham !</h1>
      <div class="batman-timer mx-auto ">
        <form @submit.prevent="submitForm" class="form-gotham">
          <div class="date-picker flex flex-wrap justify-evenly w-3/4 mx-auto">
            <div class="workingTime w-1/2">
              <label for="starting">Start</label>
              <input type="date" id="date-picker"
                class="peer h-full w-full rounded-[7px] border border-blue-gray-200 border-t-transparent  px-3 py-2.5 font-sans text-sm font-normal text-blue-gray-700 outline outline-0 transition-all placeholder-shown:border placeholder-shown:border-blue-gray-200 placeholder-shown:border-t-blue-gray-200 focus:border-2 focus:border-gray-900 focus:border-t-transparent focus:outline-0 disabled:border-0 disabled:bg-blue-gray-50" 
                v-model="workingTime.start"
                />
            </div>
            <div class="workingTime w-1/2">
              <label for="ending">End</label>
              <input type="date" id="date-picker"
                class="peer h-full w-full rounded-[7px] border border-blue-gray-200 border-t-transparent  px-3 py-2.5 font-sans text-sm font-normal text-blue-gray-700 outline outline-0 transition-all placeholder-shown:border placeholder-shown:border-blue-gray-200 placeholder-shown:border-t-blue-gray-200 focus:border-2 focus:border-gray-900 focus:border-t-transparent focus:outline-0 disabled:border-0 disabled:bg-blue-gray-50"
                v-model="workingTime.end" />
            </div>
            <button class="w-1/3 mt-5 rounded-md bg-yellow-300 py-2 px-4 border border-transparent text-center text-sm text-white transition-all shadow-md hover:shadow-lg focus:bg-slate-700 focus:shadow-none active:bg-slate-700 hover:bg-neutral-500 active:shadow-none disabled:pointer-events-none disabled:opacity-50 disabled:shadow-none ml-2" type="button">
  Valider
</button>
          </div>
       
        </form>

      </div>

    </div>
  </div>
</template>

<style scoped>
main{
  background-color: #161616 !important;
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
