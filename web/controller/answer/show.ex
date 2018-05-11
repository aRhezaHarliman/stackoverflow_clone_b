# use Croma

# defmodule StackoverflowCloneB.Controller.Answer.ShowRequestBody do
#   alias StackoverflowCloneB.Controller.Answer.Helper.Params

#   use Croma.Struct, fields: [
#     user_id : Croma.TypeGen.nilable(Params.Title),
#     question_id: Croma.TypeGen.nilable(Params.Body),
#   ]
# end
defmodule StackoverflowCloneB.Controller.Answer.Show do
  use StackoverflowCloneB.Controller.Application
  # alias StackoverflowCloneB.Controller.Answer.{Helper, ShowRequestBody}
  alias StackoverflowCloneB.Controller.Answer.Helper
  alias StackoverflowCloneB.Error.ResourceNotFoundError

  # def show(%Conn{request: %Request{path_matches: %{id: id}, body: body} = conn) do
  def show(conn) do
    IO.inspect "ANSWER SHOW"
    group_id = StackoverflowCloneB.Dodai.default_group_id()
    id = conn.request.path_matches[:id]
    root_key = StackoverflowCloneB.Dodai.root_key()
    app_id = StackoverflowCloneB.Dodai.app_id()

    # case ShowRequestBody.new(body) do {
    #   {:error, _} -> ErrorJson.json_by_error(conn, BadRequestError.new())
    #   {:ok, _} -> 
    #     data = 
    # }

    request = Dodai.RetrieveDedicatedDataEntityRequest.new(group_id, Helper.collection_name(), id, root_key)
    response = Sazabi.G2gClient.send(conn.context, app_id, request)
    IO.inspect response

    case response do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: resp_body} 
        -> Conn.json(conn, 200, Helper.to_response_body(resp_body))
      %Dodai.ResourceNotFound{} 
        -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
