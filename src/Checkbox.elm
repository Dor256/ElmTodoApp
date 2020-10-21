module Checkbox exposing (checkbox)
import Html exposing (..)
import Html.Attributes exposing (style, type_)
import Html.Events exposing (onClick)
import Styles exposing (checkboxContainerStyle)
import Styles exposing (checkboxStyle)

checkbox: msg -> String -> Bool -> Html msg
checkbox msg title isDone =
  div 
    (checkboxContainerStyle isDone)
    [
      input ([ type_ "checkbox", onClick msg ] ++ checkboxStyle) []
    , text title
    ]
