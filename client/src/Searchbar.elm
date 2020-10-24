module Searchbar exposing (searchbar)

import Html exposing (Attribute, Html, input)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Json


type alias SearchActions action =
    { onChange : String -> action
    , onEnterPressed : Int -> action
    }


onKeyPress : (Int -> msg) -> Attribute msg
onKeyPress mapper =
    on "keypress" (Json.map mapper keyCode)


searchbar : SearchActions action -> String -> Html action
searchbar { onChange, onEnterPressed } search =
    input
        [ type_ "text"
        , onInput onChange
        , onKeyPress onEnterPressed
        , placeholder "Enter todo..."
        , value search
        , class "searchbar"
        ]
        []
