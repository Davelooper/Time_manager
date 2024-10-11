/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'], // Mise à jour de purge vers content
  darkMode: 'media', // Tu peux utiliser 'media', ou supprimer cette ligne si tu n'as pas besoin du mode sombre
  theme: {
    extend: {},
  },
  plugins: [],
}
