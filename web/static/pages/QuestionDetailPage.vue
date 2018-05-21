<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question"/>
    </div>
    <h1 v-else>404 (Not Found)</h1>
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
    <router-link :to="{ name: 'QuestionListPage'}">
      一覧に戻る
    </router-link>
  </div>
</template>

<script>
import _ from 'lodash';
import Question from '@/components/Question';
import Answer from '@/components/Answer';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
  },
  data() {
    return {
      comment: '',
    };
  },
  computed: {
    hasValidQuestion() {
      return !_.isEmpty(this.question) && this.question.id === this.$route.params.id;
    },
    question() {
      return this.$store.state.question;
    },
    // answer() {
    //   return this.$store.state.answer;
    // }
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    submitComment() {
      this.$store.dispatch('createQuestionComment', { questionId: this.$route.params.id, body: this.comment })
      .then(() => {
          this.$router.push({ path: '/question/'+this.$route.params.id });
        });
    },
    // TODO ADD ANSWER and LIKE/DISLIKE function
  },
};
</script>

<style scoped>
.btn-comment {
  margin-top: 10px;
}
</style>
