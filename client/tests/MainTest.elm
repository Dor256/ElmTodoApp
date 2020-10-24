module MainTest exposing (checkTodosTest, deleteDoneTodosTest, deleteTodoTest)

import Api exposing (Todo)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (checkItem, deleteFinishedTodos, removeTodoById)
import Test exposing (..)


mockTodo : String -> Todo
mockTodo id =
    { content = "", isDone = False, id = id }


mockTodoList : String -> String -> List Todo
mockTodoList firstId secondId =
    [ { content = "one", isDone = False, id = firstId }
    , { content = "one", isDone = True, id = secondId }
    ]


checkTodosTest : Test
checkTodosTest =
    describe "Check todo"
        [ test "returns the checked todo"
            (\_ -> mockTodo "id" |> checkItem "id" |> Expect.equal { content = "", isDone = True, id = "id" })
        , test "returns same todo when ids do not match"
            (\_ -> mockTodo "someId" |> checkItem "id" |> Expect.equal (mockTodo "someId"))
        ]


deleteTodoTest : Test
deleteTodoTest =
    describe "Delete todo"
        [ test "removes the todo from the list"
            (\_ -> mockTodoList "id1" "id2" |> removeTodoById "id2" |> List.length |> Expect.equal 1)
        , test "returns the same list for wrong id"
            (\_ -> mockTodoList "id1" "id2" |> removeTodoById "id3" |> List.length |> Expect.equal 2)
        ]


deleteDoneTodosTest : Test
deleteDoneTodosTest =
    describe "Delete finished todos"
        [ test "removes all finished todos"
            (\_ -> mockTodoList "id1" "id2" |> deleteFinishedTodos |> List.all (\todo -> not todo.isDone) |> Expect.equal True)
        ]
