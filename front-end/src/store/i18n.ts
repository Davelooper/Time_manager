import { createI18n } from 'vue-i18n';

// Définir les traductions pour les langues
const messages = {
  en: {
    message: {
      hello: 'Hello world'
    }
  },
  fr: {
    message: {
      hello: 'Bonjour le monde'
    }
  }
};

// Configurer les formats de date pour différentes langues
export const datetimeFormats = {
  en: {
    short: {
      year: 'numeric', month: '2-digit', day: '2-digit' // Format personnalisé YYYY/mm/dd
    },
    long: {
      year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
    },
    custom: {
      year: 'numeric', month: '2-digit', day: '2-digit' // Format YYYY/mm/dd
    }
  },
  fr: {
    short: {
      year: 'numeric', month: '2-digit', day: '2-digit' // Format personnalisé YYYY/mm/dd en français
    },
    long: {
      year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
    },
    custom: {
      year: 'numeric', month: '2-digit', day: '2-digit' // Format YYYY/mm/dd en français
    }
  }
};

// Créer l'instance de i18n
const i18n = createI18n({
  locale: 'en', // Langue par défaut
  fallbackLocale: 'fr', // Langue de repli en cas d'absence de traduction
  messages, // Traductions pour les langues
});

export default i18n;
