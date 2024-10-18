<template>
  <div class="bg-gradient-to-br from-amber-300 to-amber-500 rounded-lg shadow-lg shadow-amber-500/50 p-6 min-w-[14rem] max-w-xs transform transition-transform hover:scale-105">
  <!-- Titre avec soulignement noir sur toute la largeur -->
  <h3 class="text-slate-800 uppercase font-bold text-xl relative mb-4">
    <span class="inline-block">
      {{ title }}
    </span>
  </h3>
  <!-- Texte de la card -->
  <p class="text-white leading-relaxed">
    {{text}}
  </p>
</div>
</template>

<script setup lang="ts">
const props = defineProps({
  title : {
    type: String,
    required: true,
    default: "Default Title",
  },
  text : {
    type: String,
    required: true,
    default: "Default Text",
  }
});
</script>