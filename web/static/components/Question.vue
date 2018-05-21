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
        :comment="comment"
        @update="updateComment" />
      <hr>
    </div>
    <div v-if="isLoggedIn()">
      <div class="form-group comment-form">
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
          @click="submitComment">投稿</button>
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
          this.$router.push({ path: `/question/${this.$route.params.id}` });
        });
    },
    updateComment({ commentId, body }) {
      this.$store.dispatch('updateQuestionComment', { questionId: this.$route.params.id, id: commentId, body: body });
    },
  },
};
</script>

<style scoped>
.btn-comment {
  margin-top: 10px;
}
</style>
