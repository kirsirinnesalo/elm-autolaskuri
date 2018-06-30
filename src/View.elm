module View exposing (view)

import Html exposing (Html, text, div, h1)
import Html.Attributes exposing (class)
import Actions exposing (Action)
import Types exposing (Model)
import Counters.View exposing (viewCounters)

view : Model -> Html Action
view model =
    div [ class "main" ]
        [ h1 [ class "caps" ] [ text "Autolaskuri" ]
        , viewCounters model.counters model
        , div [ class "footer" ] [ text "2018 © kirsirinnesalo" ]
        ]
