<template>
<table class="table border-collapse border-r-2 border border-gray-200 shadow-md text-center">
  <thead class=" text-white bat-table">
    <tr>
      <th class="px-4 py-2 border-b">User Name</th>
      <th class="px-4 py-2 border-b">User Email</th>
      <th class="px-4 py-2 border-b">Action</th>
    </tr>
  </thead>
  <tbody>
    <tr class="odd:bg-gray-100 even:bg-gray-200">
      <td class="px-4 py-2 border-b">Batman</td>
      <td class="px-4 py-2 border-b">Batman@gotham.com</td>
      <td class="px-4 py-2 border-b">
        <button
          type="button"
          @click="promoteUser(1)"
          class="bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        >
          Promote BatUser
        </button>
      </td>
    </tr>
  </tbody>
</table>

</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import {getAllUser} from '../store/userStore'
function promoteUser(idUser: Number){

    console.log('User promoted')
}

async function fetchUser(){
 await getAllUser();

}

onMounted(() => {
  fetchUser()
});
</script>
<style>

.bat-table{
    background-color: #ffe177;
}
</style>