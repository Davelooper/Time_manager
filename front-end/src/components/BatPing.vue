<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue';
import i18n from '@/store/i18n';
import router from '@/router';
import Navbar from '@/components/Navbar.vue';
import { createClocks } from '@/store/clocksStore';
import {getDecodedToken} from '@/store/userStore';

interface Clocks {
    time: string;
}

const clocksModel = ref<Clocks>({
    time: ''
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



async function addNewDate() {
    clocksModel.value.time = formatDateTime(); // Récupérer et formater l'heure actuelle
    console.log(clocksModel);

    // Fonction d'authentification WebAuthn
    async function webauthnAuth(): Promise<boolean> {
        try {
            const publicKey = {
                challenge: new Uint8Array(16), // Remplacez ceci par un vrai challenge unique
                rp: {
                    name: 'Your Website Name'
                },
                user: {
                    id: new Uint8Array(16), // ID utilisateur unique
                    name: "User's Name",
                    displayName: "User's Display Name"
                },
                pubKeyCredParams: [
                    {
                        type: 'public-key',
                        alg: -7 // Algorithm, typiquement ES256
                    }
                ],
                timeout: 60000, // Délai d'attente
                attestation: 'direct',
                authenticatorSelection: {
                    userVerification: 'preferred',
                    requireResidentKey: false
                }
            };

            // Essayer d'obtenir les informations d'identification
            const credential = await navigator.credentials.get({ publicKey });

            // Vérifiez si les informations d'identification ont été récupérées
            if (credential) {
                console.log('Authentification réussie:', credential);
                return true; // L'authentification a réussi
            } else {
                console.error('Aucune information d\'identification récupérée.');
                return false; // Aucune information d'identification récupérée
            }
        } catch (error) {
            console.error('Erreur lors de l\'authentification WebAuth:', error);
            return false; // En cas d'erreur, renvoie false
        }
    }

    // Vérification de l'authentification WebAuthn
    const isAuthenticated = await webauthnAuth();
    if (!isAuthenticated) {
        console.error('Authentification WebAuthn échouée.');
        return; // Arrêtez l'exécution si l'authentification échoue
    }

    // Récupération de l'ID utilisateur depuis le token
    const decodedToken = getDecodedToken();
    let iduser: string | null = null;

    if (decodedToken && decodedToken.id) {
        iduser = decodedToken.id;
        console.log('ID de l\'utilisateur:', iduser);
    }

    // Création de l'horloge si l'ID utilisateur est récupéré
    if (iduser) {
        createClocks(clocksModel.value, iduser);
    } else {
        console.error("Impossible de récupérer l'ID utilisateur.");
    }
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
        <button @click="addNewDate()" class="batman-button">
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