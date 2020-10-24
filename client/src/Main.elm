module Main exposing (init, update, view, subscriptions)

import Browser exposing (element)
import Html exposing (Html, div, button, text, main_)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Header exposing (header)
import Checkbox exposing (checkbox)
import Searchbar exposing (searchbar)
import Api exposing (Todo, getTodos, BatchAction, addTodo, SingleAction, toggleTodoCheck, deleteTodos)

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
  | GotTodos (BatchAction Todo)
  | AddedTodo (SingleAction Todo)
  | NoOpTodo (SingleAction Todo)
  | NoOpString (SingleAction (List String))

enterKey: Int
enterKey = 13

update : Action -> Model -> (Model, Cmd Action)
update action model =
   case action of
        Toggle id ->
          ({ model | todos = (List.map (checkItem id) model.todos ) }
          , toggleTodoCheck NoOpTodo (getTodoById model.todos id))

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
          ({ model | todos = List.filter (\todo -> not todo.isDone) model.todos }
          , deleteTodos NoOpString (List.map (\todo -> todo.id) <| List.filter (\todo -> todo.isDone) model.todos))

        ClearTodo id -> 
          ({ model | todos = removeTodoById id model.todos }
          , deleteTodos NoOpString [id]
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

view: Model -> (Html Action)
view model =
  case model.response of
    Failure -> 
      text "Something went wrong!"
    Loading ->
      text "Loading..."
    Success ->
      main_
        [ class "container" ]
        [
          header
        , div 
          [ class "search-container" ]
          [
            searchbar { onChange = ChangeText, onEnterPressed = KeyPress } model.search
          , button
              [ onClick ClearAllDone, class "clear-button" ]
              [text "Clear finished"]
          ]
        , div 
            [ class "checkbox-list" ]
            <| List.map (\todo -> checkbox { toggle = (Toggle todo.id), clear = (ClearTodo todo.id) } todo.content todo.isDone) model.todos
        ]
