import axios from 'axios';
import {getToken} from './userStore'
const token = getToken(); // Récupérer le token JWT

if (!token) {
    console.error('Aucun token disponible');
}
export interface Clocks {
    id: number;
    time: string;
}

export function createClocks(clocks: Clocks, iduser: string): void {
    axios
      .post(`http://localhost:4000/api/clocks/${iduser}`, {
        clock: {
          time: clocks.time,
        },
      })
      .then((response) => {
        console.log("Réponse du serveur:", response.data);
      })
      .catch((error) => {
        console.error("Erreur lors de la création du clocks:", error);
      });
  }

export function updateClocks(clocks: Clocks, iduser: number): void {
    axios.put(`http://localhost:4000/api/clocks/${iduser}`, clocks)
        .then(response => {
            (response.data);
        })
        .catch(error => {
            console.error('Erreur lors de la création du clocks:', error);
            (null);
        });
}
export async function getClocksByUserId(iduser: string): Promise<Clocks | null> {


    return axios.get(`http://localhost:4000/api/clocks/${iduser}`, {
        headers: {
            Authorization: `Bearer ${token}` // Ajouter le token dans l'en-tête
        }
    })
    .then(response => {
        console.log('Données reçues:', response.data);
        return response.data;
    })
    .catch(error => {
        console.error('Erreur lors de la récupération des clocks:', error);
        return null;
    });
}
export async function deleteclocks(id: number): Promise<Clocks | number> {
    return axios.delete(`http://localhost:4000/api/clocks/${id}`)
        .then(response => {
            console.log('Données reçues:', response.data);
            return response.data;
        })
        .catch(error => {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
            return null;
        });
}