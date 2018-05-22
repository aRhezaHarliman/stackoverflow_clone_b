<template>
  <div>
    <div v-if="hasValidQuestion">
      <question
        :question="question"
        class="question"
        @update="updateQuestion"/>
      <br>
      <h5>{{ answers.length }}件の回答</h5>
      <hr>
      <div
        v-for="answer in answers"
        :key="answer.id"
        class="answers">
        <answer
          :answer="answer"
          class="answer-item"
          @update="updateAnswer" />
      </div>
      <br >
      <div v-if="isLoggedIn()">
        <form
          class="answer-form"
          @submit.prevent="submit">
          <div class="form-group">
            <h4>回答</h4>
            <hr>
            <textarea
              id="form-body"
              v-model="answerBody"
              :maxlength="bodyMaxLength"
              class="body-edit form-control"
              minlength="1"
              required/>
          </div>
          <div class="form-group">
            <button
              class="btn btn-primary mb-2"
              type="submit">投稿</button>
          </div>
        </form>
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
    return {
      answerBody: '',
    };
  },
  computed: {
    hasValidQuestion() {
      return !_.isEmpty(this.question) && this.question.id === this.$route.params.id;
    },
    question() {
      return {...this.$store.state.question,body:decodeURI(this.$store.state.question.body).replace(/\r?\n/g,'\n')};
    },
    answers() {
      return _.sortBy(this.$store.state.answers, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestion();
    this.retrieveAnswers();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body:encodeURI(body) });
    },
    updateAnswer({ answerId, body }) {
      this.$store.dispatch('updateAnswer', { questionId: this.$route.params.id, id: answerId, body: body });
    },
    retrieveAnswers() {
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
    submit() {
      this.$store.dispatch('createAnswer', { questionId: this.$route.params.id, body: this.answerBody })
        .then(() => {
          this.$router.push({ path: `/question/${this.$route.params.id}` });
        });
      this.answerBody = '';
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
.body-edit {
  height: 100px;
}
</style>
