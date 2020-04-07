<template>
  <div id="app">
    <div id="nav">      
      <router-link to="/">Home</router-link>
    </div>
    <router-view/>
  </div>
</template>


<style scope src='./styles/main.css'>
@import './node_modules/bootstrap/scss/bootstrap';
@import './node_modules/bootstrap-vue/src/index.scss';


</style>