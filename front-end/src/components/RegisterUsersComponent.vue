<script setup lang="ts">
import { onMounted, ref,defineProps, defineEmits } from 'vue';

import { createUser, getAllTeams } from "../store/userStore"
import router from '@/router';

const props = defineProps({
  showModal: {
    type: Boolean,
    default: false // Définit la valeur par défaut de showModal
  }
});
const emit = defineEmits(['update:showModal']);

function closeModal() {
  emit('update:showModal', false); // Émet l'événement pour fermer la modal
}

interface User {
    email: string;
    username: string;
    password: string;
    team_id: string;
    role: string
}
interface Team {
    id: string;
    username: string; // Le nom ou identifiant affichable de l'équipe
}
const user = ref<User>({ email: '', username: '', password: '', team_id: '', role: '' });
const teams = ref<Team[]>([]);

async function fetchTeams() {
  try {
    const response = await getAllTeams();
    console.log('Response:', response);
    teams.value = response.data; // IL Y a PAS D ERREUR 
    console.log('Teams:', teams.value);
  } catch (error) {
    console.error('Erreur lors de la récupération des équipes:', error);
  }
}
async function registerForm() {
  console.log("REGISTER");
  try {
    await createUser(user.value);
    // router.push('/dashboard');
    closeModal();
  } catch (error) {
    console.error('Erreur lors de la création du compte:', error);
  }
}
onMounted(() => {
    fetchTeams();
});

</script>
<template>
     <button type="button" 
    @click="closeModal"
    class="w-full bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
    close modal
    </button>
    <div class="flex flex-row justify-center items-center w-full h-full">
        <div class="flex flex-row justify-center items-center w-full h-full">
            <div
                class="py-6 w-full max-w-md bg-gradient-to-tr from-amber-200 to-amber-400 rounded-lg shadow-lg dark:bg-gray-800">
                <img class="w-40 mx-auto" src="../assets/img/batman-character.png" alt="batman">
                <form @submit.prevent="registerForm" class="rounded p-8 mb-4">
                    <div class="mb-4">
                        <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Select Teams</label>
                        <select id="team" v-model="user.team_id" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                            <option value="" disabled selected>Choisissez une équipe</option>
                            <option v-for="team in teams"
                                :value="team.id">
                                {{ team.username }} <!-- Afficher le nom de l'équipe -->
                            </option>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email</label>
                        <input type="email" id="email" v-model="user.email"
                            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                            placeholder="Your email" />
                    </div>
                    <div class="mb-4">
                        <label for="username" class="block text-gray-700 text-sm font-bold mb-2">Username</label>
                        <input type="text" id="username" v-model="user.username"
                            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                            placeholder="Username" />
                    </div>

                    <div class="mb-4">
                        <label for="password" class="block text-gray-700 text-sm font-bold mb-2">Password</label>
                        <input type="password" id="password" placeholder="Your password" v-model="user.password"
                            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" />
                    </div>

                    <div class="mb-6">
                      <label for="team" class="block text-gray-700 text-sm font-bold mb-2">Role</label>
                      <select id="team" v-model="user.role" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline">
                          <option value="" disabled selected>Choisissez un rôle</option>
                          <option value="user"  selected>User</option>
                          <option value="manager">Manager</option>
                          <option value="admin" >Administrator</option>
                      </select>
                    </div>
                    


                    <div class="flex items-center justify-between w-full">
                        <button type="submit"
                            class="w-full bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
                            CreateUser
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</template>