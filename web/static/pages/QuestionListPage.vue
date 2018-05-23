<template>
  <div>
    <div class="page-title"><center>【投稿された質問一覧】</center></div>
    <br><br><br>
    <div>
      <router-link
        to="question/create"
        class="btn btn-primary mb-2"
      >質問を新規作成
      </router-link>
    </div>
    <hr>
    <div
      v-for="question in questions"
      :key="question.id" >
      <h5 class="title">
        <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
          {{ question.title }}
        </router-link>
      </h5>
      <div class="additional">
        Posted at {{ question.createdAt }}
        by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">{{ question.userId }}</router-link>
      </div>
      <hr>
    </div>
    <div
      class="pagination"
      align="center" >
      <div v-if="!isFirstPage">
        <a
          class="btn-link btn-prev"
          @click="previous()">&laquo;</a>
      </div>
      <a
        v-for="n in getPages"
        :key="n"
        @click="retrieveQuestionsByPage(n)">{{ n }}</a>
      <div v-if="!isLastPage">
        <a
          class="btn-link btn-next"
          @click="next()">&raquo;</a>
      </div>
    </div>
  </div>
</template>

<script>
import _ from 'lodash';

export default {
  name: 'QuestionListPage',
  data() {
    return {
      currentPage: 1,
      maxPage: 0,
    };
  },
  computed: {
    questions() {
      return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
    getPages() {
      const pages = [];
      const maxPage = Math.ceil(this.$store.state.questionCount / 10);
      for (let i = 1; i <= maxPage; i += 1) {
        pages.push(i);
      }
      return pages;
    },
    isFirstPage() {
      return (this.currentPage <= 1);
    },
    isLastPage() {
      return (this.currentPage >= this.$store.state.questionsCount);
    },
  },
  mounted() {
    this.retrieveQuestionsCount();
    this.retrieveQuestionsByPage(this.currentPage);
  },
  methods: {
    retrieveQuestionsCount() {
      this.$store.dispatch('retrieveQuestionsCount');
    },
    retrieveQuestions() {
      this.$store.dispatch('retrieveQuestions');
    },
    next() {
      if (this.$store.state.questionsCount > (this.currentPage + 1)) {
        this.currentPage += 1;
        this.retrieveQuestionsByPage(this.currentPage);
      }
    },
    previous() {
      if ((this.currentPage - 1) <= 0) {
        this.currentPage -= 1;
        this.retrieveQuestionsByPage(this.currentPage);
      }
    },
    retrieveQuestionsByPage(page) {
      this.$store.dispatch('retrieveQuestionsByPage', { page: page });
    },
  },
};
</script>

<style scoped>
.title {
  text-overflow: ellipsis;
  overflow: hidden;
}
.pagination {
    /* display: inline-block; */
    margin-bottom: 30px;
}

.pagination a {
    color: black;
    float: left;
    padding: 8px 16px;
    font-size: 1.5em;
    text-decoration: none;
    cursor: pointer;
}

.pagination a.active {
    background-color: #4CAF50;
    color: white;
    border-radius: 5px;
}

.pagination a:hover:not(.active) {
    background-color: #ddd;
    border-radius: 5px;
}
</style>
