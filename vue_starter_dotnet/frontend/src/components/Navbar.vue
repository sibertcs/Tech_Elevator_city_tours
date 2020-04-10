<template>
  <div id="navbar">
      <router-link id="home" to="/">Home</router-link>
      <router-link v-on:update="location.reload();" v-if="isLoggedIn() == false" to="/Login">Login</router-link>
      <a href="#" @click.prevent="logout" v-if="isLoggedIn() == true">Log Out</a>
      <router-link id="manage-itinerary" to="/ManageItinerary">Create Itinerary</router-link>
    </div>
</template>

<script>
import auth from "../auth";
export default {
  //name: "navbar",
  data() {
    return { user: auth.getUser() };
  },
  methods: {
    isLoggedIn() {
      return this.user != null;
    },
    getUser() {
      alert(JSON.stringify(this.user));
    },
    logout() {
      alert(JSON.stringify(arguments));
      if (this.isLoggedIn()) {
        alert("logging out");
        this.$nextTick(function() {
          auth.logout();
          this.updateUser();
          //auth.destroyToken();
        });        
        //document.getElementById("home").click();
        //this.$router.push(0);
      }
    },
    updateUser(){
      //alert('update user called');
      this.$nextTick(function() {
        this.user = auth.getUser();        
      });
      
    }
  }
};
</script>

<style>

</style>