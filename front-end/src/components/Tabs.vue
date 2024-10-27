<template>
  <div>
    <div class="flex flex-row gap-2 text-white font-medium text-2xl">
      <button
        v-for="(tab, index) in tabs"
        :key="index"
        @click="activeTab = index"
        class="border-b-2 border-amber-300 leading-5 px-4 py-2"
        :class="{ 'border-amber-500 border-b-4': activeTab === index }"
      >
        {{ tab.title }}
      </button>
    </div>
    <div class="tab-content">
      <component :is="tabs[activeTab].component" v-bind="tabs[activeTab].props"></component>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    tabs: Array,
  },
  data() {
    return {
      activeTab: 0,
    };
  },
};
</script>
