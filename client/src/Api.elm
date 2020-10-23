module Api exposing (Todo, getTodos, ApiAction)

import Json.Decode as Json exposing (field, bool, string, list)
import Http

type alias Todo =
  { isDone: Bool, content: String }

type alias ApiAction = (Result Http.Error (List Todo))

baseUrl: String
baseUrl = 
  "http://localhost:3000"

getTodos: (ApiAction -> action) -> Cmd action
getTodos action = 
  Http.get
    { url = baseUrl ++ "/todos"
    , expect = Http.expectJson action todoListDecoder
    }

todoListDecoder: Json.Decoder (List Todo)
todoListDecoder =
  list todoDecoder

todoDecoder: Json.Decoder Todo
todoDecoder = 
  Json.map2 Todo
    (field "isDone" bool)
    (field "content" string)