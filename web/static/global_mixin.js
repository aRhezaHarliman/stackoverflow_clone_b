import Vue from 'vue';
import AppConfig from '@/AppConfig';

Vue.mixin({
  data() {
    return {
      bodyMaxLength: AppConfig.bodyMaxLength,
      titleMaxLength: AppConfig.titleMaxLength,
      authorMaxLength: AppConfig.authorMaxLength,
      commentMaxLength: AppConfig.commentMaxLength,
    };
  },
  methods: {
    isLoggedIn() {
      if (!this.$store.state.email) {
        return false;
      }
      const expiresAt = this.$store.state.expiresAt; /* eslint-disable-line prefer-destructuring */
      const isExpired = Date.now() > Date.parse(expiresAt);
      return !isExpired;
    },
    myId() {
      return this.$store.state.id;
    },
    isValidUser(id) {
      return this.$store.state.id == id;
    },
  },
});
