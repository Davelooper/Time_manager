
<template>
  <RouterLink :to="to" class="">
  <div class="flex flex-row px-4" :style="[
    type == 'outlined' ?{ 'border-width': '2px', 'border-color': color,'padding-top':'6px','padding-bottom':'6px'}  : {'background-color':color,'padding-top':'8px','padding-bottom':'8px'},
    rounded ? {'border-radius':'8px'}:''
    ]">
    <p class="text-black text-lg" :style="[
      textColor && {'color':textColor}
    ]"> 
      {{text}}
    </p>
     
  </div>
  </RouterLink>
</template>
<script>
export default {
  props: {
    text:{
      type:String,
      required:true
    },
    type:{
      type:String,
      required:true
    },
    color:{
      type:String,
      required:true,
      default:"#959595"
    },
    textColor:{
      type:String,
      required:false,
      default:"#000000"
    },
    rounded:{
      type:Boolean,
      required:false,
      default:false
    },
    to:{
      type:String,
      required:false,
    }
  }
}
</script>
<style lang="ts">

</style>