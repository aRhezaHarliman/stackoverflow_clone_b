<template>
  <!-- 質問タイトル入力部 -->
  <div>
    <div class="main-area">
      <img src="https://cdn.worldvectorlogo.com/logos/stack-overflow.svg">
      <hr>
      <h1 class="basic"><center>Question Page</center></h1>
      <br><br>
      <div class="content-area">
        <!-- 質問内容入力部 -->
        <div v-if ="editing">
          <form
            class="form-body"
            @submit.prevent="update">
            <div class="form-group">
              <label for="form-title">タイトル</label>
              <input
                id="form-title"
                v-model="editingTitle"
                :maxlength="titleMaxLength"
                class="title-edit form-control"
                type="text"
                minlength="1"
                required >
              <hr>
              <label for="form-body">質問内容</label>
              <textarea
                id="form-body"
                v-model="editingBody"
                :maxlength="bodyMaxLength"
                class="body-edit form-control"
                minlength="1"
                required />
              <br>
              <!-- 質問編集の保存/キャンセルボタン -->
              <button
                class="btn btn-primary mb-2"
                type="submit">保存</button>
              <button
                class="cancel-edit-button btn btn-outline-primary mb-2"
                type="submit"
                @click.prevent="cancelEdit">キャンセル</button>
            </div>
          </form>
          <!-- 質問内容を表示 -->
        </div>
        <div v-else>
          <div class="page-title">{{ question.title }}</div>
          <div class="question-container">
            <div class="info-area">
              <vote
                :vote="vote"
                class="vote" />
            </div>
            <div class="question-body">
              <div class="body">【質問内容】<br><br><span style="white-space:pre"><big>{{ question.body }}</big></span></div>
              <div class="additional">
                <span v-if="!editing">
                  --Posted at {{ question.createdAt }} by
                  <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
                    {{ question.userId }}</router-link>
                  <br>
                  <!-- 質問更新ボタン -->
                  <div v-if="isValidUser(question.userId)">
                    <button
                      type="button"
                      class="edit-button square_btn_question btn-sm"
                      @click="startEdit">
                      質問を更新
                    </button>
                  </div>
                  <div v-else>
                    <br><br>
                  </div>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <br >
    <!-- コメント表示部 -->
    【コメント】
    <div v-if="question.comments.length > 0">
      <div v-if="commentexpansion">
        <div
          v-for="comment in question.comments"
          :key="comment.id"
          class="comments">
          <comment
            :comment="comment"
            @update="updateComment" />
          <hr>
        </div>
        <!-- コメント非表示ボタン -->
        <div v-if="question.comments.length > 2">
          <button
            type="button"
            class="btn btn-link"
            @click="hide">
            コメントを非表示
          </button>
        </div>
      </div>
      <div v-else>
        <div
          v-for="comment in question.comments.slice(0,2)"
          :key="comment.id"
          class="comments">
          <comment
            :comment="comment"
            @update="updateComment" />
          <hr>
        </div>
        <div v-if="question.comments.length > 2">
          <!-- コメント表示ボタン -->
          <button
            type="button"
            class="btn btn-link"
            @click="expansion">
            全コメント({{ question.comments.length }}件)を表示
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
            minlength="1"
            required/>
          <!-- コメント投稿/キャンセルボタン -->
          <button
            class="btn btn-primary mb-2 btn-comment"
            @click="submitComment">投稿</button>
          <button
            class="btn btn-outline-primary mb-2 btn-comment"
            @click="posthide">キャンセル</button>
        </div>
      </div>
      <div v-else>
        <!-- コメントをするボタン -->
        <button
          harf = "#"
          class="square_btn btn-sm"
          @click="postexpansion">この質問にコメントする</button>
      </div>
    </div>
    <br><br><br>
  </div>
</template>

<script>
import Comment from '@/components/Comment';
import Vote from '@/components/Vote';

export default {
  name: 'Question',
  components: {
    Comment,
    Vote,
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
      vote: {},
      commentexpansion: false,
      postcommentexpansion: false,
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
      this.comment = '';
    },
    updateComment({ commentId, body }) {
      this.$store.dispatch('updateQuestionComment', { questionId: this.$route.params.id, id: commentId, body: body });
    },
    startEdit() {
      this.editing = true;
      this.editingBody = this.question.body;
      this.editingTitle = this.question.title;
    },
    expansion() {
      this.commentexpansion = true;
    },
    postexpansion() {
      this.postcommentexpansion = true;
    },
    posthide() {
      this.postcommentexpansion = false;
    },
    hide() {
      this.commentexpansion = false;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { title: this.editingTitle, body: this.editingBody });
      this.editing = false;
      this.editingBody = '';
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
  height:80px;
}
.title-edit{
  height:20px;
}
.comment-list {
  margin-left: 10px;
}
.question-body {
  margin-left: 40px;
}
.vote {
  position: absolute;
}
.square_btn {
    display: inline-block;
    padding: 0.3em 1em;
    text-decoration: none;
    color: #67c5ff;
    border: solid 2px #67c5ff;
    border-radius: 3000px;
    transition: .4s;
}
.square_btn:hover {
    background: #67c5ff;
    color: white;
}
.square_btn_question {
    display: inline-block;
    padding: 0.3em 1em;
    text-decoration: none;
    color: #F89A1F;
    border: solid 2px #F89A1F;
    border-radius: 3000px;
    transition: .4s;
}
.square_btn_question:hover {
    background: #F89A1F;
    color: white;
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
