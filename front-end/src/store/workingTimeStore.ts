import axios from 'axios';
import {getToken} from './userStore'
const token = getToken(); // Récupérer le token JWT

interface WorkingTime {
    date: string;
  }

export function createWorkingTime(idUser:number, workingTime:WorkingTime) {
    axios.post(`http://localhost:4000/api/workingtime/${idUser}`, {
        working_time: {
            date: workingTime.date     // Idem
        }
    })
    .then(response => {
        console.log('Réponse du serveur:', response.data);
    })
    .catch(error => {
        console.error('Erreur lors de la création de l\'utilisateur:', error);
        throw error;
    });
}


export async function getAllWorkingTimeByUser(id: string): Promise<WorkingTime | null> {
    const token = getToken(); // Récupérer le token JWT

    if (!token) {
        console.error('Aucun token disponible');
        return null;
    }
    return axios.get(`http://localhost:4000/api/workingtime/${id}`, {
        params: {
            start: '2010-01-01 23:00:00',
            end: '2026-01-01 23:00:00'
        },
        headers: {
            Authorization: `Bearer ${token}` // Ajouter le token dans l'en-tête
        }
    })
    .then(response => {
        console.log('Données reçues:', response.data);
        return response.data;
    })
    .catch(error => {
        console.error('Erreur lors de la récupération du temps de travail:', error);
        return null;
    });
}

export async function deleteWorkingTime(id: number): Promise<WorkingTime | number> {
    return axios.delete(`http://localhost:4000/api/workingtime/${id}`)
        .then(response => {
            console.log('Données reçues:', response.data);
            return response.data;
        })
        .catch(error => {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
            return null;
        });
}