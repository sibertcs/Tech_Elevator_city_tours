<template>
    <div>

    </div>
</template>

<script>
export default {
  data() {
    return {
      searchQuery: String,
      landmarkResults: []
    };
  },
  loadLandmarkResults() {
    console.log("Load Landmarks...");
    fetch(`${process.env.VUE_APP_REMOTE_API}/api/landmarks/${searchQuery}`)
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          // no reason to be here send them back to the list view
          this.$router.push({ path: "/" });
        }
      })
      .then(data => {
        this.landmarkResults = data;
      })
      .catch(err => console.error(err));
  }
};
</script>

<style>
</style>