<script setup lang="ts">
import ProgressBar from './ProgressBar.vue';
</script>

<template>
  <div class="flex flex-row gap-2">
   <ProgressBar :value="10"/>
    <ProgressBar :value="40"/>
    <ProgressBar :value="20"/>
    <ProgressBar :value="70"/>
    <ProgressBar :value="95"/>
    <ProgressBar :value="70"/>
    <ProgressBar :value="95"/>
  </div>
</template>