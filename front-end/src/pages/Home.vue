<template>
	<Navbar />
	<div class="container h-lvh mt-5 mx-auto">
		<div class="flex flex-row items-center">
			<h1 class="text-4xl pt-10 md:pt-14 md:text-7xl font-bold text-white uppercase px-4 md:px-4">Gérer vos équipes<br/><span class="bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-700">comme un pro</span></h1>
			<img src="@/assets/calender.png" alt="hero" class="w-1/2 mx-auto mt-10 md:w-1/3 transition-all duration-300 " />
		</div>
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