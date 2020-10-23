module Main exposing (init, update, view, subscriptions)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style, type_, placeholder, value, class)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json
import Header exposing (header)
import Checkbox exposing (checkbox)
import Api exposing (Todo, getTodos, ApiAction)
import Http

main: Program () Model Action
main =
  Browser.element 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view 
    }

type Response
  = Failure
  | Loading
  | Success

type alias Model = 
    { todos: List Todo
    , search: String
    , response: Response
    }


init: () -> (Model, Cmd Action)
init _ =
  ( { todos = []
    , search = ""
    , response = Loading
    }
  ,
    getTodos GotTodos
  )


type Action = 
  Toggle Int
  | ChangeText String
  | KeyPress Int
  | ClearAllDone
  | ClearTodo Int
  | GotTodos ApiAction


onKeyPress: (Int -> msg) -> Attribute msg 
onKeyPress mapper =
  on "keypress" (Json.map mapper keyCode)

enterKey: Int
enterKey = 13

update : Action -> Model -> (Model, Cmd Action)
update msg model =
   case msg of
        Toggle index ->
          ({ model | todos = (List.indexedMap (checkItem index) model.todos ) }, Cmd.none)

        ChangeText text -> 
          ({ model | search = text }, Cmd.none)

        KeyPress key ->
          if key == enterKey then 
            ({ model | todos = model.todos ++ [{ content = model.search, isDone = False }], search = "" }, Cmd.none)
          else
            (model, Cmd.none)

        ClearAllDone -> 
          ({ model | todos = List.filter (\todo -> not todo.isDone) model.todos }, Cmd.none)

        ClearTodo index -> 
          ({ model | todos = removeTodoByIndex index model.todos }, Cmd.none)

        GotTodos (Ok res) ->
            ({ model | todos = res, response = Success }, Cmd.none)

        GotTodos (Err err) ->
          ({ model | response = Failure }, Cmd.none)



checkItem: Int -> Int -> Todo -> Todo
checkItem indexToCheck index todo =
  if indexToCheck == index then
    { todo | isDone = not todo.isDone }
  else
    todo

removeTodoByIndex: Int -> (List Todo) -> List Todo
removeTodoByIndex index todos = 
  (List.take index todos) ++ (List.drop (index + 1) todos)

subscriptions: Model -> Sub Action
subscriptions model =
    Sub.none

view: Model -> Html Action
view model =
  case model.response of
    Failure -> 
      text "Something went wrong!"
    Loading ->
      text "Loading..."
    Success ->
      div
        [
          style "margin-left" "25%"
        , style "margin-right" "25%"
        , style "display" "flex"
        , style "flex-direction" "column"
        ]
        [
          header
        , div 
          [
            style "display" "flex"
          , style "justify-content" "flex-end"
          ]
          [
            input
              [ 
                type_ "text"
              , onInput ChangeText
              , onKeyPress KeyPress
              , placeholder "Enter todo..."
              , value model.search
              , class "searchbar"
              ]
              []
          , button
              [ onClick ClearAllDone, class "clear-button" ]
              [text "Clear finished"]
          ]
        , div 
            [
              style "display" "flex"
            , style "flex-direction" "column"
            , style "justify-content" "space-between"
            ]
            <| List.indexedMap (\i todo -> checkbox { toggle = (Toggle i), clear = (ClearTodo i) } todo.content todo.isDone) model.todos
        ]
