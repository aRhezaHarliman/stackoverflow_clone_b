<template>
  <div>
    <img src="https://cdn.worldvectorlogo.com/logos/stack-overflow.svg">
    <hr>
    <h1 class="basic"><center>Posted question list</center></h1>
    <br>
    <div v-if="isLoggedIn()">
      <router-link
        to="question/create"
        class="btn btn-primary mb-2"
      >質問を新規作成
      </router-link>
    </div>
    <div v-else>
        質問するにはログインしてください
    </div>
    <hr>
    <div
      class="pagination"
      align="center" >
      <div v-if="!isFirstPage">
        <a
          class="btn-link btn-prev"
          @click="previousPage">&laquo;</a>
      </div>
      <a
        v-for="n in getPages"
        :key="n"
        :class="{ active: currentPage == n }"
        @click="retrieveQuestionsByPage(n)">{{ n }}</a>
      <div v-if="!isLastPage">
        <a
          class="btn-link btn-next"
          @click="nextPage">&raquo;</a>
      </div>
    </div>
    <div
      v-for="question in questions"
      :key="question.id">
      <h5 class="title">
        <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
          {{ question.title }}
        </router-link>
      </h5>
      <p style="text-align: right">
        <!-- {{ question.answers.count.length }}件の回答 -->
      </p>
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
          @click="previousPage">&laquo;</a>
      </div>
      <a
        v-for="n in getPages"
        :key="n"
        :class="{ active: currentPage == n }"
        @click="retrieveQuestionsByPage(n)">{{ n }}</a>
      <div v-if="!isLastPage">
        <a
          class="btn-link btn-next"
          @click="nextPage">&raquo;</a>
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
      isFirstPage: true,
      isLastPage: false,
      isActive: false,
    };
  },
  computed: {
    questions() {
      return _.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
    getPages() {
      const pages = [];
      const maxPageCount = Math.ceil(this.$store.state.questionCount / 10);
      for (let i = 1; i <= maxPageCount; i += 1) {
        pages.push(i);
      }
      return pages;
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
    updatePagination() {
      const maxPageCount = Math.ceil(this.$store.state.questionCount / 10);
      this.maxPage = maxPageCount;
      this.isFirstPage = false;
      this.isLastPage = false;
      if (this.currentPage <= 1) {
        this.isFirstPage = true;
      }
      if (this.currentPage >= this.maxPage) {
        this.isLastPage = true;
      }
    },
    nextPage() {
      if (this.maxPage >= (this.currentPage + 1)) {
        this.currentPage += 1;
        this.retrieveQuestionsByPage(this.currentPage);
      }
    },
    previousPage() {
      if ((this.currentPage - 1) >= 0) {
        this.currentPage -= 1;
        this.retrieveQuestionsByPage(this.currentPage);
      }
    },
    retrieveQuestionsByPage(page) {
      this.$store.dispatch('retrieveQuestionsByPage', { page: page })
        .then(() => {
          this.currentPage = page;
          this.updatePagination();
          // this.getPages();
        });
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

.basic {
  background: #ffffff;
  text-shadow: 2px 4px 3px rgba(0,0,0,0.3);
}
img{
   max-width: 250px;
   height: auto;
   width: auto;
   max-height: 250px;
}

</style>
