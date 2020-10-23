module Api exposing (Todo, getTodos, BatchAction, addTodo, SingleAction, toggleTodoCheck, deleteTodo)

import Json.Decode as Decode exposing (field, bool, string, list, int)
import Json.Encode as Encode
import Http
import Html.Attributes exposing (action)

type alias Todo =
  { id: String, isDone: Bool, content: String }

type alias BatchAction = (Result Http.Error (List Todo))
type alias SingleAction = (Result Http.Error Todo)

baseUrl: String
baseUrl = 
  "http://localhost:3000"

getTodos: (BatchAction -> action) -> Cmd action
getTodos action = 
  Http.get
    { url = baseUrl ++ "/todos"
    , expect = Http.expectJson action todoListDecoder
    }

addTodo: (SingleAction -> action) -> Todo -> Cmd action
addTodo action todo =
  Http.post
    { body = Http.jsonBody (todoEncoder todo)
    , url = baseUrl ++ "/"
    , expect = Http.expectJson action todoDecoder
    }

toggleTodoCheck: (SingleAction -> action) -> Maybe Todo -> Cmd action
toggleTodoCheck action todo =
  case todo of
    Just aTodo ->
      Http.request
        { method = "PUT"
        , url = baseUrl ++ "/"
        , body = Http.jsonBody (todoEncoder aTodo)
        , expect = Http.expectJson action todoDecoder
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        }
    Nothing ->
      Cmd.none

deleteTodo: (SingleAction -> action) -> Maybe Todo -> Cmd action
deleteTodo action todo =
  case todo of
    Just aTodo ->
      Http.request
        { method = "DELETE"
        , url = baseUrl ++ "/" ++ aTodo.id
        , body = Http.emptyBody
        , expect = Http.expectJson action todoDecoder
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        }
    Nothing ->
      Cmd.none

todoListDecoder: Decode.Decoder (List Todo)
todoListDecoder =
  list todoDecoder

todoDecoder: Decode.Decoder Todo
todoDecoder = 
  Decode.map3 Todo
    (field "id" string)
    (field "isDone" bool)
    (field "content" string)

todoEncoder: Todo -> Encode.Value
todoEncoder todo =
  Encode.object
    [ ("id", Encode.string todo.id)
    , ("content", Encode.string todo.content)
    , ("isDone", Encode.bool todo.isDone)
    ]