module Main exposing (init, update, view, subscriptions)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style, type_, placeholder, value, class)
import Html.Events exposing (onClick, onInput, on, keyCode)
import Json.Decode as Json
import Header exposing (header)
import Checkbox exposing (checkbox)
import Searchbar exposing (searchbar)
import Api exposing (Todo, getTodos, BatchAction, addTodo, SingleAction, toggleTodoCheck, deleteTodo)
import Http
import Array

main: Program () Model Action
main =
  Browser.element 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view 
    }

type Response
  = Failure
  | Loading
  | Success

type alias Model = 
    { todos: List Todo
    , search: String
    , response: Response
    }


init: () -> (Model, Cmd Action)
init _ =
  ( { todos = []
    , search = ""
    , response = Loading
    }
  ,
    getTodos GotTodos
  )


type Action = 
  Toggle String
  | ChangeText String
  | KeyPress Int
  | ClearAllDone
  | ClearTodo String
  | GotTodos BatchAction
  | AddedTodo SingleAction
  | NoOp SingleAction

enterKey: Int
enterKey = 13

update : Action -> Model -> (Model, Cmd Action)
update msg model =
   case msg of
        Toggle id ->
          ({ model | todos = (List.map (checkItem id) model.todos ) }
          , toggleTodoCheck NoOp (getTodoById model.todos id))

        ChangeText text -> 
          ({ model | search = text }, Cmd.none)

        KeyPress key ->
          if key == enterKey then
            (model
            , addTodo AddedTodo { content = model.search, isDone = False, id = ""}
            )
          else
            (model, Cmd.none)

        ClearAllDone -> 
          ({ model | todos = List.filter (\todo -> not todo.isDone) model.todos }, Cmd.none)

        ClearTodo id -> 
          ({ model | todos = removeTodoById id model.todos }
          , deleteTodo NoOp (getTodoById model.todos id)
          )

        GotTodos (Ok res) ->
          ({ model | todos = res, response = Success }, Cmd.none)

        GotTodos (Err err) ->
          ({ model | response = Failure }, Cmd.none)
        
        AddedTodo (Ok res) -> 
          ({ model | todos = model.todos ++ [{ content = model.search, isDone = False, id = res.id }], search = "" }, Cmd.none)
        
        AddedTodo (Err err) -> 
          (model, Cmd.none)
        
        _ ->
          (model, Cmd.none)


checkItem: String -> Todo -> Todo
checkItem idToCheck todo =
  if idToCheck == todo.id then
    { todo | isDone = not todo.isDone }
  else
    todo

removeTodoById: String -> (List Todo) -> List Todo
removeTodoById id todos = 
  List.filter (\todo -> todo.id /= id) todos

getTodoById: (List Todo) -> String -> Maybe Todo
getTodoById todos id =
  List.head (List.filter (\todo -> todo.id == id) todos)
    

subscriptions: Model -> Sub Action
subscriptions model =
    Sub.none

view: Model -> Html Action
view model =
  case model.response of
    Failure -> 
      text "Something went wrong!"
    Loading ->
      text "Loading..."
    Success ->
      div
        [
          style "margin-left" "25%"
        , style "margin-right" "25%"
        , style "display" "flex"
        , style "flex-direction" "column"
        ]
        [
          header
        , div 
          [
            style "display" "flex"
          , style "justify-content" "flex-end"
          ]
          [
            searchbar { onChange = ChangeText, onEnterPressed = KeyPress } model.search
          , button
              [ onClick ClearAllDone, class "clear-button" ]
              [text "Clear finished"]
          ]
        , div 
            [
              style "display" "flex"
            , style "flex-direction" "column"
            , style "justify-content" "space-between"
            ]
            <| List.map (\todo -> checkbox { toggle = (Toggle todo.id), clear = (ClearTodo todo.id) } todo.content todo.isDone) model.todos
        ]
