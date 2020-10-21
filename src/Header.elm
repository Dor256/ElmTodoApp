module Header exposing (header)

import Html exposing (..)
import Html.Attributes exposing (style, type_)

header: Html msg
header = 
  h1
    [
      style "text-transform" "uppercase"
    , style "text-align" "center"
    ]
    [ text "Todo List" ]