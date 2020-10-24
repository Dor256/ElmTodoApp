module Test.Generated.Main1413879238 exposing (main)

import MainTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainTest" [MainTest.checkTodosTest,
    MainTest.deleteTodosTest] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 205545492623566, processes = 12, globs = [], paths = ["/Users/dor/Workspace/ElmTodos/client/tests/MainTest.elm"]}