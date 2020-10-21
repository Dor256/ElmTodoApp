module Main exposing (Model, Action(..), checkbox, init, main, update, view)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style, type_)
import Html.Events exposing (onClick)
import Array exposing (fromList, get)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Todo =
  { isDone: Bool, content: String }

type alias Model =
    { todos: List Todo }


init : Model
init =
    Model 
      [
        { isDone = False, content = "Order food" }
      , { isDone = False, content = "Take out the trash" }
      , { isDone = False, content = "Play among us" }
      ]


type Action = 
  Toggle Int


update : Action -> Model -> Model
update msg model =
    case msg of
        Toggle index ->
            { model | todos = (List.indexedMap (checkItem index) model.todos ) }


checkItem: Int -> Int -> Todo -> Todo
checkItem indexToCheck index todo =
  if indexToCheck == index then
    { todo | isDone = not todo.isDone }
  else
    todo


view : Model -> Html Action
view model =
    div [
          style "display" "flex"
        , style "flex-direction" "column"
        ]
        <| List.indexedMap (\i todo -> checkbox (Toggle i) todo.content todo.isDone) model.todos
