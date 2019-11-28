import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Debug exposing (..)

main = Browser.sandbox{ init = init, update = update, view = view }

type alias Todo = {
        content: String,
        done: Bool
    }

type alias Model = {
        content: String,
        todos: List Todo
    }

init: Model
init = { content = "", todos = [] }

type Msg = Change String | Click

update: Msg -> Model -> Model

update msg model = 
    case msg of
        Change newContent -> { model | content = newContent }
        Click -> { model | todos = model.todos ++ (List.singleton { content = model.content, done = False })}


todoBoxStyles = [style "display" "flex", style "flex-direction" "column"]

view: Model -> Html Msg

view model = 
    div[]
        [
            h1[] [text "Todo List"],
            div[]
                [
                    input[placeholder "insert", value model.content, style "margin-bottom" "1%", onInput Change] [],
                    button[onClick Click] [text "Go"],
                    div todoBoxStyles (mapTodos model.todos)
                ]
        ]

mapTodos: List Todo -> List (Html Msg)

mapTodos todos = 
    List.map stringToCheckbox todos

stringToCheckbox: Todo -> Html Msg

stringToCheckbox todo = 
    label [] [input[type_ "checkbox"] [], text (" " ++ todo.content)]
