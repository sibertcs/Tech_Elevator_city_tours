<template>
  <div class="landmark-details card" v-if="selectedLandmark != null">
    <h1>{{selectedLandmark.name}}</h1>
    <img v-bind:src="selectedLandmark.images[0].url" />
    <div style="font-size: 10px;">
      <span>{{selectedLandmark.images[0].description}} (Photo Credits: {{selectedLandmark.images[0].credits}})</span>
    </div>
    <div>
      <span>DESCRIPTION:</span>
      {{selectedLandmark.description}}
    </div>
    <div>
      <span>DAYS OPEN:</span>
      {{selectedLandmark.daysOpen}}
    </div>
    <div>
      <span>HOURS OF OPERATION:</span>
      {{selectedLandmark.hoursOfOperation}}
    </div>
    <div>
      <span>LANDMARK TYPE:</span>
      {{selectedLandmark.category}}
    </div>
    <div>
      <span>Address: {{selectedLandmark.streetAddress}} {{selectedLandmark.city}}, {{selectedLandmark.state}} {{selectedLandmark.zipCode}}</span>
    </div>
    <div class="containing-feedback" v-if="selectedLandmark.ratings.length == 5">
      <vue-feedback-reaction
        id="feedback"
        v-model="feedback"
        v-on:input="rateLandmark"
        v-bind:labels="getLandmarkRatings()"
      />
    </div>  
    <div v-if="isLoggedIn">
      <select
        class="btn btn-lg btn-primary btn-block btn-secondary dropdown-toggle"
        id="itineraryDropDown"
        v-on:change="onSelectChange"
        v-if="userItineraries.length > 0"
      >
        <option
          v-for="itineraryOption in userItineraries"
          v-bind:key="'dropdown' + itineraryOption.itineraryID"
          v-bind:value="itineraryOption.itineraryID"
          v-text="itineraryOption.name"
          
        ></option>
      </select>
      <button
        class="btn btn-lg btn-primary btn-block btn-secondary"
        v-on:click="addToItinerary"
      >ADD TO ITINERARY</button>
    </div>
    <div>
      <button
        id="go-back-button"
        class="btn btn-lg btn-primary btn-block btn-secondary"
        v-on:click="goBack"
      >GO BACK</button>
    </div>
  </div>
</template>

