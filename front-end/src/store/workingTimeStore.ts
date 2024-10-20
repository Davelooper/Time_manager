import axios from 'axios';
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


export function updateWorkingTime(WorkingTime: WorkingTime, iduser: number): void {
    axios.put(`http://localhost:4000/api/workingtime/${iduser}`, WorkingTime)
        .then(response => {
            (response.data);
        })
        .catch(error => {
            console.error('Erreur lors de la création du WorkingTime:', error);
            (null);
        });
}
export async function getAllWorkingTimeByUser(id: number): Promise<WorkingTime | null> {
    return axios.get(`http://localhost:4000/api/workingtime/${id}`)
        .then(response => {
            console.log('Données reçues:', response.data);
            return response.data;
        })
        .catch(error => {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
            return null;
        });
}
export async function getOneWorkingTime(idUser: number, idWorkingTime: number): Promise<WorkingTime | null> {
    return axios.get(`http://localhost:4000/api/workingtime/${idUser}/${idWorkingTime} `)
        .then(response => {
            console.log('Données reçues:', response.data);
            return response.data;
        })
        .catch(error => {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
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