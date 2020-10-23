module Header exposing (header)

import Html exposing (..)
import Html.Attributes exposing (class)

header: Html msg
header = 
  h1 [ class "header" ] [ text "Todo List" ]