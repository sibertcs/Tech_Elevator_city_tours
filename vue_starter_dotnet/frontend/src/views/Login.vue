<template>
  <div id="login" class="text-center">
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
      <p class= "password-login">
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
      <button type="submit">Sign in</button>
      </p>
      </div>
    </form>
  </div>
</template>

<script>
import auth from "../auth";

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
            this.$router.push("/");
          }
        })
        .catch(err => console.error(err));
    }
  }
};
</script>

<style>
body {
  background: url("https://cdn.hipwallpaper.com/i/21/62/f2kHL9.jpg");
  background-repeat: no-repeat;
  background-attachment: fixed;
  
}
h1 {
  color: whitesmoke;
  display: flex;
  justify-content: center;
  border-top: solid whitesmoke;
  border-bottom: solid whitesmoke;
  padding-bottom:5px;
  padding-top:2px;
}

.sr-only {
  color:whitesmoke;
  display: grid;
  justify-items: center;
  
}
.password-login {
  display: grid;
  justify-items: center;
  
}
.username-login {
  display:grid;
  justify-items: center;
}
.login-box {
  border: solid white;
    border-radius: 5px;
    background-color: hsla(281, 40%, 43%, 0.4);
    margin-right: 40%;
    margin-left: 40%;
}

</style>
