import axios from 'axios';
import {getToken} from './userStore'
const token = getToken(); // Récupérer le token JWT

interface WorkingTime {
    date:string
    start: string;
    end: string
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


export async function getAllWorkingTimeByUser(id: string): Promise<WorkingTime[] | null> {
    try {
        const response = await axios.get(`http://localhost:4000/api/workingtime/${id}`, {
            params: {
                start: '2010-01-01T23:00:00Z',
                end: '2026-01-01T23:00:00Z'
            },
            headers: {
                Authorization: `Bearer ${token}` // Ajoute le token dans l'en-tête
            }
        });
        
        console.log('Données reçues:', response.data);
        return response.data;
    } catch (error) {
        console.error('Erreur lors de la récupération du temps de travail:', error);
        return null;
    }
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