<template>
  <div>
    <div class="comment_body">
      {{ comment.body }} <span class="additional">-- Posted at {{ comment.createdAt }} by {{ comment.userId }}</span>
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
    return {};
  },
  methods: {

  },
};
</script>

<style scoped>
</style>
