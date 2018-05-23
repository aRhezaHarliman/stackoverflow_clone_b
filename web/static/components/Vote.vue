<template>
  <div>
    <div v-if="alreadyLike()">
      <div class="vote-arrow">▲</div>
    </div>
    <div v-else>
      <div
        class="vote-arrow vote-arrow-active"
        @click="submitLikeVote">▲</div>
    </div>
    <div class="vote-count">{{ question.likeVoterIds.length - question.dislikeVoterIds.length }}</div>
    <div v-if="alreadyDislike()">
      <div class="vote-arrow">▼</div>
    </div>
    <div v-else>
      <div
        class="vote-arrow vote-arrow-active"
        @click="submitDislikeVote">▼</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Vote',

  props: {
  },
  data() {
    return {};
  },
  computed: {
    question() {
      return this.$store.state.question;
    },
  },
  mounted() {
  },
  methods: {
    alreadyLike() {
      return this.question.likeVoterIds.includes(this.$store.state.id);
    },
    alreadyDislike() {
      return this.question.dislikeVoterIds.includes(this.$store.state.id);
    },
    submitLikeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.question.id, voteType: 'like_vote' });
    },
    submitDislikeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.question.id, voteType: 'dislike_vote' });
    },
  },
};
</script>

<style scoped>
.vote-arrow {
    font-size: 2em;
    margin-left: -10px;
    color: #ccc;
    cursor: not-allowed;
}
.vote-arrow-active {
    color: #777;
    cursor: pointer;
}
.vote-count {
    font-size: 2em;
    margin-left: -5px;
    color: #000;
}
</style>
