import assert from 'power-assert';
import Vuex from 'vuex';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import Comment from '@/components/Comment';
import router from '@/router';

describe('Comment', function () {
  let methods;
  let store;
  const comment = {
    id: 'dhzMyIF8dXYbCpZTHred',
    user_id: '589d196d22000036137e473b',
    created_at: '2018-02-27T06:35:26+00:00',
    body: 'body1',
  };

  beforeEach(function () {
    store = new Vuex.Store({
      state: {
      },
      actions: {
      },
    });
  });

  const editedBody = 'editedBody';

  function startEdit() {
    beforeEach(function () {
      methods = {
        isValidUser() {
          return true;
        },
      };
    });
    const wrapper = shallow(Comment, {
      store,
      methods,
      propsData: {
        comment,
      },
    });
    assert(wrapper.find('.edit-button').exists());
    wrapper.find('.edit-button').trigger('click');
    assert(wrapper.find('.body-edit').element.value === comment.body);
    return wrapper;
  }

  it('emits "update" event when user clicks save button', function () {
    const wrapper = startEdit();
    wrapper.find('.body-edit').element.value = editedBody;
    wrapper.find('.body-edit').trigger('input');
    wrapper.find('.comment-form').trigger('submit');
    const eventArgs = wrapper.emitted().update[0];
    assert(eventArgs[0].body === editedBody);
  });

  it('cancels editing when user clicks cancel button', function () {
    const wrapper = startEdit();
    wrapper.find('.body-edit').element.value = editedBody;
    wrapper.find('.body-edit').trigger('input');
    wrapper.find('.cancel-edit-button').trigger('click');
    assert(!wrapper.find('.body-edit').exists());
    assert(wrapper.find('.comment-body').text().includes(comment.body));
  });

  it('renders comment body and created_at components', function () {
    const wrapper = shallow(Comment, {
      store,
      router,
      propsData: {
        comment,
      },
    });
    assert(wrapper.find('.comment-body').text().includes(comment.body));
  });

  it('Does not render update if user_id is different', function () {
    const wrapper = shallow(Comment, {
      methods: {
        isValidUser() {
          return false;
        },
      },
      propsData: {
        editing: true,
        comment,
      },
    });
    assert(!wrapper.find('.edit-button').exists());
  });
});
