<template>
  <div>
    <div v-if="editing">
      <form
        class="comment-form"
        @submit.prevent="update">
        <div class="form-group">
          <!-- <input
            id="form-comment"
            v-model="editingBody"
            :maxlength="commentMaxLength"
            class="body-edit form-control"
            type="text"
            minlength="1"
            required> -->
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
          <button
            v-if="!editing"
            type="button"
            class="edit-button btn-primary btn-sm"
            @click="startEdit">
            コメント更新
          </button>
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
  height:80px;
}
</style>
