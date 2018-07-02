module View exposing (view)

import Html exposing (Html, text, div, h1, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Actions exposing (Action, Action(SaveAll))
import Types exposing (Model)
import Counters.View exposing (viewCounters)

view : Model -> Html Action
view model =
    div [ class "main" ]
        [ h1 [ class "caps" ] [ text "Autolaskuri" ]
        , viewCounters model.counters model
        , div [ class "footer" ]
            [ text "2018 © kirsirinnesalo"
            , button [ class "save", onClick SaveAll] [ text "Tallenna" ]
            ]
        ]
