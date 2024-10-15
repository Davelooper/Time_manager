<template>
  <RouterLink :to="to">
    <div
      class="flex flex-row px-4"
      :style="[computedStyles, roundedStyles]"
    >
      <p class="text-black text-lg" :style="textStyles">
        {{ text }}
      </p>
    </div>
  </RouterLink>
</template>

<script>
import { RouterLink } from 'vue-router';

export default {
  name: 'CustomButton',
  components: {
    RouterLink,
  },
  props: {
    text: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
    color: {
      type: String,
      default: '#959595',
    },
    textColor: {
      type: String,
      default: '#000000',
    },
    rounded: {
      type: Boolean,
      default: false,
    },
    to: {
      type: String,
      required: false,
    },
  },
  computed: {
    computedStyles() {
      return this.type === 'outlined'
        ? {
            borderWidth: '2px',
            borderColor: this.color,
            paddingTop: '6px',
            paddingBottom: '6px',
          }
        : {
            backgroundColor: this.color,
            paddingTop: '8px',
            paddingBottom: '8px',
          };
    },
    roundedStyles() {
      return this.rounded ? { borderRadius: '8px' } : {};
    },
    textStyles() {
      return { color: this.textColor };
    },
  },
};
</script>
