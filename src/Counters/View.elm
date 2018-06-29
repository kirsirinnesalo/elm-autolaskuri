module Counters.View exposing (..)

import Html exposing (Html, Attribute, div, fieldset, legend, button, text, span, input)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (class, placeholder, id)
import Models exposing (Model, CounterId, Counter)
import Msgs exposing (..)
import RemoteData exposing (WebData)
import Json.Decode as Json

viewCounters : WebData (List Counter) -> Model -> Html Msg
viewCounters response model =
    maybeList response model

maybeList : WebData (List Counter) -> Model -> Html Msg
maybeList response model =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Ladataan"

        RemoteData.Success counters ->
            list counters model

        RemoteData.Failure error ->
            text (toString error)

list : List Counter -> Model -> Html Msg
list counters model =
    div [ class "counters" ]
        (List.map (viewCounter model.editCounterId) counters)

viewCounter : CounterId -> Counter -> Html Msg
viewCounter editCounterId counter =
    fieldset [ class "counter" ]
    [ legend []
        [
        if editCounterId == counter.id then
            input
                [ placeholder ( counter.name )
                , onBlurWithValue ( EditName counter )
                , id "editCounterName"
                ]
                []
        else
            span [ onClick (EnableEditing counter)]
                [ text counter.name ]
        ]
    , button [ class "count", onClick (Decrease counter) ] [ text "-" ]
    , text ( toString counter.count )
    , button [ class "count", onClick (Increase counter) ] [ text "+" ]
    , button [ class "reset", onClick (Reset counter.id) ] [ text "Nollaa" ]
    , button [ class "delete", onClick (Delete counter.id) ] [ text "x" ]
    ]

onBlurWithValue : (String -> Msg) -> Attribute Msg
onBlurWithValue value =
    on "blur" (Json.map value targetValue)
