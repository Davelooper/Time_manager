<template>
  <Navbar />
  <div class="md:px-20 px-4 py-4">
    <div class="w-full max-w-96 pt-4">
      <Input
        v-if="role === 'admin'"
        type="select"
        label="User data view"
        :value="selectedId"
        :onChange="getUserData"
        :needToSave="false"
      >
        <option
          v-for="user in users"
          :key="user.value"
          :value="user.value"
        >
          {{ user.label }}
        </option>
      </Input>
    </div>
    <Tabs v-if="selectedUser" :tabs="tabs" />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import Navbar from '../components/Navbar.vue';
import Tabs from '@/components/Tabs.vue';
import Input from '@/components/Input.vue';
import UserDataTab from '@/components/UserDataTab.vue';
import UserParameterTab from '@/components/UserParameterTab.vue';
import axios from 'axios';
import { getToken, getDecodedToken } from '../store/userStore';

// Variables réactives
const users = ref<any[]>([]);
const decodedToken = getDecodedToken();
const { username, email, role, team_id, id } = decodedToken;

// Assurer que 'selectedId' est une chaîne de caractères
const selectedId = ref<string>(String(id));

// Fonction pour récupérer l'utilisateur sélectionné
const selectedUser = computed(() => {
  return users.value && Array.isArray(users.value)
    ? users.value.find(user => user.value === selectedId.value)
    : null;
});

// Définition des onglets
const tabs = ref([
  { title: 'Clocks', component: UserDataTab },
  { 
    title: 'Parameters', 
    component: UserParameterTab, 
    props: { data: selectedUser } 
  },
]);

// Fonction pour récupérer les données de l'utilisateur sélectionné
const getUserData = async (newValue: string) => {
  selectedId.value = newValue;
  try {
    const response = await axios.get(`http://localhost:4000/api/users/${newValue}`, {
      headers: {
        Authorization: `Bearer ${getToken()}`,
      },
    });
    console.log('Données de l\'utilisateur sélectionné :', response.data);
    // Traitez les données de l'utilisateur ici
  } catch (error) {
    console.error('Erreur lors de la récupération des données utilisateur :', error);
  }
};

// Fonction pour récupérer la liste des utilisateurs
const fetchUserListInHisContext = async () => {
  try {
    const response = await axios.get(`http://localhost:4000/api/users/team/${team_id}`, {
      headers: {
        Authorization: `Bearer ${getToken()}`,
      },
    });
    return formatUserList(response.data.data);
  } catch (error) {
    console.error('Erreur lors de la récupération de la liste des utilisateurs :', error);
    return [];
  }
};

// Fonction pour formater la liste des utilisateurs
const formatUserList = (userList: any[]) => {
  return userList.map((user: any) => ({
    value: String(user.id),
    label: `${user.username} (${user.role})`,
    user
  }));
};

// Récupérer la liste des utilisateurs au montage du composant
onMounted(() => {
  fetchUserListInHisContext()
    .then(fetchedUsers => { users.value = fetchedUsers; })
    .catch((error) => {
      console.error('Erreur lors du montage du composant :', error);
    });
});
</script>
