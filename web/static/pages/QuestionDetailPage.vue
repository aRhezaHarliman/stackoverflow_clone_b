<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question"
        class="question"
        @update="updateQuestion"/>
      <br>
      <h3>{{ answers.length }}件の回答</h3>
      <hr>
      <div
        v-for="answer in answers"
        :key="answer.id"
        class="answers">
        <answer
          :answer="answer"
          class="answer-item" />
      </div>
    </div>
    <h1 v-else>404 (Not Found)</h1>
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
    return {};
  },
  computed: {
    hasValidQuestion() {
      return !_.isEmpty(this.question) && this.question.id === this.$route.params.id;
    },
    question() {
      return this.$store.state.question;
    },
    answers() {
      return _.sortBy(this.$store.state.answers, 'createdAt').reverse();
    }
  },
  mounted() {
    this.retrieveQuestion();
    this.retrieveAnswers();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    updateQuestion({title,body}) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id,title,body });
    },
    retrieveAnswers() {
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
    // TODO LIKE/DISLIKE function
  },
};
</script>

<style scoped>
.question {
  margin-bottom: 20px;
}
.answer-item {
  margin-left: 20px;
}
</style>
