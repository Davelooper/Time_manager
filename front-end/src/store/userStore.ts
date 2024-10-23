import axios from 'axios';
import { reactive, computed, onMounted } from "vue"
import { jwtDecode } from 'jwt-decode';

// Interface de l'utilisateur et du rôle
interface Role {
  id: number;
  name: string;
}
interface Team {
  id: string;
  username: string; // Le nom ou identifiant affichable de l'équipe
}

interface UserState {
  isConnected: boolean;
  token: string;
}

export interface User {
  id?: string;
  username: string;
  email: string;
  password: string;
  team_id: string;
  role?: Role;
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
// TO DO ne pas faire de <any>
export function biometricAuth(credential: string): Promise<any> {
  return axios.post('http://localhost:4000/api/users/webauths', {
    token: credential // Envoi direct du token   
  })
    .then(response => {
      setToken(response.data.token); // Sauvegarde le token dans l'état
      state.isConnected = true; // Modifie l'état de connexion
      return response; // Retourne la réponse complète
    })
    .catch(error => {
      console.error('Erreur lors de l\'authentification biométrique:', error);
      throw error; // Lève l'erreur
    });
}
export function createAuth(credential: string,iduser: string): Promise<any> {
  console.log('TESTEJ SUIS PASSE ')
  return axios.post(`http://localhost:4000/api/users/webauths/${iduser}`, {
    token: credential 

  })
    .then(response => {
      setToken(response.data.token); // Sauvegarde le token dans l'état
      state.isConnected = true; // Modifie l'état de connexion
      return response; // Retourne la réponse complète
    })
    .catch(error => {
      console.error('Erreur lors de l\'authentification biométrique:', error);
      throw error; // Lève l'erreur
    });
}
// Fonction pour déconnecter l'utilisateur
export function logoutUser(): void {
  state.isConnected = false;
  deleteToken();  // Supprime le token du localStorage
}

export function setToken(token: string): void {
  state.token = token;
  localStorage.setItem('token', token);
}

// Fonction pour récupérer le token depuis localStorage
export function getToken(): string {
  if (state.token) return state.token;
  return localStorage.getItem('token') ?? '';
}
export function getDecodedToken(): any {
  const token = getToken(); // Récupérer le token stocké

  if (!token) {
    console.error("Aucun token disponible pour décoder");
    return null;
  }

  try {
    const decoded = jwtDecode(token);
    console.log("Token décodé:", decoded);
    return decoded;
  } catch (error) {
    console.error("Erreur lors du décodage du token:", error);
    return null;
  }
}

// Fonction pour supprimer le token de localStorage
function deleteToken(): void {
  localStorage.removeItem('token');
  state.token = '';
}
export function createUser(user: User): Promise<void> {
  console.log(user)
  return axios.post('http://localhost:4000/api/users', {
    user: {
      email: user.email,
      password: user.password,
      username: user.username,
      team_id: user.team_id
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

export async function getUserById(id: string): Promise<ManageUsers> {
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


export async function getAllTeams(): Promise<Team[]> {
  try {
    const response = await axios.get("http://localhost:4000/api/teams");
    return response.data; // Renvoie les données de l'utilisateur
  } catch (error) {
    console.error("Error fetching user:", error);
    throw error;
  }
}
