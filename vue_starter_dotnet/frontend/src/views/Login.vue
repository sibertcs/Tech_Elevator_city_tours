<template>


  <div id="login" class="card">
    <form class="form-signin" @submit.prevent="login">
      <h1 class="h3 mb-3 font-weight-normal">Please Sign In</h1>
      <div
        class="alert alert-danger"
        role="alert"
        v-if="invalidCredentials"
      >Invalid username and password!</div>
      <div
        class="alert alert-success"
        role="alert"
        v-if="this.$route.query.registration"
      >Thank you for registering, please sign in.</div>
      <div id="login-wrapper"  style="background:rgba(59, 61, 64, 0)">
      <div class="login-box">
        <p class="username-login">
          <label for="username" class="sr-only">Username</label>
          <input
            type="text"
            id="username"
            class="form-control"
            placeholder="Username"
            v-model="user.username"
            required
            autofocus
          />
        </p>
        <p class="password-login">
          <label for="password" class="sr-only">Password</label>
          <input
            type="password"
            id="password"
            class="form-control"
            placeholder="Password"
            v-model="user.password"
            required
          />
          <router-link :to="{ name: 'register' }">Need an account?</router-link>
          <button class="btn btn-lg btn-primary btn-block btn-secondary"  type="submit">Sign in</button>
        </p>
      </div>

      </div>
    </form>
  </div>

</template>

<script>
import auth from "../auth";
import AppVue from '../App.vue';

export default {
  name: "login",
  components: {},
  data() {
    return {
      user: {
        username: "",
        password: ""
      },
      invalidCredentials: false
    };
  },
  methods: {
    login() {
      fetch(`${process.env.VUE_APP_REMOTE_API}/login`, {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json"
        },
        body: JSON.stringify(this.user)
      })
        .then(response => {
          if (response.ok) {
            return response.text();
          } else {
            this.invalidCredentials = true;
          }
        })
        .then(token => {
          if (token != undefined) {
            if (token.includes('"')) {
              token = token.replace(/"/g, "");
            }
            auth.saveToken(token);
            this.$emit("update", []);
            AppVue.user = auth.getUser();
            //alert(JSON.stringify(AppVue.user));
            //this.$router.
            this.$router.push("/");
            
          }
        })
        .catch(err => console.error(err));
    }
  }
};
</script>

<style>
@import url("https://fonts.googleapis.com/css?family=Josefin+Sans");



</style>
