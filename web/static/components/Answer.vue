<template>
<!-- 回答編集部 -->
  <div>
    <div v-if="editing">
      <form
        class="answer-form"
        @submit.prevent="update">
        <div class="form-group">
          <textarea
            id="form-answer"
            v-model="editingBody"
            :maxlength="bodyMaxLength"
            class="body-edit form-control"
            type="text"
            minlength="1"
            required />
        </div>
        <div class="form-group">
<!-- 回答編集保存/キャンセルボタン -->
          <button
            class="btn btn-primary mb-2"
            type="submit">保存</button>
          <button
            class="cancel-edit-button btn btn-outline-primary mb-2"
            type="submit"
            @click.prevent="cancelEdit">キャンセル</button>
        </div>
      </form>
    </div>
<!-- 回答を表示 -->
    <div v-else>
      <br><br>
      <div class="answer-body"><big>{{ answer.body }}</big></div>
      <div class="additional">
        --Posted at {{ answer.createdAt }} by
        <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
          {{ answer.userId }}</router-link>
      </div>
<!-- 回答を更新するかボタン -->
      <span
        v-if="isValidUser(answer.userId)"
        class="additional">
        <button
          v-if="!editing"
          type="button"
          class="edit-button btn btn-primary btn-sm"
          @click="startEdit">
          回答を更新
        </button>
      </span>
      <hr>
    </div>
<!-- コメント表示部 -->
    <div v-if="answer.comments.length > 0">
      <div v-if="commentexpansion">
        <div
          v-for="comment in answer.comments"
          :key="comment.id"
          class="comments">
          <comment
            :comment="comment"
            @update="updateComment" />
          <hr>
        </div>
<!-- コメント非表示ボタン -->
        <div v-if="answer.comments.length > 1">
          <button
            type="button"
            class="btn btn-link"
            @click="commenthide">
            コメントを非表示
          </button>
        </div>
      </div>
      <div v-else>
        <div
          v-for="comment in answer.comments.slice(0,1)"
          :key="comment.id"
          class="comments">
          <comment
            :comment="comment"
            @update="updateComment" />
          <hr>
        </div>
        <div v-if="answer.comments.length > 1">
<!-- コメント表示ボタン -->
          <button
            type="button"
            class="btn btn-link"
            @click="answercommentexpansion">
            全コメント({{answer.comments.length}}件)を表示
          </button>
        </div>
      </div>
    </div>
<!-- コメント追加部 -->
    <div v-if="isLoggedIn()">
      <div v-if="postcommentexpansion">
        <div class="form-group comment-form">
          <label for="form-comment">コメント追加</label>
          <textarea
            id="form-comment"
            v-model="comment"
            :maxlength="commentMaxLength"
            class="comment-edit form-control"
            type="text"
            minlength="1"
            required />
<!-- コメント投稿/キャンセルボタン -->
          <button
            class="btn btn-primary mb-2 btn-comment"
            @click="submitComment">投稿</button>
          <button
          class="btn btn-outline-primary mb-2 btn-comment"
          @click="posthide">キャンセル</button>
        </div>
      </div>
<!-- コメントをするボタン -->
      <div v-else>
        <button
          class="btn btn-success btn-sm btn-comment"
          @click="postexpansion">この回答にコメントする</button>
      </div>
    </div>
    <br><br><br>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Answer',
  components: {
    Comment,
  },
  props: {
    answer: {
      type: Object,
      requeired: true,
      default: function () {},
    },
  },
  data() {
    return {
      editing: false,
      editingBody: '',
      comment: '',
      commentexpansion: false,
      postcommentexpansion: false,
    };
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.answer.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { answerId: this.answer.id, body: this.editingBody });
      this.editing = false;
      this.editingBody = '';
    },
    answercommentexpansion(){
      this.commentexpansion = true;
    },
    commenthide(){
      this.commentexpansion = false;
    },
    postexpansion(){
      this.postcommentexpansion = true;
    },
    posthide(){
      this.postcommentexpansion = false;
    },
    submitComment() {
      this.$store.dispatch('createAnswerComment', { questionId: this.$route.params.id, answerId: this.answer.id, body: this.comment })
        .then(() => {
          this.$router.push({ path: `/question/${this.$route.params.id}` });
        });
      this.comment = '';
    },
    updateComment({ commentId, body }) {
      this.$store.dispatch('updateAnswerComment', {
        questionId: this.$route.params.id, answerId: this.answer.id, id: commentId, body: body,
      });
    },
  },
};
</script>

<style scoped>
.btn-comment {
  margin-top: 10px;
}
.comment-edit {
  height:80px;
}
.body-edit{
  height:200px;
}
</style>
