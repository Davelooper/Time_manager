import { createI18n } from 'vue-i18n';

// Définir les traductions pour les langues
const messages = {
  en: {
    message: {
      hello: 'Hello world'
    }
  },
};

// Configurer les formats de date pour différentes langues
export const datetimeFormats = {
  en: {
    short: {
      year: 'numeric', month: '2-digit', day: '2-digit' 
    },
    long: {
      year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
    },
    custom: {
      year: 'numeric', month: '2-digit', day: '2-digit' // Format YYYY/mm/dd
    }
  },
};

// Créer l'instance de i18n
const i18n = createI18n({
  locale: 'en', // Langue par défaut
  messages, // Traductions pour les langues
});

export default i18n;
