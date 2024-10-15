import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createI18n } from 'vue-i18n'

const i18n = createI18n({
    locale: 'en',
    fallbackLocale: 'en',
    datetimeFormats: {
        en: {
            short: {
                year: 'numeric', month: '2-digit', day: '2-digit', 
            },
            long: {
                year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
            }
        },
        fr: {
            short: {
                year: 'numeric', month: 'short', day: 'numeric'
            },
            long: {
                year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
            }
        }
    }
});

const app = createApp(App)

app.use(router)
app.use(i18n)

app.mount('#app')
