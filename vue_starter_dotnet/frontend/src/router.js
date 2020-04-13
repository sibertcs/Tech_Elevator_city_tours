import Vue from 'vue'
import Router from 'vue-router'
import auth from './auth'
import Home from './views/Home.vue'
import Login from './views/Login.vue'
import Register from './views/Register.vue'
import LandmarkDetails from './views/LandmarkDetails.vue'
import ManageItinerary from './views/ManageItinerary.vue'
//import AllItineraries from './views/AllItineraries.vue'
import CreateItinerary from './views/CreateItinerary.vue'
Vue.use(Router)


/**
 * The Vue Router is used to "direct" the browser to render a specific view component
 * inside of App.vue depending on the URL.
 *
 * It also is used to detect whether or not a route requires the user to have first authenticated.
 * If the user has not yet authenticated (and needs to) they are redirected to /login
 * If they have (or don't need to) they're allowed to go about their way.
 */

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/login",
      name: "login",
      component: Login,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/register",
      name: "register",
      component: Register,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/LandmarkDetails/:id",
      name: "landmark-details",
      component: LandmarkDetails,
      meta: {
        requiresAuth: false
      }      
    },
    {
      path: "/ManageItinerary/:landmark_id",
      name: "manage-itinerary",
      component: ManageItinerary,
      meta: {
        requiresAuth: true   //!!!!!!!!!!!!!!!!!change to true!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!        
      }
    },
    /*{
      //need path and such for all itineraries
      path:"/AllItineraries/:**INSERT CODE HERE**",
      name:"all-itineraries",
      component: AllItineraries,
      meta: {
        requiresAuth: true
      }

    },*/
    {
      path: "/CreateItinerary/:id",
      name: "create-itinerary",
      component: CreateItinerary,
      meta: {
        requiresAuth: false
      }      
    }
  ]
})

router.beforeEach((to, from, next) => {
  // Determine if the route requires Authentication
  const requiresAuth = to.matched.some(x => x.meta.requiresAuth);
  const user = auth.getUser();

  // If it does and they are not logged in, send the user to "/home"
  if (requiresAuth && !user) {
    next("/login");
  } else {
    // Else let them go to their next destination
    next();
  }
});


export default router;
