<script setup lang="ts">
import router from '@/router';
import { ref, onMounted } from 'vue';
import Navbar from "../components/Navbar.vue"
import { getDecodedToken, getUserById,createAuth } from '@/store/userStore';


interface ManageUsers {
    id: number;
    username: string;
    email: string;
    password: string;
}

const manageUsers = ref<ManageUsers>({
  email: '', 
  username: '',
  id: 0,
  password: ''
});
const decodedToken = getDecodedToken(); 
const userId = decodedToken.id; 

async function fetchUser() {
  const decodedToken = getDecodedToken(); 
    const userId = decodedToken.id; 
    console.log(userId)
  const user = await getUserById(userId);
  try{
if (user) {
  manageUsers.value = user.data;

  console.log(manageUsers.value);
  console.log(manageUsers.value.email);
  console.log(manageUsers.value.username);

}
} catch (error) {
console.error("Error fetching user:", error);
}
}
const formDataCode = ref({code: ''})
async function createKey(): Promise<void> {
    try {
        const publicKey = {
            challenge: new Uint8Array(16),
            rp: {
                name: 'Your Website Name'
            },
            user: {
                id: new Uint8Array(16), // User ID, should be unique and provided from your server
                name: "User's Name",
                displayName: "User's Display Name"
            },
            pubKeyCredParams: [
                {
                    type: 'public-key',
                    alg: -7 // Algorithm, typically ES256
                }
            ],
            timeout: 60000, // Timeout for user action
            attestation: 'direct',
            authenticatorSelection: {
                userVerification: 'preferred', // Try to get user verification if available
                requireResidentKey: false
            }
        }

        const credential = await navigator.credentials.create({ publicKey })

        if (credential) {
            const credentialData = {
                id: credential.id,
                rawId: Array.from(new Uint8Array(credential.id)),
                response: {
                    attestationObject: Array.from(new Uint8Array((credential as PublicKeyCredential).response.attestationObject)),
                    clientDataJSON: Array.from(new Uint8Array((credential as PublicKeyCredential).response.clientDataJSON))
                },
                type: credential.type
            }
            try {
                formDataCode.value.code = credentialData.id
                console.log(credential.id)
                const response = await createAuth(formDataCode.value,userId)
            } catch (error) {
                console.error('Error sending biometric data:', error)
            }
        }

        console.log('Credential:', credential)
    } catch (err) {
        console.error('Error during biometric authentication:', err)
    }
}

onMounted(() => {
  fetchUser();
});

</script>

<template>
  	<Navbar />
<div class="container mx-auto p-6 max-w-md form-batman">
  <button
            type="button"
            class="bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
            @click="createKey()"
          >
          Register KEY PASS
        </button>
      <img class="w-40 mx-auto" src="../assets/img/batman-character.png" alt="batman">

      <form  @submit.prevent="" class="shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <h2 class="text-1xl font-extrabold leading-none tracking-tight text-gray-900 md:text-3xl lg:text-3xl dark:text-white">Gotham City User: </h2>
        <div class="mb-4">
          <label for="name" class="block text-gray-700 text-sm font-bold mb-2">Name :</label>
          <input
            type="text"
            id="name"
            v-model="manageUsers.username"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"          
            />
        </div>
  
        <div class="mb-4">
          <label for="email" class="block text-gray-700 text-sm font-bold mb-2">Email :</label>
          <input
            type="email"
            id="email"
            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            v-model="manageUsers.email"
          />
        </div>
  
        <div class="flex items-center justify-between">
          <button
            type="submit"
            class="bg-stone-800 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          >
          Change BatUser
        </button>
        </div>
      </form>
      </div>
</template>
