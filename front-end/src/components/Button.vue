<template>
  <div >
    <!-- Si c'est un bouton de soumission (submit) -->
    <button
      v-if="isSubmit && !isLoading"
      type="submit"
      class="flex flex-row items-center px-4 transition-transform duration-300 ease-in-out"
      :style="[computedStyles, roundedStyles]"
      @mouseover="hover = true"
      @mouseleave="hover = false"
      :disabled="isLoading"
    >
      <p
        class="text-black text-lg whitespace-nowrap"
        :style="textStyles"
      >
        {{ text }}
      </p>
    </button>

    <!-- Si c'est un RouterLink -->
    <RouterLink v-else-if="to && !isLoading" :to="to">
      <div
        class="flex flex-row items-center px-4 transition-transform duration-300 ease-in-out cursor-pointer"
        :style="[computedStyles, roundedStyles]"
        @mouseover="hover = true"
        @mouseleave="hover = false"
        :class="{'cursor-not-allowed': isLoading}" 
      >
        <!-- Texte du bouton -->
        <p
          class="text-black text-lg whitespace-nowrap"
          :style="textStyles"
        >
          {{ text }}
        </p>
      </div>
    </RouterLink>

    <!-- Si c'est un bouton avec une action async -->
    <div
      v-else
      class="flex flex-row items-center px-4 transition-transform duration-300 ease-in-out cursor-pointer"
      :style="[computedStyles, roundedStyles]"
      @mouseover="hover = true"
      @mouseleave="hover = false"
      @click="handleClick"
      :class="{'cursor-not-allowed': isLoading}"
    >
      <!-- Spinner qui s'affiche pendant le chargement -->
      <svg
        v-if="isLoading"
        class="animate-spin h-5 w-5 text-white"
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
      >
        <circle
          class="opacity-25"
          cx="12"
          cy="12"
          r="10"
          stroke="currentColor"
          stroke-width="4"
        ></circle>
        <path
          class="opacity-75"
          fill="currentColor"
          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
        ></path>
      </svg>

      <!-- Texte du bouton -->
      <p
        v-if="!isLoading"
        class="text-black text-lg whitespace-nowrap"
        :style="textStyles"
      >
        {{ text }}
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: "CustomButton",
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
      default: "#959595",
    },
    textColor: {
      type: String,
      default: "#000000",
    },
    rounded: {
      type: Boolean,
      default: false,
    },
    to: {
      type: String,
      required: false,
    },
    onClick: {
      type: Function,
      required: false,
    },
    isSubmit: {
      type: Boolean,
      default: false, // Indique si c'est un bouton de soumission
    },
  },
  data() {
    return {
      hover: false,
      isLoading: false, // État pour gérer le spinner
    };
  },
  computed: {
    computedStyles() {
      const baseStyles =
        this.type === "outlined"
          ? {
              borderWidth: "2px",
              borderColor: this.color,
              paddingTop: "6px",
              paddingBottom: "6px",
            }
          : {
              backgroundColor: this.color,
              paddingTop: "8px",
              paddingBottom: "8px",
            };

      const hoverStyles = this.hover
        ? {
            filter: "brightness(85%)", // Appliquer un assombrissement au survol
          }
        : {};

      return { ...baseStyles, ...hoverStyles };
    },
    roundedStyles() {
      return this.rounded ? { borderRadius: "8px" } : {};
    },
    textStyles() {
      return { color: this.textColor };
    },
  },
  methods: {
    async handleClick() {
      // Ne pas relancer l'action si elle est déjà en cours
      if (this.isLoading) return;

      // Si une action async est définie
      if (this.onClick) {
        this.isLoading = true; // Activer le spinner
        try {
          await this.onClick(); // Exécuter l'action asynchrone
        } catch (error) {
          console.error("Erreur pendant l'action async : ", error);
        } finally {
          this.isLoading = false; // Désactiver le spinner après l'action
        }
      }
    },
  },
};
</script>

<style scoped>
.cursor-not-allowed {
  cursor: not-allowed;
}
</style>
