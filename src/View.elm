module View exposing (..)

import Html exposing (Html, text, button, div, fieldset, legend, span, h1)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, style)
import Msgs exposing (..)
import Models exposing (Model, Vehicle)


view : Model -> Html Msg
view model =
    div [ class "page", style [ ("margin", "auto"), ("display", "inline-block") ] ]
        [ h1 [ style [ ("text-align", "center") ] ] [ text "Autolaskuri" ]
        , span []
            [ list model.vehicles
            ]
        ]

list : List Vehicle -> Html Msg
list vehicles =
    div [] (List.map viewVehicle vehicles)

viewVehicle : Vehicle -> Html Msg
viewVehicle vehicle =
    fieldset [ class "laskuri", style [ ("text-align", "center"), ("display", "inline-block") ] ]
    [ legend [] [ text vehicle.name ]
    , span [ style [ ("padding", "1em") ] ] [ button [ onClick (Decrement vehicle) ] [ text "-" ] ]
    , text ( toString vehicle.count )
    , span [ style [ ("padding", "1em") ] ] [ button [ onClick (Increment vehicle) ] [ text "+" ] ]
    , div [ style [ ("padding", "1em") ] ] [ button [ onClick (Reset vehicle) ] [ text "Reset" ] ]
    ]

