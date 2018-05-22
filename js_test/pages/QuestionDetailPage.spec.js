import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { shallow } from '@vue/test-utils';
import '../TestHelper';
import QuestionDetailPage from '@/pages/QuestionDetailPage';
import Question from '@/components/Question';
import router from '@/router';

describe('QuestionDetailPage', function () {
  const questionId = 'questionX';
  let store;
  let sandbox;
  let retrieveQuestionStub;
  let updateQuestionStub;
  let retrieveAnswersStub;
  let submitAnswerStub;

  const questionBody = {
    id: questionId,
    title: 'titleX',
    body: 'bodyX',
  };

  beforeEach(function () {
    sandbox = sinon.sandbox.create();
    retrieveQuestionStub = sandbox.stub().callsFake(() => Promise.resolve());
    updateQuestionStub = sandbox.stub().callsFake(() => Promise.resolve());
    retrieveAnswersStub = sandbox.stub().callsFake(() => Promise.resolve());
    submitAnswerStub = sandbox.stub().callsFake(() => Promise.resolve());

    store = new Vuex.Store({
      state: {
        question: {
          id: questionId,
          title: 'titleX',
          body: 'bodyX',
        },
      },
      actions: {
        retrieveQuestion: retrieveQuestionStub,
        updateQuestion: updateQuestionStub,
        retrieveAnswers: retrieveAnswersStub,
        submit: submitAnswerStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('dispatches "updateQuestion" when Question component emits "updateQuestion" event', function () {
    const editedTitle = 'editedTitle';
    const editedBody = 'editedBody';
    router.push({ name: 'QuestionDetailPage', params: { id: questionId } });
    const wrapper = shallow(QuestionDetailPage, {
      store,
      router,
      propsData: {
        questionBody,
      },
    });
    const retrieveQuestionArg = retrieveQuestionStub.getCall(0).args[1];
    assert(retrieveQuestionArg.id === questionId);
    wrapper.find(Question).vm.$emit('update', { title: 'editedTitle', body: 'editedBody' });
    const updateQuestionArg = updateQuestionStub.getCall(0).args[1];
    assert(updateQuestionArg.title === editedTitle);
    assert(updateQuestionArg.body === editedBody);
  });
});
