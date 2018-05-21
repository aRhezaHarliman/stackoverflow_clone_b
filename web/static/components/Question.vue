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
    <div
      v-for="comment in question.comments"
      :key="comment.id"
      class="comments">
      <comment
        :comment="comment" />
      <hr>
    </div>
    <div v-if="isLoggedIn()">
      <div class="form-group">
        <input
          id="form-comment"
          v-model="comment"
          :maxlength="commentMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required>
        <button 
          class="btn btn-primary mb-2 btn-comment"
          v-on:click="submitComment">投稿</button>
      </div>
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
    return {
      comment: '',
    };
  },
  computed: {
  },
  mounted() {
  },
  methods: {
    submitComment() {
      this.$store.dispatch('createQuestionComment', { questionId: this.$route.params.id, body: this.comment })
      .then(() => {
          this.$router.push({ path: '/question/'+this.$route.params.id });
        });
    },
  },
};
</script>

<style scoped>
.btn-comment {
  margin-top: 10px;
}
.form-group {
  margin-left: 20px;
}
</style>
