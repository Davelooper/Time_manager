import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  server: {
    host: true, // Permet au serveur d'écouter sur toutes les interfaces
    watch: {
      usePolling: true, // Utilise le polling pour détecter les changements de fichiers
    },
  },
})
