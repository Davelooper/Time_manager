
<script>
import axios from 'axios'

const props = defineProps({
    user: {
        type:Object,
        required: true,
        validator(value) {
            return typeof value.id === 'number' &&
             typeof value.name === 'string' &&
             typeof value.email === 'string';
    }
    }
})


const apiClient = axios.create({
  baseURL: 'localhost:4000/api/users',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${process.env.VUE_APP_API_TOKEN}`
  }
})

</script>