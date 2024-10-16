/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_APP_TITLE: string;
  // Ajoutez d'autres variables d'environnement que vous utilisez
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
