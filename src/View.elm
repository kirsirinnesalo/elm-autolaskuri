module View exposing (..)

import Html exposing (Html, text, button, div, fieldset, legend, span, h1)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Msgs exposing (..)
import Models exposing (Model, Vehicle)
import RemoteData exposing (WebData)

view : Model -> Html Msg
view model =
    div [ class "main" ]
        [
        h1 [] [ text "Autolaskuri" ]
        , viewCounters model.vehicles
        , div [ class "footer" ] [ text "2018 © Kirsi Rinnesalo" ]
        ]

viewCounters : WebData (List Vehicle) -> Html Msg
viewCounters response =
    maybeList response

maybeList : WebData (List Vehicle) -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Ladataan"

        RemoteData.Success vehicles ->
            list vehicles

        RemoteData.Failure error ->
            text (toString error)

list : List Vehicle -> Html Msg
list vehicles =
    div [ class "counters" ]
        (List.map viewVehicle vehicles)

viewVehicle : Vehicle -> Html Msg
viewVehicle vehicle =
    fieldset [ class "counter" ]
    [ legend [] [ text vehicle.name ]
    , button [ onClick (Decrease vehicle.id) ] [ text "-" ]
    , text ( toString vehicle.count )
    , button [ onClick (Increase vehicle.id) ] [ text "+" ]
    , button [ class "reset", onClick (Reset vehicle.id) ] [ text "Reset" ]
    ]

