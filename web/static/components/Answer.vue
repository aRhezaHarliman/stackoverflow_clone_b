<template>
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
    <div v-else>
      <div class="answer-body">{{ answer.body }}</div>
      <div class="additional">
        --Posted at {{ answer.createdAt }} by
        <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
          {{ answer.userId }}</router-link>
      </div>
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
    <div
      v-for="comment in answer.comments"
      :key="comment.id"
      class="comments">
      <comment
        :comment="comment"
        @update="updateComment" />
      <hr>
    </div>
    <div v-if="isLoggedIn()">
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
</style>
