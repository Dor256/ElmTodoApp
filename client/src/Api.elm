module Api exposing (BatchAction, SingleAction, Todo, addTodo, deleteTodos, getTodos, toggleTodoCheck)

import Html.Attributes exposing (action)
import Http exposing (emptyBody, expectJson, get, jsonBody, post, request)
import Json.Decode as Decode exposing (Decoder, bool, field, int, list, string)
import Json.Encode as Encode exposing (Value, bool, list, object, string)


type alias Todo =
    { id : String, isDone : Bool, content : String }


type alias BatchAction item =
    Result Http.Error (List item)


type alias SingleAction item =
    Result Http.Error item


baseUrl : String
baseUrl =
    "http://localhost:3000"


getTodos : (BatchAction Todo -> action) -> Cmd action
getTodos action =
    Http.get
        { url = baseUrl ++ "/todos"
        , expect = Http.expectJson action todoListDecoder
        }


deleteTodos : (BatchAction String -> action) -> List String -> Cmd action
deleteTodos action ids =
    Http.request
        { method = "DELETE"
        , url = baseUrl ++ "/"
        , body = Http.jsonBody (idListEncoder ids)
        , expect = Http.expectJson action idListDecoder
        , headers = []
        , timeout = Nothing
        , tracker = Nothing
        }


addTodo : (SingleAction Todo -> action) -> Todo -> Cmd action
addTodo action todo =
    Http.post
        { body = Http.jsonBody (todoEncoder todo)
        , url = baseUrl ++ "/"
        , expect = Http.expectJson action todoDecoder
        }


toggleTodoCheck : (SingleAction Todo -> action) -> Maybe Todo -> Cmd action
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


todoListDecoder : Decoder (List Todo)
todoListDecoder =
    Decode.list todoDecoder


todoDecoder : Decoder Todo
todoDecoder =
    Decode.map3 Todo
        (field "id" Decode.string)
        (field "isDone" Decode.bool)
        (field "content" Decode.string)


idListDecoder : Decoder (List String)
idListDecoder =
    Decode.list Decode.string


idListEncoder : List String -> Value
idListEncoder ids =
    Encode.list Encode.string ids


todoEncoder : Todo -> Value
todoEncoder todo =
    Encode.object
        [ ( "id", Encode.string todo.id )
        , ( "content", Encode.string todo.content )
        , ( "isDone", Encode.bool todo.isDone )
        ]
