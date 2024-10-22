import axios from 'axios';
import {getDecodedToken} from './userStore'
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
export async function getclocksByUserId(id: number): Promise<Clocks | null> {
    return axios.get(`http://localhost:4000/api/clocks/${id}`)
        .then(response => {
            console.log('Données reçues:', response.data);
            return response.data;
        })
        .catch(error => {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
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