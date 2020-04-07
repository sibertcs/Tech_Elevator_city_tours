import Vue from 'vue'
import BootstrapVue from 'bootstrap-vue/dist/bootstrap-vue.esm';
import App from './App.vue'
import router from './router'
import 'bootstrap'
//import './styles/app.scss'
Vue.config.productionTip = false
Vue.use(BootstrapVue);
new Vue({
  router,
  el: '#app',
  render: h => h(App)
}).$mount('#app')
