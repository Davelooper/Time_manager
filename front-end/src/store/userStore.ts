import axios from 'axios';
import { reactive, computed } from "vue"
interface Role {
    id: number;
    name: string;
}
interface UserState {
    isConnected: boolean;
}
const state = reactive<UserState>({
    isConnected: false,
})

export function useUser() {
    const isConnected = computed(() => state.isConnected)
    return {
        isConnected,
    }
}

export interface User {
    id?: number;
    username: string;
    email: string;
    password: string;
    role?: Role;
}

export interface ManageUsers {
    data: any;
    id: number;
    username: string;
    email: string;
    password: string;
}

export function createUser(user: User): Promise<void> {
    return axios.post('http://localhost:4000/api/users', {
    user: {
        email: user.email,
        password: user.password,
        username:user.username
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
  
  export async function getUserById(id: number): Promise<ManageUsers> {
    try {
      const response = await axios.get(`http://localhost:4000/api/users/${id}`);
      return response.data; // Renvoie les données de l'utilisateur
    } catch (error) {
      console.error("Error fetching user:", error);
        throw error;
    }
  }
export function updateUser(user: User,iduser:number): void {
    axios.put(`http://localhost/api/users/${iduser}`,{
        user: {
        email: user.email,
        password: user.password,
        username:user.username ?? ''
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
export function deleteUser(idUser: number): void {
    axios.delete(`http://localhost/api/users/${idUser}`)
        .then(response => {
            (response.data);
        })
        .catch(error => {
            console.error('Erreur lors de la création de l\'utilisateur:', error);
            (null);
        });
}
/*
* tO DO
* ADD API CALL FOR AUTH 
*/