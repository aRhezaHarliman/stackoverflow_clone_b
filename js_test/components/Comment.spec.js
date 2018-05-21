import assert from 'power-assert';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import Comment from '@/components/Comment';
import router from '@/router';

describe('Comment', function () {
  const comment = {
    id: 'dhzMyIF8dXYbCpZTHred',
    user_id: '589d196d22000036137e473b',
    created_at: '2018-02-27T06:35:26+00:00',
    body: 'body1',

  };
  it('renders comment body and created_at components', function () {
    const wrapper = shallow(Comment, {
      router,
      propsData: {
        comment,
      },
    });
    assert(wrapper.find('.comment-body').text().includes(comment.body));
  });
});
