<template>
	<Navbar />
	<div class="container h-lvh mt-5 mx-auto">
		<h1 class="text-4xl pt-10 md:pt-20 md:text-7xl font-bold text-center text-white uppercase">Gérer vos équipes<br/><span class="bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-700">comme un pro</span></h1>
		<TimeChart />

	<div class="mt-5">
  <!-- <PromoteUserComponent /> -->

</div>
	</div>
</template>
<script setup lang="ts">
	import Navbar from "../components/Navbar.vue"
  import PromoteUserComponent from "@/components/PromoteUserComponent.vue";
  import TimeChart from "../components/TimeChartComponent.vue"
</script>
<style lang="ts">
	
</style>