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
import { getAllUserByTeam } from '@/store/userStore';
import { onBeforeMount, onMounted } from 'vue';

let idTeam = 1
console.log("test")
onBeforeMount(async () => { 
  try {
    let getTeam = await getAllUserByTeam(idTeam); 
    console.log(getTeam, "GET TEAMS");
  } catch (error) {
    console.error("Erreur lors de la récupération de l'équipe :", error);
  }
});
console.log("test2")

</script>