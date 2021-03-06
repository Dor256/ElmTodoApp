module Main exposing (Model, checkItem, deleteFinishedTodos, init, removeTodoById, subscriptions, update, view)

import Api exposing (BatchAction, SingleAction, Todo, addTodo, deleteTodos, getTodos, toggleTodoCheck)
import Browser exposing (element)
import Checkbox exposing (checkbox)
import Header exposing (header)
import Html exposing (Html, button, div, main_, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http exposing (Error(..))
import Searchbar exposing (searchbar)


main : Program () Model Action
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Response
    = Failure String
    | Loading
    | Success


type alias Model =
    { todos : List Todo
    , search : String
    , response : Response
    }


init : () -> ( Model, Cmd Action )
init _ =
    ( { todos = []
      , search = ""
      , response = Loading
      }
    , getTodos GotTodos
    )


type Action
    = Toggle String
    | ChangeText String
    | KeyPress Int
    | ClearAllDone
    | ClearTodo String
    | GotTodos (BatchAction Todo)
    | AddedTodo (SingleAction Todo)
    | NoOpTodo (SingleAction Todo)
    | NoOpString (SingleAction (List String))


enterKey : Int
enterKey =
    13


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        Toggle id ->
            ( { model | todos = List.map (checkItem id) model.todos }
            , toggleTodoCheck NoOpTodo (getTodoById model.todos id)
            )

        ChangeText text ->
            ( { model | search = text }, Cmd.none )

        KeyPress key ->
            if key == enterKey then
                ( model
                , addTodo AddedTodo { content = model.search, isDone = False, id = "" }
                )

            else
                ( model, Cmd.none )

        ClearAllDone ->
            ( { model | todos = deleteFinishedTodos model.todos }
            , deleteTodos NoOpString (List.map (\todo -> todo.id) <| List.filter (\todo -> todo.isDone) model.todos)
            )

        ClearTodo id ->
            ( { model | todos = removeTodoById id model.todos }
            , deleteTodos NoOpString [ id ]
            )

        GotTodos (Ok res) ->
            ( { model | todos = res, response = Success }, Cmd.none )

        GotTodos (Err err) ->
            ( { model | response = Failure (errorToString err) }, Cmd.none )

        AddedTodo (Ok res) ->
            ( { model | todos = model.todos ++ [ { content = model.search, isDone = False, id = res.id } ], search = "" }, Cmd.none )

        AddedTodo (Err err) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


checkItem : String -> Todo -> Todo
checkItem idToCheck todo =
    if idToCheck == todo.id then
        { todo | isDone = not todo.isDone }

    else
        todo


removeTodoById : String -> List Todo -> List Todo
removeTodoById id todos =
    List.filter (\todo -> todo.id /= id) todos


deleteFinishedTodos : List Todo -> List Todo
deleteFinishedTodos todos =
    List.filter (\todo -> not todo.isDone) todos


getTodoById : List Todo -> String -> Maybe Todo
getTodoById todos id =
    List.head (List.filter (\todo -> todo.id == id) todos)


errorToString : Http.Error -> String
errorToString err =
    case err of
        BadUrl url ->
            "Invalid URL" ++ url

        Timeout ->
            "Request to the server timed out, try again"

        NetworkError ->
            "Network error, check your connection and try again"

        BadStatus 500 ->
            "Internal server error"

        BadStatus 404 ->
            "We couldn't find what you were looking for, please try again"

        BadStatus _ ->
            "There was an unknown error"

        BadBody message ->
            message


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


view : Model -> Html Action
view model =
    case model.response of
        Failure err ->
            text err

        Loading ->
            text "Loading..."

        Success ->
            main_
                [ class "container" ]
                [ header
                , div
                    [ class "search-container" ]
                    [ searchbar { onChange = ChangeText, onEnterPressed = KeyPress } model.search
                    , button
                        [ onClick ClearAllDone, class "clear-button" ]
                        [ text "Clear finished" ]
                    ]
                , div
                    [ class "checkbox-list" ]
                  <|
                    List.map (\todo -> checkbox { toggle = Toggle todo.id, clear = ClearTodo todo.id } todo.content todo.isDone) model.todos
                ]
