<template>

  <div id="app">
    <div id="nav">      
      <router-link to="/">Home</router-link>
      <router-link v-if="isLoggedIn() == false" to="/Login">Login</router-link>
    </div>
    <router-view/> 
    
  </div>

</template>


<style scope src='./styles/main.css'>



</style>

<script>
export default {
    data(){
      return {user: null};//this.$auth.user};
    },
    methods: {
        isLoggedIn(){
          return false;//this.user != null;
        }
    }
}
</script>