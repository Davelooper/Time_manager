<template>
	<Navbar />
	<div class="container h-lvh mt-5 mx-auto">
		<div class="flex flex-row items-center mb-5">
			<h1 class="text-4xl pt-10 md:pt-14 md:text-7xl font-bold text-white uppercase px-4 md:px-4">Manage your team<br/><span class="bg-gradient-to-br font-bold bg-clip-text text-transparent from-yellow-300 to-yellow-700">like a pro</span></h1>
			<img src="@/assets/calender.png" alt="hero" class="w-1/2 mx-auto hover:scale-110 mt-10 md:w-1/3 transition-all duration-300 " />
		</div>
		<!-- <PromoteUserComponent /> -->
		
	<div class="flex flex-row justify-between">
		<SpecCard title="Easy to use" text="Manage teams of workers in one space, in one click" />
		<SpecCard title="Time tracking" text="Track the time spent on each project and task" />
		<SpecCard title="Statistics" text="Analyze the time spent on each project and task" />
	</div>


	</div>
</template>
<script setup lang="ts">
	import Navbar from "../components/Navbar.vue"
  import PromoteUserComponent from "@/components/PromoteUserComponent.vue";
  // import TimeChart from "../components/TimeChartComponent.vue"
import SpecCard from "@/components/SpecCard.vue";
</script>
<style lang="ts">
	
</style>