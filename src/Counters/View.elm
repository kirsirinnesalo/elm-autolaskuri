module Counters.View exposing ( viewCounters )

import Html exposing (Html, Attribute, div, fieldset, legend, button, text, span, input)
import Html.Events exposing (onClick, on, targetValue, keyCode, onWithOptions, defaultOptions)
import Html.Attributes exposing (class, placeholder, id)
import Types exposing (Model, CounterId, Counter, editedCounterNameId)
import Actions exposing (..)
import RemoteData exposing (WebData)
import Json.Decode as Json


viewCounters : WebData (List Counter) -> Model -> Html Action
viewCounters response model =
    asHtml response model

asHtml : WebData (List Counter) -> Model -> Html Action
asHtml response model =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Ladataan..."

        RemoteData.Success counters ->
            list counters model

        RemoteData.Failure error ->
            text (toString error)

list : List Counter -> Model -> Html Action
list counters model =
    let
        isOnEdit counterId =
            model.editCounterId == counterId
    in
        div [ class "counters" ]
            ( List.append
                (List.map (\counter -> viewCounter counter (isOnEdit counter.id)) counters)
                [ fieldset [ class "counter add-new-counter" ]
                    [ legend [] [ text "Lisää uusi" ]
                    , button [ onClick CreateCounter ] [ text "+" ]
                    ]
                ]
            )

viewCounter : Counter -> Bool -> Html Action
viewCounter counter isOnEdit =
    fieldset [ class "counter" ]
    [ legend []
        [
        if isOnEdit then
            input
                [ placeholder ( counter.name )
                , onBlurWithValue ( EditName counter )
                , onEnter EnterPressed
                , id editedCounterNameId
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

onBlurWithValue : (String -> Action) -> Attribute Action
onBlurWithValue tagger =
    on "blur" (Json.map tagger targetValue)

onEnter : Action -> Attribute Action
onEnter tagger =
    let
        options = { defaultOptions | preventDefault = True }
        isEnter code =
            if code == 13
                then Json.succeed tagger
                else Json.fail "ignored input"
        decodeEnter =
            Json.andThen isEnter keyCode
    in
        onWithOptions "keydown" options decodeEnter
