<template>
  <div class="flex flex-col items-center justify-center relative group">
    <div is="tooltip"  class="bg-white text-black z-10 text-xs font-semibold p-2 rounded-lg shadow-lg absolute left-6 top-1/2 transform -translate-y-1/2 hidden group-hover:flex transition-opacity duration-300 opacity-0 group-hover:opacity-100">
      {{ value }}%
    </div>
    <div class="bg-gradient-to-br from-yellow-900 to-yellow-950 h-14 w-3 rounded-lg flex flex-col-reverse overflow-hidden shadow-inner group-hover:shadow-xl transition-all duration-300 ease-in-out">
      <div 
        class="bg-gradient-to-br from-yellow-500 to-yellow-600 w-full rounded-lg transition-all duration-500 ease-in-out"
        :style="{ height: value + '%' }">
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  value: {
    type: Number,
    required: true,
    default: 0,
  }
});
</script>
