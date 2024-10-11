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
    id: number;
    name: string;
    email: string;
    password: string;
    role: Role;
}

export function createUser(user: User): void {
    axios.post('http://localhost:4000/api/users', user)
        .then(response => {
            (response.data);
        })
        .catch(error => {
            console.error('Erreur lors de la création de l\'utilisateur:', error);
            (null);
        });
}


export async function getuserId(iduser: number): Promise<User | null> {
    return axios.get(`http://localhost:4000/api/users/${iduser}`)
        .then(response => {
            console.log('Données reçues:', response.data);
            return response.data;
        })
        .catch(error => {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
            return null;
        });
}
export function manageUser(user: User,iduser:number): void {
    axios.put(`http://localhost/api/users/${iduser}`, user)
        .then(response => {
            (response.data);
        })
        .catch(error => {
            console.error('Erreur lors de la création de l\'utilisateur:', error);
            (null);
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