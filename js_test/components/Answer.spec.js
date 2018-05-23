import assert from 'power-assert';
import Vuex from 'vuex';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import Answer from '@/components/Answer';
import router from '@/router';

describe('Answer', function () {
  let methods;
  let store;

  const answer = {
    id: 'answerX',
    comments: [
      {
        user_id: '5aa2100737000037001811c3',
        id: '0GhVJIvT3TUqastruFr9',
        created_at: '2018-05-06T14:00:23+00:00',
        body: 'bodyX',
      },
    ],
    userId: 'userX',
    questionId: 'questionX',
    createdAt: '2000-00-00T00:00:00+00:00',
    body: 'bodyX',
  };

  beforeEach(function () {
    store = new Vuex.Store({
      state: {
      },
      actions: {
      },
    });
    methods = {
      isValidUser() {
        return true;
      },
    };
  });

  it('renders answer body components', function () {
    const wrapper = shallow(Answer, {
      store,
      router,
      propsData: {
        answer,
      },
    });
    assert(wrapper.find('.answer-body').text().includes(answer.body));
  });

  const editedBody = 'editedBody';

  function startEdit() {
    const wrapper = shallow(Answer, {
      store,
      router,
      methods,
      propsData: {
        editing: false,
        answer,
      },
    });
    assert(wrapper.find('.edit-button').exists());
    wrapper.find('.edit-button').trigger('click');
    assert(wrapper.find('.body-edit').element.value === answer.body);
    return wrapper;
  }

  it('emits "update" event when user clicks save button', function () {
    const wrapper = startEdit();
    wrapper.find('.body-edit').element.value = editedBody;
    wrapper.find('.body-edit').trigger('input');
    wrapper.find('.answer-form').trigger('submit');
    const eventArgs = wrapper.emitted().update[0];
    assert(eventArgs[0].body === editedBody);
  });

  it('Does not render update if user_id is different', function () {
    const wrapper = shallow(Answer, {
      store,
      methods: {
        isValidUser() {
          return false;
        },
      },
      propsData: {
        editing: true,
        answer,
      },
    });
    assert(!wrapper.find('.edit-button').exists());
  });
});
