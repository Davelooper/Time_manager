<template>
  <div class="flex flex-col items-center justify-center">
    <!-- Background of the progress bar -->
    <div class="bg-gradient-to-br from-yellow-900 to-yellow-950 h-14 w-3 rounded-lg flex flex-col-reverse overflow-hidden shadow-inner">
      <!-- Filling part with glow effect -->
      <div 
        class="bg-gradient-to-br from-yellow-500 to-yellow-600  w-full rounded-lg transition-all duration-500 ease-in-out"
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
