module Styles exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style)

type alias Style msg = List (Attribute msg)


searchBarStyle: Style msg
searchBarStyle = 
  [
    style "align-self" "center"
  , style "width" "50%"
  , style "padding" "10px 20px"
  , style "border" "1px solid #fff"
  , style "border-radius" "5px"
  , style "box-shadow" "0 2px 6px 1px #e1e5e8"
  , style "color" "#20455e"
  , style "font-weight" "600"
  , style "outline" "0"
  , style "margin-bottom" "10%"
  ]

checkboxContainerStyle: Bool -> Style msg
checkboxContainerStyle checked =
  [
    style "display" "flex"
  , style "text-decoration" (if checked then "line-through" else "none")
  ]

checkboxStyle: Style msg
checkboxStyle =
  [
    style "margin-bottom" "3%"
  , style "cursor" "pointer"
  ]

buttonStyle: Style msg
buttonStyle =
  [
    style "margin-left" "10%"
  , style "background" "none"
  , style "border" "none"
  , style "cursor" "pointer"
  , style "outline" "none"
  , style "color" "blue"
  , style "text-decoration" "underline"
  , style "align-self" "flex-start"
  ]