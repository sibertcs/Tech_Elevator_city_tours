<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Home</router-link>
    </div>
    <router-view/>
  </div>
</template>


<style>

#nav {
  font-family: 'Josefin Sans';
  color:whitesmoke;
}

a:link {
  color: whitesmoke;
  padding-top: 8px;
  padding-bottom: 5px;
  font-family: 'Josefin Sans';
}



</style>