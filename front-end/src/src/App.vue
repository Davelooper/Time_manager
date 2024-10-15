<script setup lang="ts">
import {RouterView } from 'vue-router'
import "./assets/base.css"
</script>

<template>
  <RouterView />
</template>

<style>

html, body, #app {
  height: 100%; /* S'assurer que tout prend la hauteur complète */
  padding: 0;
  margin: 0;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

#app {
  flex-grow: 1; /* L'application prend tout l'espace disponible verticalement */
}

main {
  flex-grow: 1; /* Le contenu dans main ou RouterView s'étend automatiquement */
  display: flex;
  flex-direction: column;
}
</style>
