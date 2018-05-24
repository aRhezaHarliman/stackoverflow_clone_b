use Croma

defmodule StackoverflowCloneB.Controller.Answer.Count do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Controller.Answer.{Helper, IndexRequestParams}
  alias StackoverflowCloneB.Error.BadRequestError

  defun count(%Conn{request: %Request{query_params: query_params}} = conn :: v[Conn.t]) :: Conn.t do

    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        group_id = StackoverflowCloneB.Dodai.default_group_id()
        root_key = StackoverflowCloneB.Dodai.root_key()
        app_id = StackoverflowCloneB.Dodai.app_id()
        query = convert_to_dodai_req_query(validated)
        request = Dodai.CountDedicatedDataEntitiesRequest.new(group_id, Helper.collection_name(), root_key, query)
        response = G2gClient.send(conn.context, app_id, request)
    
        case response do
          %Dodai.CountDedicatedDataEntitiesSuccess{body: resp_body} 
            -> Conn.json(conn, 200, resp_body)
          %Dodai.OperationNotPermitted{} 
            -> ErrorJson.json_by_error(conn, Dodai.OperationNotPermitted.new())
        end
    end
  end

  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t]) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    query = Map.from_struct(params)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()
    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
    }
  end
end
  