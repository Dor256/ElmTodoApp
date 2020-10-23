module Searchbar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_, placeholder, class, value)
import Html.Events exposing (onInput, keyCode, on)
import Json.Decode as Json

type alias SearchActions action =
  { onChange: String -> action
  , onEnterPressed: Int -> action
  }

onKeyPress: (Int -> msg) -> Attribute msg 
onKeyPress mapper =
  on "keypress" (Json.map mapper keyCode)

searchbar: SearchActions action -> String -> Html action
searchbar { onChange, onEnterPressed } search = 
  input
    [ 
      type_ "text"
    , onInput onChange
    , onKeyPress onEnterPressed
    , placeholder "Enter todo..."
    , value search
    , class "searchbar"
    ] []