<script>
//import data from ''
import auth from "../auth";
import { VueFeedbackReaction } from "vue-feedback-reaction";
export default {
  name: "landmark-details",

  data() {
    return {
      // allLandmarks: data,
      selectedLandmark: null,
      userItineraries: [],
      selectedItinerary: Object,
      isLoggedIn: false,
      feedback: "",
      usersRating: Object
    };
  },
  components: {
    VueFeedbackReaction
  },
  props: {
    // id: Number,
    // labels: []
  },
  methods: {
    goBack() {
      this.$router.go(-1);
    },
    addToItinerary() {
      //alert("to be implemented" + id.toString());
      // router push path /manageitinerary?landmarkId=? + id
      if (this.selectedItinerary != null) {
        this.setSelectedItinerary(this.selectedItinerary);
      }
      this.$router.push({
        path: "/ManageItinerary/" + this.selectedLandmark.id.toString()
      });
    },
    getUserItineraries() {
      if (auth.getUser() != null) {
        this.isLoggedIn = true;
        const userID = auth.getUser().id;
        const apiEndpoint = `getusersitineraries/${userID}`;
        fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + auth.getUser()
          }
        })
          .then(response => {
            if (response.ok) {
              return response.json();
            }
          })
          .then(data => {
            //alert(data);
            this.userItineraries = data;
            if (this.userItineraries.length > 0) {
              this.selectedItinerary = this.userItineraries[0];
            }
            //alert(this.userItineraries);
          });
      }
    },
    getUsersRating() {
      if (auth.getUser() != null) {
        this.isLoggedIn = true;        
        const userID = auth.getUser().id;
        let getRatingBody = {
          UserID: userID,
          LandmarkID: this.selectedLandmark.id
        };
        const apiEndpoint = `GetUserLandmarkRatings/`;
        fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + auth.getUser()
          },
          body: JSON.stringify(getRatingBody)
        })
          .then(response => {
            if (response.ok) {
              return response.json();
            }
          })
          .then(data => {
            //alert(data);
            if (data.ratingType != 0) {
              this.usersRating = data;
              this.feedback = this.usersRating.ratingName;
              //this.VueFeedbackReaction.props.value = this.feedback;
              //document.getElementsByClassName("vue-reaction")[(this.usersRating - 1)].click();
            }
            //alert(this.userItineraries);
          });
      }
    },
    onSelectChange() {
      //alert(JSON.stringify(this.selectedItinerary));
      this.selectedItinerary = this.userItineraries.find(itinerary => {
        return (
          itinerary.itineraryID ==
          document.getElementById("itineraryDropDown").value
        );
      });
      this.setSelectedItinerary();
      this.getUserItineraries();
      //alert(JSON.stringify(this.selectedItinerary));
    },
    setSelectedItinerary() {
      const apiEndpoint = `setselecteditinerary`;
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getToken()
        },
        body: JSON.stringify(this.selectedItinerary)
      })
        .then(response => {
          if (response.ok) {
            //this.$router.go(0);
          }
        })
        .catch(err => console.error(err));
    },
    rateLandmark() {
      const apiEndpoint = `ratelandmark`;
      if(auth.getUser() == null){
          this.$router.push({path: "/login"});
      }
      const userID = auth.getUser().id;
      let submitRatingBody = {
        landmarkId: this.selectedLandmark.id,
        userID: userID,
        ratingType: this.feedback * 1
      };
      console.log(JSON.stringify(submitRatingBody));
      fetch(`${process.env.VUE_APP_REMOTE_API_LANDMARKS}/${apiEndpoint}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + auth.getToken()
        },
        body: JSON.stringify(submitRatingBody)
      })
        .then(response => {
          if (response.ok) {
            //this.$router.go(0);
            this.getLandmarkData();
            this.getLandmarkRatings();
          }
        })
        .catch(err => console.error(err));
    },
    getLandmarkRatings() {
      let ratings = [];
      // for (let i = 1; i <= 5; i++) {
      //   if (this.selectedLandmark.ratings[i - 1] != null) {
      //     //console.log(this.selectedLandmark.ratings[i - 1]);
      //     ratings.push(
      //       // "ratingType": this.selectedLandmark.ratings[i - 1].ratingType,
      //       // "ratingName": this.selectedLandmark.ratings[i - 1].ratingName,
      //       //"ratingCount":
      //       this.selectedLandmark.ratings[i - 1].ratingCount
      //     );
      //   } else {
      //     ratings.push("0");
      //   }
      // }

      // this.$components.$VueFeedbackReaction.props.labels = [ratings[0].ratingCount,
      //         ratings[1].ratingCount,
      //         ratings[2].ratingCount,
      //         ratings[3].ratingCount,
      //         ratings[4].ratingCount];

      for(let i = 0; i < this.selectedLandmark.ratings.length; i++){
        ratings.push(this.selectedLandmark.ratings[i].ratingCount.toString());
      }


      return ratings;
    },
    getLandmarkData() {
      fetch(
        `${process.env.VUE_APP_REMOTE_API_LANDMARKS}/getlandmark/${this.$route.params.id}`
      )
        .then(response => {
          if (response.ok) {
            return response.json();
          }
        })
        .then(data => {
          this.selectedLandmark = data;
          for (let i = 1; i <= 5; i++) {
            if (
              this.selectedLandmark.ratings.find(rating => {
                return rating.ratingType == i;
              }) == null
            ) {
              this.selectedLandmark.ratings.push({
                ratingType: i,
                ratingName: i.toString(),
                ratingCount: 0
              });
            }
          }
          this.selectedLandmark.ratings = this.selectedLandmark.ratings.sort(function(a, b){return a.ratingType-b.ratingType});
          this.getUserItineraries();
          this.getUsersRating();
          //this.getLandmarkRatings();
        })
        .catch(err => console.error(err));
    }
  },
  created() {
    this.getLandmarkData();
  }

  //this.landmark = this.allLandmarks.find(l => l.id == this.$route.params.id)
};
</script>

<style>
</style>