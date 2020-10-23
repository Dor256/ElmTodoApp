module Checkbox exposing (checkbox)
import Html exposing (..)
import Html.Attributes exposing (style, type_, checked, class, name, for)
import Html.Events exposing (onClick)

checkbox: msg -> String -> Bool -> Html msg
checkbox msg title isDone =
  div 
    [class "checkbox-container"]
    [
      input [ name title, type_ "checkbox", onClick msg, checked isDone, class "checkbox" ] []
    , span [ class "checkmark", onClick msg ] []
    , label [ for title, class "checkbox-label" ] [ text title ]
    ]
