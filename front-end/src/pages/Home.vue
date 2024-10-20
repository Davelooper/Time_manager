<template>
	<Navbar />
	<div class="container h-lvh mt-5 mx-auto">
<TimeChart />

<div class="mt-5">
  <PromoteUserComponent />

</div>
	</div>
</template>
<script setup lang="ts">
	import Navbar from "../components/Navbar.vue"
  import PromoteUserComponent from "@/components/PromoteUserComponent.vue";
  import TimeChart from "../components/TimeChartComponent.vue"
</script>
<style>
</style>