<template>
  <div id="register" class="card">
    <b-form @submit.prevent="register">
      <h1 class="h3 mb-3 font-weight-normal">Create An Account</h1>
      <div
        class="alert alert-danger"
        role="alert"
        v-if="registrationErrors"
      >There were problems registering this user.</div>
      <b-form-group>
        <label for="username" class="sr-only">Username</label>
        <b-input
          type="text"
          id="username"
          class="mb-2 mr-sm-2 mb-sm-0"
          placeholder="Username"
          v-model="user.username"
          required
          autofocus
        />
      </b-form-group>
      <b-form-group>
        <label for="password" class="sr-only">Password</label>
        <b-input
          type="password"
          id="password"
          class="mb-2 mr-sm-2 mb-sm-0"
          placeholder="Password"
          v-model="user.password"
          required
        />
      </b-form-group>
      <b-form-group style="margin-bottom:0px">
        <b-input
          type="password"
          id="confirmPassword"
          class="mb-2 mr-sm-2 mb-sm-0"
          placeholder="Confirm Password"
          v-model="user.confirmPassword"
          required
        />
      </b-form-group>

      <p class="password-login" style="margin-bottom:0px">
        <router-link :to="{ name: 'login' }">Have an account?</router-link>
      </p>
      <b-button class="btn btn-lg btn-primary btn-block" type="submit">Create Account</b-button>
    </b-form>
  </div>
</template>

<script>
export default {
  name: "register",
  data() {
    return {
      user: {
        username: "",
        password: "",
        confirmPassword: "",
        role: "user"
      },
      registrationErrors: false
    };
  },
  methods: {
    register() {
      if (this.ValidateFields()) {
        fetch(`${process.env.VUE_APP_REMOTE_API}/register`, {
          method: "POST",
          headers: {
            Accept: "application/json",
            "Content-Type": "application/json"
          },
          body: JSON.stringify(this.user)
        })
          .then(response => {
            if (response.ok) {
              this.$router.push({
                path: "/login",
                query: { registration: "success" }
              });
            } else {
              this.registrationErrors = true;
              
            }
          })

          .then(err => console.error(err));
      } else {
        this.registrationErrors = true;
        this.resetForm();
      }
    },
    ValidateFields() {
      let isValid = true;

      if (this.user.username.length < 4) {
        isValid = false;
      }

      if (this.user.password.length < 8) {
        isValid = false;
      }

      if (this.user.password != this.user.confirmPassword) {
        isValid = false;
      }

      return isValid;
    },
    resetForm() {
        console.log('Reseting the form');        
        document.getElementById("password").value = "";
        document.getElementById("confirmPassword").value = "";
        this.user.password = "";
        this.user.confirmPassword = "";
      }
  }
};
</script>

<style>
</style>
