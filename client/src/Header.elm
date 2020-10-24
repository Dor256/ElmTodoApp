module Header exposing (header)

import Html exposing (Html, h1, text)
import Html.Attributes exposing (class)


header : Html msg
header =
    h1 [ class "header" ] [ text "Todo List" ]
