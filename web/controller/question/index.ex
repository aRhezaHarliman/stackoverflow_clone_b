use Croma

defmodule StackoverflowCloneB.Controller.Question.IndexRequestParams do
  use Croma.Struct, fields: [
    user_id: Croma.TypeGen.nilable(Croma.String),
    title: Croma.TypeGen.nilable(Croma.String),
    body: Croma.TypeGen.nilable(Croma.String),
  ]
end

defmodule StackoverflowCloneB.Controller.Question.Index do
  use StackoverflowCloneB.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneB.Dodai, as: SD
  alias StackoverflowCloneB.Error.BadRequestError
  alias StackoverflowCloneB.Controller.Question.{Helper, IndexRequestParams}

  defun index(%Conn{request: %Request{query_params: query_params}, context: context} = conn :: v[Conn.t]) :: Conn.t do
    #IO.inspect query_params["page"]

    case IndexRequestParams.new(query_params) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        #IO.inspect query_params #> [title: "\"こんにちは\""]
        request_header = conn.request.headers
        query = if Map.has_key?(request_header, "page") do
          number_of_page = String.to_integer(conn.request.headers["page"])
          convert_to_dodai_req_query(validated, number_of_page) # Pagination TODO
        else
          convert_to_dodai_req_query(validated)
        end
        # query = convert_to_dodai_req_query(validated)
        #data.title:"xxx"
        #IO.inspect query #>%Dodai.RetrieveDedicatedDataEntityListRequestQuery{limit: nil, query: %{"data.title" => "\"こんにちは\""}, skip: nil,sort: %{"_id" => 1}}
        req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
        %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
    end
  end
  #Dodai上に渡すためにqueryの形を変換[title:"xxx"]->[data.title:"xxx"]
  # defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t], page) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do #Pagination todo
  def convert_to_dodai_req_query(validated) do
    convert_to_dodai_req_query(validated, 0)
  end

  defunpt convert_to_dodai_req_query(params :: v[IndexRequestParams.t], page) :: Dodai.RetrieveDedicatedDataEntityListRequestQuery.t do
    #IO.inspect params #>%StackoverflowCloneB.Controller.Question.IndexRequestParams{author: nil, title: "\"こんにちは\""}
    #IO.inspect Map.from_struct(params) #>%{author: nil, title: "\"こんにちは\""} #一旦マップに戻す
    #IO.inspect(Map.from_struct(params)|> Enum.reject(fn {_, value} -> is_nil(value) end)) #>[title: "\"こんにちは\""]　
    query = Map.from_struct(params)
    #nilを除外する(指定していない値がNULLになるのを回避するため)
    |> Enum.reject(fn {_, value} -> is_nil(value) end)
    #[title: "\"こんにちは\""] >[data.title,"こんにちは"]
    |> Enum.map(fn {k, v} -> {"data.#{k}", v} end)
    |> Map.new()

    limit = if page > 0 do
       10
      else
       1000
    end
    page = if page > 0 do
        (page - 1) * 10
      else
        0
    end

    %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
      query: query,
      sort:  %{"createdAt" => -1},
      limit: limit,
      skip: page,
    }
  end
end
