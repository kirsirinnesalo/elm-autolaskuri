module View exposing (view)

import Html exposing (Html, text, div, h1, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msgs exposing (..)
import Models exposing (Model)
import Counters.View exposing (viewCounters)

view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ div [ class "nav" ]
            [ button [ onClick SaveState ] [ text "Tallenna" ]
            , button [ onClick CreateCounter ] [ text "Uusi laskuri" ]
            ]
        , h1 [] [ text "Autolaskuri" ]
        , viewCounters model.counters model
        , div [ class "footer" ]
            [ text "2018 © Kirsi Rinnesalo" ]
        ]
