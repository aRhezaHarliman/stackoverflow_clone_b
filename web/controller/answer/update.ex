use Croma
defmodule StackoverflowCloneB.Controller.Answer.Update do
  use StackoverflowCloneB.Controller.Application
  alias StackoverflowCloneB.Dodai, as: SD
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Answer.Helper

  defmodule RequestBody do
    defmodule BodyString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,3000}$/
    end

    use Croma.Struct, fields: [
      body: Croma.TypeGen.nilable(BodyString),
    ]
  end

  plug StackoverflowCloneB.Plug.FetchMe, :fetch, []

  def update(%Conn{request: %Request{path_matches: %{id: id}}, assigns: %{me: %{"_id" => _user_id}}} = conn) do
    # 指定されたidをもつanswerを取得する

    with_answer(conn, fn answer ->
      #IO.inspect answer
    # answerのuser_idとログインユーザの_idが一致するか確認する(この判定ロジックを書いてみましょう)
      if answer["data"]["user_id"] == conn.assigns.me["_id"] do
        ## 一致した場合
        ## 更新処理をする(下記の処理を書いてみましょう)
        rqbody = RequestBody.new(conn.request.body)
        #IO.inspect rqbody
        case rqbody do
          {:ok,_} ->
            ### 1. dodaiに対してrequestするrequest bodyを作成する
            request_body = conn.request.body["body"]
            data = %{
              "body" => request_body
            }
            req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => data}}
            ### 2. dodaiに対してrequestするためのstructを作る
            req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), "Answer", id, SD.root_key(), req_body)
            %Dodai.UpdateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(conn.context, SD.app_id(), req)
            ### 3. クライアントにレスポンスを返す(dodaiのresponse bodyがいつもと違うことに注意)
            Conn.json(conn, 200, Helper.to_response_body(res_body))
          {:error,_} ->
            ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.BadRequestError.new)
        end
      else
      ## 一致しない場合、下記のようにエラーを返す
       ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.CredentialError.new())
      end

    end)
  end
  #回答が存在するかどうかを検証
  def with_answer(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Answer", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneB.Error.ResourceNotFoundError.new())
    end
  end
end
