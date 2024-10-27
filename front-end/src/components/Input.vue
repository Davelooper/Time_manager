<template>
  <div class="w-full flex flex-col">
    <label v-if="label" :for="randomId" class="text-white text-lg font-medium select-none">{{ label }}</label>
    <div class="text-white flex flex-row gap-2 items-center w-full">
      <input
        v-if="type === 'text'"
        :id="randomId"
        type="text"
        v-model="value"
        :placeholder="placeholder"
        :disabled="disabled"
        @input="handleInput"
        class="p-2 my-2 border-2 text-amber-400 border-gray-300 rounded-lg focus:outline-none focus:outline-amber-400 flex-grow-[3] text-base md:text-xl"
      />
      <select
        v-else-if="type === 'select'"
        :id="randomId"
        v-model="value"
        :disabled="disabled"
        @change="handleInput"
        class="p-2 my-2 border-2 text-amber-400 border-gray-300 rounded-lg focus:outline-none focus:outline-amber-400 flex-grow-[3] text-base md:text-xl"
      >
        <slot></slot>
      </select>
      <Button
        v-if="(defaultValue !== value) && needToSave"
        :onClick="handleSave"
        text="Save"
        type="contained"
        rounded
        textColor="white"
        color="gold"
        :disabled="disabled"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import Button from './Button.vue';

const props = defineProps({
  value: {
    type: [String, Number, Boolean, Object, Array],
    required: true,
    default: 'Default value',
  },
  onClick: {
    type: Function,
    required: false,
    default: async () => {
      await new Promise((resolve) => setTimeout(resolve, 1000));
    },
  },
  onChange: {
    type: Function,
    required: false,
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
  type: {
    type: String,
    required: false,
    default: 'text',
  },
  disabled: {
    type: Boolean,
    required: false,
    default: false,
  },
  needToSave: {
    type: Boolean,
    required: false,
    default: true,
  }
});

const emit = defineEmits(['update:value']);
watch(
  () => props.value,
  (newVal) => {
    value.value = newVal;
    defaultValue.value = newVal;
  }
);
const value = ref(props.value);
const defaultValue = ref(props.value);
const randomId = Math.random().toString(36).substring(7);

const handleInput = () => {
  emit('update:value', value.value);
  if (props.onChange) {
    props.onChange(value.value);
  }
};

const handleSave = async () => {
  try {
    await props.onClick(value.value);
    defaultValue.value = value.value;
  } catch (error) {
    value.value = defaultValue.value;
    console.error('Erreur lors de la sauvegarde :', error);
  }
};
</script>
