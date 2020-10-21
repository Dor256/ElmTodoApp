module Main exposing (Model, Action(..), init, update, view)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style, type_)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json
import Header exposing (header)
import Checkbox exposing (checkbox)
import Styles exposing (searchBarStyle, buttonStyle)
import Html.Attributes exposing (placeholder, value)

main: Program () Model Action
main =
  Browser.sandbox { init = init, update = update, view = view }


type alias Todo =
  { isDone: Bool, content: String }

type alias Model =
  { 
    todos: List Todo 
  , search: String
  }


init: Model
init =
  { 
    todos = []
  , search = ""
  }


type Action = 
  Toggle Int
  | ChangeText String
  | KeyPress Int
  | Clear


onKeyPress: (Int -> msg) -> Attribute msg 
onKeyPress mapper =
  on "keypress" (Json.map mapper keyCode)

update : Action -> Model -> Model
update msg model =
   case msg of
        Toggle index ->
            { model | todos = (List.indexedMap (checkItem index) model.todos ) }
        ChangeText text -> 
            { model | search = text }
        KeyPress key ->
          if key == 13 then 
            { model | todos = model.todos ++ [{ content = model.search, isDone = False }], search = "" }
          else
            model
        Clear -> { model | todos = List.filter (\todo -> not todo.isDone) model.todos }


checkItem: Int -> Int -> Todo -> Todo
checkItem indexToCheck index todo =
  if indexToCheck == index then
    { todo | isDone = not todo.isDone }
  else
    todo

view : Model -> Html Action
view model =
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
          ([ 
            type_ "text"
          , onInput ChangeText
          , onKeyPress KeyPress
          , placeholder "Enter todo..."
          , value model.search
          ] ++ searchBarStyle)
          []
      , button
          ([
            onClick Clear
          ] ++ buttonStyle)
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
