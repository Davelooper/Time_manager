<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue';
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
const optionsDate: Intl.DateTimeFormatOptions = { year: 'numeric', month: 'long', day: 'numeric' };
const optionsTime: Intl.DateTimeFormatOptions = { hour: '2-digit', minute: '2-digit', second: '2-digit' };

const updateDateTime = () => {
    const today = new Date();
    dateToday.value = `${today.toLocaleDateString('en-US', optionsDate)} - ${today.toLocaleTimeString('en-US', optionsTime)}`;
};
let intervalId: number;
onMounted(() => {
    const today = new Date();
    updateDateTime();
    intervalId = window.setInterval(updateDateTime, 1000); // Actualiser chaque seconde


    dateToday.value = `${today.toLocaleDateString('en-US', optionsDate)} - ${today.toLocaleTimeString('en-US', optionsTime)}`;

    setTimeout(() => {
        showForm.value = true;
    }, 1000);
});
onBeforeUnmount(() => {
    clearInterval(intervalId);
    return {
        dateToday
    };
});

</script>
<template>
    <div class="flex flex-col ">
    <h2 class="text-white text-2xl font-bold today-date text-center">{{ dateToday }}</h2>
        <button @click="addNewDate(currentUserModel.id)" class="batman-button">
            <div class="batman-timer">
            </div>
        </button>
</div>

</template>

<style>
.batman-timer {
    background-image: url(../assets/img/batman.png);
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    width: 20rem;
    height: 400px;
    animation: rotate-scale-up 1s linear both;
    transition: all ease-in-out 0.2s;
    margin: auto;
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

.batman-button {
    transition: all ease-in-out 0.2s;
}

.batman-button:hover {
    transform: scale(1.1);
}

.batman-button:active:hover {
    transform: scale(1);
    transition: all ease-in-out 0.1s;
}
.today-date{
    position: relative;
    top:25px;
}

</style>