<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question"/>
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
    // TODO ADD ANSWER and LIKE/DISLIKE function
  },
};
</script>

<style scoped>
</style>
