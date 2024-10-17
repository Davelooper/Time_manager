import axios from 'axios';
import { reactive, computed, onMounted } from "vue"

// Interface de l'utilisateur et du rôle
interface Role {
  id: number;
  name: string;
}

interface UserState {
  isConnected: boolean;
  token: string;
}
export interface ManageUsers {
  data: any;
  id: number;
  username: string;
  email: string;
  password: string;
}

// Création de l'état réactif de l'utilisateur
const state = reactive<UserState>({
  isConnected: false,
  token: localStorage.getItem('token') || '' // Token récupéré du localStorage au démarrage
});

// Fonction pour vérifier le token à l'aide d'une API
export function verifyToken(): void {
  const token = getToken();  // Récupère le token stocké dans localStorage

  console.log("Vérification du token:");
  console.log(token);

  if (!token) return;  // Si aucun token, ne pas faire de vérification

  axios.get('http://localhost:4000/api/users/verifyToken', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  })
    .then((response) => {  // Si la requête est un succès
      console.log("Token validé avec succès:", response.data);
      state.isConnected = true;
    })
    .catch((error) => {  // Si la requête échoue
      console.error("Erreur lors de la vérification du token:", error);
      logoutUser();  // Déconnecter l'utilisateur en cas d'échec
    });
}


// Fonction pour utiliser les données de l'utilisateur
export function useUser() {
  const isConnected = computed(() => state.isConnected);  // Propriété calculée pour savoir si l'utilisateur est connecté

  onMounted(() => {
    verifyToken();  // Vérifie le token à chaque montage du composant utilisant ce store
  });

  return {
    isConnected,
    loginUser: authUser,
    logoutUser,
    token: computed(() => state.token)
  };
}

// Interface pour l'utilisateur
export interface User {
  id?: number;
  username: string;
  email: string;
  password: string;
  role?: Role;
}

// Fonction pour authentifier l'utilisateur
export function authUser(user: User): Promise<void> {
  return axios.post('http://localhost:4000/api/users/log_in', {
    email: user.email,
    password: user.password,
  })
    .then(response => {
      setToken(response.data.token);  // Stocke le token après connexion
      state.isConnected = true;
    })
    .catch(error => {
      console.error('Erreur lors de la connexion:', error);
      throw error;
    });
}

// Fonction pour déconnecter l'utilisateur
export function logoutUser(): void {
  state.isConnected = false;
  deleteToken();  // Supprime le token du localStorage
}

// Fonction pour stocker le token dans localStorage
export function setToken(token: string): void {
  state.token = token;
  localStorage.setItem('token', token);
}

// Fonction pour récupérer le token depuis localStorage
export function getToken(): string {
  return localStorage.getItem('token') ?? '';
}

// Fonction pour supprimer le token de localStorage
function deleteToken(): void {
  localStorage.removeItem('token');
  state.token = '';
}
export function createUser(user: User): Promise<void> {
  return axios.post('http://localhost:4000/api/user', {
    user: {
      email: user.email,
      password: user.password,
      username: user.username,
    }
  })
    .then(response => {
      console.log('Utilisateur créé:', response.data);
    })
    .catch(error => {
      console.error('Erreur lors de la création de l\'utilisateur:', error);
      throw error;
    });
}
export function updateUser(user: User, iduser: number): void {
  axios.put(`http://localhost/api/users/${iduser}`, {
    user: {
      email: user.email,
      password: user.password,
      username: user.username ?? ''
    }
  })
    .then(response => {
      console.log('Utilisateur manager:', response.data);
    })
    .catch(error => {
      console.error('Erreur lors de la création de l\'utilisateur:', error);
      throw error;
    });
}
export async function getUserById(id: number): Promise<ManageUsers> {
  try {
    const response = await axios.get(`http://localhost:4000/api/users/${id}`);
    return response.data; // Renvoie les données de l'utilisateur
  } catch (error) {
    console.error("Error fetching user:", error);
    throw error;
  }
}

export async function getAllUser(): Promise<User> {
  try {
    const response = await axios.get("http://localhost:4000/api/users");
    return response.data; // Renvoie les données de l'utilisateur
  } catch (error) {
    console.error("Error fetching user:", error);
    throw error;
  }
}
// Exemple d'autres fonctions API...
