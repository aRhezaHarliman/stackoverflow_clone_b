<template>
  <div>
    <div v-if="editing">
      <div class="form-group">
        <label for="form-title">タイトル</label>
        <input
          id="form-title"
          v-model="editingTitle"
          :maxlength="titleMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required>
      </div>
    </div>
    <div v-else>
      <div class="page-title">{{ question.title }}</div>
    </div>
    <hr>
    <div class="main-area">
      <div class="content-area">
        <div v-if ="editing">
          <form
            class="form-body"
            @submit.prevent="update">
            <div class="form-group">
              <label for="form-body">質問内容</label>
              <!-- <input
                id="form-body"
                v-model="editingBody"
                :maxlength="bodyMaxLength"
                class="body-edit form-control"
                type="text"
                minlength="1"
                required> -->
            </div>
            <textarea
              id="form-body"
              v-model="editingBody"
              :maxlength="bodyMaxLength"
              class="body-edit form-control"
              minlength="1"
              required/>
            <div class="form-group">
              <br>
              <button
                class="btn btn-primary mb-2"
                type="submit">保存</button>
              <button
                class="cancel-edit-button btn btn-outline-primary mb-2"
                type="submit"
                @click.privent="cancelEdit">キャンセル</button>
            </div>
          </form>
        </div>
        <div v-else>
          <div class="body">【質問内容】<br><br>{{ question.body }}</div>
          <div class="additional">
            <span v-if="!editing">
              --Posted at {{ question.createdAt }} by
              <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
                {{ question.userId }}</router-link>
              <br>
              <button
                v-if="isValidUser(question.userId)"
                type="button"
                class="btn btn-primary btn-sm"
                @click="startEdit"
              >
                質問の更新
              </button>
            </span>
          </div>

        </div>
      </div>
    </div>
    <br >
    <div
      v-for="comment in question.comments"
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
        <!-- <input
          id="form-comment"
          v-model="comment"
          :maxlength="commentMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required> -->
          <textarea
            id="form-cooment"
            v-model="comment"
            :maxlength="commentMaxLength"
            class="comment-edit form-control"
            minlength="1"
            required/>
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
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      comment: '',
      editing: false,
      editingBody: '',
      editingTitle: '',
    };
  },
  computed: {
  },
  mounted() {
  },
  methods: {
    submitComment() {
      this.$store.dispatch('createQuestionComment', { questionId: this.$route.params.id, body: this.comment })
        .then(() => {
          this.$router.push({ path: `/question/${this.$route.params.id}` });
        });
    },
    updateComment({ commentId, body }) {
      this.$store.dispatch('updateQuestionComment', { questionId: this.$route.params.id, id: commentId, body: body });
    },
    startEdit(){
      this.editing = true;
      this.editingBody = this.question.body;
      this.editingTitle = this.question.title;
    },
    cancelEdit(){
      this.editing = false;
    },
    update(){
      this.$emit('update', { title: this.editingTitle, body: this.editingBody });
      this.editing = false;
    },
  },
};
</script>

<style scoped>
.btn-comment {
  margin-top: 10px;
}
.page-title {
  text-overflow: ellipsis;
  overflow: hidden;
}
.body {
  word-break: break-all;
  white-space: pre-wrap;
}
.body-edit{
  height:200px;
}
.comment-edit{
  height:200px;
}
.title-edit{
  height:20px;
}
.comment-list {
  margin-left: 10px;
}
</style>
