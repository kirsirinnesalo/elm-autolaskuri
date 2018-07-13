module Counters.View exposing ( viewCounters )

import Html exposing (Html, Attribute, div, fieldset, legend, button, text, span, input)
import Html.Events exposing (onClick, on, targetValue, keyCode, onWithOptions, defaultOptions, Options)
import Html.Attributes exposing (class, placeholder, id, style, attribute)
import RemoteData exposing (WebData)
import Json.Decode as Json

import Types exposing (Model, Counter, editingCounterNameId)
import Actions exposing (..)
import Utils exposing ((=>))

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
        view counter =
            let
                isOnEdit =
                    case model.editId of
                        Nothing -> False
                        Just editId ->
                            editId == counter.id
            in
                viewCounter counter isOnEdit
    in
        div [ class "counters" ]
            ( List.append
                (List.map view counters)
                [ fieldset [ class "counter add-new-counter" ]
                    [ legend [] [ text "Lisää uusi" ]
                    , button [ onClick CreateCounter ] [ text "+" ]
                    ]
                ]
            )

viewCounter : Counter -> Bool -> Html Action
viewCounter counter isOnEdit =
    fieldset
        [ class "counter"
        , attribute "draggable" "true"
        , attribute "ondragover" "return false"
        , onDragStart (Move counter)
        , onDrop <| DropOn counter
        , style
            [ "cursor" => "move"
            ]
        ]
        [ legend []
            [
            if isOnEdit then
                input
                    [ placeholder ( counter.name )
                    , onBlurWithValue ( ChangeName counter )
                    , onEnter EnterPressed
                    , onDrop (DropOn counter)
                    , id editingCounterNameId
                    ]
                    []
            else
                span [ onClick (EnableNameEditing counter)]
                    [ text counter.name ]
            ]
        , button [ class "count", onClick (Decrease counter) ] [ text "-" ]
        , text ( toString counter.count )
        , button [ class "count", onClick (Increase counter) ] [ text "+" ]
        , button [ class "reset", onClick (Reset counter) ] [ text "Nollaa" ]
        , button [ class "delete", onClick (Delete counter) ] [ text "x" ]
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

onDragStart : msg -> Attribute msg
onDragStart msg =
    on "dragstart" (Json.succeed msg)

onDrop : msg -> Attribute msg
onDrop msg =
    onWithOptions
        "drop"
        preventDefaultAndStopPropagation
        (Json.succeed msg)

preventDefaultAndStopPropagation : Options
preventDefaultAndStopPropagation =
    Options True True
