<template>
  <div>
    <div class="asnwer_body">{{ answer.body }}</div>
    <div class="additional">
      Posted at {{ answer.createdAt }} by
      <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
        {{ answer.userId }}</router-link>
    </div>
    <hr>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Answer',
  components: {
    Comment,
  },
  props: {
    answer: {
      type: Object,
      requeired: true,
    },
  },
  data() {
    return {
      answer: '',
    };
  }
};
</script>

<style scoped>
</style>
