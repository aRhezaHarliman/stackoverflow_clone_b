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
        Posted at {{ answer.createdAt }} by
        <router-link :to="{ name: 'UserDetailPage', params: { id: answer.userId }}">
          {{ answer.userId }}</router-link>
      </div>
      <span
          v-if="isValidUser(answer.userId)"
          class="additional">
          <button
            v-if="!editing"
            type="button"
            class="edit-button btn btn-link"
            @click="startEdit">
            更新
          </button>
        </span>
      <hr>
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
    },
  },
  data() {
    return {
      answer: '',
      editing: false,
      editingBody: '',
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
      this.$store.dispatch('updateAnswer', { questionId: this.$route.params.id, id: this.answer.id, body: this.editingBody });
      this.editing = false;
    },
  }
};
</script>

<style scoped>
</style>
