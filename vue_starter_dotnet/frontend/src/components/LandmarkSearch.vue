<template>
<div class="search-bar-div">
    <div class="landmark-search-wrapper">
        <div class="landmark-search-text-input-wrapper">
            <input class="form-control mr-sm-2 landmark-search-text-input" type="search" aria-label="Search" v-model="searchQuery" v-on:submit="search" @keyup.enter="search" minlength="1" placeholder="Search Popular Landmarks..." />
        </div>
        <div class="landmark-search-button-wrapper" v-on:click="search">
            <i class="fa fa-search landmark-fake-search-button fa-lg"></i>
        </div>
        <!-- <button class="btn aqua-gradient btn-rounded btn-sm my-0" type="submit">Search</button> -->        
    </div>


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
            this.$emit('search', this.searchQuery);
        },
        searchIfKeyIsEnter(){
                if (event.keyCode === 13) {
                    this.search();
                }
        }
    }
}
</script>
<style>
.landmark-search-wrapper{
    display: inline-grid;
    min-width: 300px;
    grid-template-areas: "text button";
    grid-template-columns: 8fr 1fr;
    grid-template-rows: 1fr;
    background-color: whitesmoke;
    border-radius: 5px;
  }

.landmark-search-text-input-wrapper{
    grid-area: text;
    width: 100%;
    height: 100%;
}

.landmark-search-button-wrapper{
    grid-area: button;
    text-align: center;
    vertical-align: middle;
    cursor: pointer;
}

  .landmark-search-text-input{
      min-width: 100px;
  }
  .landmark-fake-search-button{
    margin-top: 10px;
  }
</style>