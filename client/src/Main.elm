module Main exposing (init, update, view, subscriptions)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style, type_, placeholder, value, class)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json
import Header exposing (header)
import Checkbox exposing (checkbox)
import Api exposing (Todo, getTodos)
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
  | Clear
  | GotTodos (Result Http.Error (List Todo))


onKeyPress: (Int -> msg) -> Attribute msg 
onKeyPress mapper =
  on "keypress" (Json.map mapper keyCode)

update : Action -> Model -> (Model, Cmd Action)
update msg model =
   case msg of
        Toggle index ->
            ({ model | todos = (List.indexedMap (checkItem index) model.todos ) }, Cmd.none)
        ChangeText text -> 
            ({ model | search = text }, Cmd.none)
        KeyPress key ->
          if key == 13 then 
            ({ model | todos = model.todos ++ [{ content = model.search, isDone = False }], search = "" }, Cmd.none)
          else
            (model, Cmd.none)
        Clear -> 
          ({ model | todos = List.filter (\todo -> not todo.isDone) model.todos }, Cmd.none)
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
              [ onClick Clear, class "clear-button" ]
              [text "Clear finished"]
          ]
        , div 
            [
              style "display" "flex"
            , style "flex-direction" "column"
            , style "justify-content" "space-between"
            ]
            <| List.indexedMap (\i todo -> checkbox (Toggle i) todo.content todo.isDone) model.todos
        ]
