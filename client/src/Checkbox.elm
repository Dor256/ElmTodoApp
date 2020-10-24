module Checkbox exposing (checkbox)
import Html exposing (Html, div, input, span, label, text)
import Html.Attributes exposing (type_, checked, class, name, for)
import Html.Events exposing (onClick)

type alias CheckboxActions action =
  { toggle: action
  , clear: action
  }

checkbox: CheckboxActions action -> String -> Bool -> Html action
checkbox { toggle, clear } title isDone =
  div 
    [class "todo-container"]
    [
      div 
      [ class "checkbox-container" ]
      [
        input [ name title, type_ "checkbox", checked isDone, class "checkbox" ] []
      , span [ class "checkmark", onClick toggle ] []
      , label [ for title, class "checkbox-label" ] [ text title ]
      , span [ onClick clear, class "trash" ] [ text "🗑️" ]
      ]
    ]
