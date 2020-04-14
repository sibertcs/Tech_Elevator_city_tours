<template>
  <div id="app">
    <navbar></navbar>
    <transition name="fade" mode="out-in">
    <router-view />
    </transition>    
  </div>
</template>


<style scope src='./styles/main.css'>
</style>

<script>
import auth from "./auth";
import Navbar from "@/components/Navbar.vue";

export default {
  name: "AppVue",
  data() {
    return { 
      user: auth.getUser(),
      lastSearchQuery: ""
       };
  },
  components: {
    Navbar
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