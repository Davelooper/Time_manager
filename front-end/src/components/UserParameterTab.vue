<template>
  <div class="flex flex-row gap-4 pt-2">
    <Input type="text" :value="username" label="Username" placeholder="Your username" updatable />
    <Input type="text" :value="email" label="Email" placeholder="Your Email" />
  </div>
  <Input type="text" value="***********" label="Password" placeholder="Your Password" disabled/>
  <div class="flex flex-row gap-4">
    <Input type="select" :value="role" label="Role" disabled>
      <option value="admin">Admin</option>
      <option value="user">User</option>
    </Input>
    <Input type="select" :value="team_id" label="Team" disabled>
      <option value="valueee">Team 1</option>
      <option :value="team_id">Team 2</option>
    </Input>
  </div>
</template>
<script setup lang="ts">
import { getDecodedToken } from '@/store/userStore';
import Button from './Button.vue';
import Input from './Input.vue';

const decodedToken = getDecodedToken(); 
const { username, email, role, team_id } = decodedToken;
</script > 