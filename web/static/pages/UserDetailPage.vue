<template>
  <div>
    <img src="https://cdn.worldvectorlogo.com/logos/stack-overflow.svg">
    <hr>
    <h1 class="basic"><center>User Page</center></h1>
    <div class="question-list list">
      <div class="list-title">質問一覧</div>
      <div
        v-for="(question, index) in questions"
        :key="question.id">
        <div class="question-title">
          <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
            {{ question.title }}
          </router-link>
        </div>
        <div class="additional">
          Posted at {{ question.createdAt }}
        </div>
        <hr v-if="index !== questions.length - 1">
      </div>
    </div>
    <div class="answer-list list">
      <div class="list-title">回答一覧</div>
      <div
        v-for="(answer, index) in answers"
        :key="answer.id">
        <div class="answer-body">
          <router-link :to="{ name: 'QuestionDetailPage', params: { id: answer.questionId }}">
            <span style="white-space:pre">{{ decodeURI(answer.body).replace(/\r?\n/g, '\n') }}</span>
          </router-link>
        </div>
        <div class="additional">
          Posted at {{ answer.createdAt }}
        </div>
        <hr v-if="index !== answers.length - 1">
      </div>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';

export default {
  name: 'UserDetailPage',
  computed: {
    questions() {
      return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
    answers() {
      return _.sortBy(this.$store.state.answers, 'createdAt').reverse();
    },
  },
  mounted() {
    this.$store.dispatch('retrieveQuestions', { userId: this.$route.params.id });
    this.$store.dispatch('retrieveAnswers', { userId: this.$route.params.id });
  },
};
</script>

<style scoped>
.list-title {
  font-size: var(--page-sub-title-font-size);
  margin-bottom: 8px;
}
.list {
  margin: 30px 0;
}
.basic {
  background: ffffff;
  text-shadow: 2px 4px 3px rgba(0,0,0,0.3);
}
img{
   max-width: 250px;
   height: auto;
   width: auto;
   max-height: 250px;
}
</style>
