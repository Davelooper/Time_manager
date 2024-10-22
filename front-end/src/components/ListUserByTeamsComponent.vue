<template>
   <table class="table-auto">
  <thead>
    <tr>
      <th>Name</th>
      <th>email</th>
      <th>action</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>
</template>

<script>
import { onBeforeMount, onMounted } from 'vue';
import {getAllTeams} from '../store/userStore'

console.log("test")
onBeforeMount(async () => { 
  try {
    let getTeam = await getAllTeams(); 
    console.log(getTeam, "GET TEAMS");
  } catch (error) {
    console.error("Erreur lors de la récupération de l'équipe :", error);
  }
});
console.log("test2")

</script>