<script setup lang="ts">
import Navbar from '@/components/Navbar.vue';

function deleteHour(idworkingTIme: number){

}
</script>

<template>
<Navbar />
<table class="table border-collapse border-r-2 border border-gray-200 shadow-md text-center batman-position">
  <thead class=" text-white bat-table">
    <tr>
      <th class="px-4 py-2 border-b">Date</th>
      <th class="px-4 py-2 border-b">Working hours</th>
      <th class="px-4 py-2 border-b">Action</th>
    </tr>
  </thead>
  <tbody>
    <tr class="odd:bg-gray-100 even:bg-gray-200">
      <td class="px-4 py-2 border-b">2024/08/11</td>
      <td class="px-4 py-2 border-b">8</td>
      <td class="px-4 py-2 border-b">
        <button
          type="button"
          @click="deleteHour(1)"
          class="bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        >
          Delete working hour
        </button>
      </td>
    </tr>
    
  </tbody>
</table>
</template>
<style>
.batman-position{
  position: relative;
  width: 40rem;
  margin: auto;
}
</style>