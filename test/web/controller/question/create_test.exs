defmodule StackoverflowCloneB.Controller.Question.CreateTest do
  use StackoverflowCloneB.CommonCase
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.TestData.QuestionData

  @api_prefix "/v1/question"
  @header     %{}
  @body       %{"body" => "本文", "title" => "タイトル"}

  test "create/1 " <>
    "Create question test" do
    :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
    end)
    :meck.expect(G2gClient, :send, fn(_, _, req) ->
      assert req.body == %Dodai.CreateDedicatedDataEntityRequestBody{
        data: %{
          "comments"        => [],
          "like_voter_ids"    => [],
          "dislike_voter_ids" => [],
          "title" => "タイトル",
          "body" => "本文",
          "user_id" => "user_id",}
      }
      %Dodai.CreateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
  end

  test "create/1 " <>
    "when request body is invalid " <>
    "it returns BadRequestError" do
    :meck.expect(StackoverflowCloneB.Plug.FetchMe, :fetch, fn(conn, _) ->
      Antikythera.Conn.assign(conn, :me, StackoverflowCloneB.TestData.UserData.dodai())
    end)
    invalid_bodies = [
      %{},
      %{"title" => "title"},
      %{"title" => "",      "body" => "body"},
      %{"title" => "title", "body" => ""},
    ]

    Enum.each(invalid_bodies, fn body ->
      res = Req.post_json(@api_prefix, body, @header)
      assert res.status               == 400
      assert Poison.decode!(res.body) == %{
        "code"        => "400-06",
        "description" => "Unable to understand the request.",
        "error"       => "BadRequest",
      }
    end)
  end

  test "create/1 " <>
    "when credential is invalid or missing " <>
    "it returns BadRequest" do

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 401
    assert Poison.decode!(res.body) == %{
      "code"        => "401-00",
      "description" => "The given credential is invalid.",
      "error"       => "InvalidCredential"
    }
  end
end
