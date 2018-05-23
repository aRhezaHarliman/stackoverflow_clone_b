<template>
  <div>
    <div v-if="editing">
      <form
        class="comment-form"
        @submit.prevent="update">
        <div class="form-group">
          <textarea
            id="form-body"
            v-model="editingBody"
            :maxlength="bodyMaxLength"
            class="body-edit form-control"
            minlength="1"
            required/>
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
      <div class="comment-body">
        {{ comment.body }} <span class="additional"><br>-- Posted at {{ comment.createdAt }} by
          <router-link :to="{ name: 'UserDetailPage', params: { id: comment.userId }}">
            {{ comment.userId }}</router-link>
        </span>
        <span
          v-if="isValidUser(comment.userId)"
          class="additional">
          <div align="right">
            <button
              v-if="!editing"
              type="button"
              class="edit-button square_btn_comment2 btn-sm"
              @click="startEdit">
              このコメントを更新
            </button>
          </div>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Comment',

  props: {
    comment: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      editing: false,
      editingBody: '',
    };
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.comment.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { commentId: this.comment.id, body: this.editingBody });
      this.editing = false;
      this.editingBody = '';
    },
  },
};
</script>

<style scoped>
.body-edit{
  height:200px;
}
.square_btn_comment2 {
    display: inline-block;
    padding: 0.3em 1em;
    text-decoration: none;
    color: #F89A1F;
    border: solid 2px #F89A1F;
    border-radius: 3000px;
    transition: .4s;
}
.square_btn_comment2:hover {
    background: #F89A1F;
    color: white;
  }
</style>
