<template>
    <div id="landmark-search-wrapper">
        <input type="search" id="landmark-search-bar" v-model="searchQuery" v-on:submit="search" minlength="1" placeholder="search for a landmark..." />
        <i id="fake-search-button" class="fa fa-search" v-on:click="search"></i>
    </div>
</template>

<script>
export default {
    name: 'LandmarkSearch',
    data(){
        return{
            searchQuery: ''
        }        
    },
    methods: {
        search(){            
            alert(this.searchQuery);
            this.$emit('search',searchQuery);
        }
    }
}
</script>
<style>
#landmark-search-wrapper{
    display: inline-block;
    background-color: whitesmoke;
    border-radius: 5px;
  }
  #landmark-search-bar{
      min-width: 100px;
  }
  #fake-search-button{
      cursor: pointer;
  }
</style>