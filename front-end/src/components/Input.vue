<template>
  <div class="w-full flex flex-col">
    <label v-if="label" :for="randomId" class="text-white text-lg font-medium select-none">{{ label }}</label>
    <div class="text-white flex flex-row gap-2 items-center w-full">
      
      <input :id="randomId" type="text" v-model="value" onchange="" :placeholder="placeholder" class="p-2 my-2 border-2 text-amber-400 border-gray-300 rounded-lg focus:outline-none focus:outline-amber-400 flex-grow-[3] text-base md:text-xl" >
      <Button v-if="defaultValue !== value" :onClick="handleSave" text="Save" type="contained" rounded textColor="white" color="gold" />
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref } from 'vue';
import Button from './Button.vue';


const props = defineProps({
  value: {
    type: [String , Number , Boolean , Object , Array],
    required: true,
    default: 'Default value',
  },
  onClick: {
    type: Function,
    required: false,
    default: async () => { await new Promise((resolve) => setTimeout(resolve, 1000)); },
  },
  placeholder: {
    type: String,
    required: false,
    default: 'Default placeholder',
  },
  label: {
    type: String,
    required: false,
  },
  updatable: {
    type: Boolean,
    required: false,
    default: false,
  }
});
const handleSave = async () => {
  try {
    await props.onClick();
    // Si l'appel réussit, vous pouvez mettre à jour `defaultValue`
    defaultValue.value = value.value;
  } catch (error) {
    // Si une erreur survient, réinitialiser `username` à `defaultValue`
    value.value = defaultValue.value;
    console.error('Erreur lors de la sauvegarde :', error);
  }
};

const value = ref(props.value);
const defaultValue = ref(props.value);
const randomId = Math.random().toString(36).substring(7);
</script>