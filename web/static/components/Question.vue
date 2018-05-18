<template>
  <div>
    <div class="page-title">{{ question.title }}</div>
    <hr>
    <div class="body">{{ question.body }}</div>
    <div class="additional">
      Posted at {{ question.createdAt }} by 
      <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
          {{ question.userId }}</router-link>
    </div>
    <br >
    コメント
    <div
      v-for="comment in question.comments"
      :key="comment.id"
      class="comments">
      <comment
        :comment="comment" />
      <hr>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {};
  },
  computed: {
  },
  mounted() {
  },
  methods: {
  },
};
</script>

<style scoped>
</style>
