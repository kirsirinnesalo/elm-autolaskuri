module Commands
    exposing
        ( focusOnEditCounterCommand
        , fetchCountersCommand
        , saveCounterCommand
        , createNewCounterCommand
        , deleteCounterCommand
        , saveAllCommand
        )

import Http
import Json.Decode as Decode exposing (Decoder, list, string, int)
import Json.Decode.Pipeline exposing (decode, required)
import Actions exposing (..)
import Types exposing (Model, Counter, CounterId, editedCounterNameId)
import RemoteData exposing (sendRequest, WebData, toMaybe, fromList, RemoteData)
import Json.Encode as Encode
import Task exposing (attempt)
import Dom exposing (focus, blur)


apiUrl : String
apiUrl =
    "http://localhost:4000/counters"

apiUrlForCounter : CounterId -> String
apiUrlForCounter id =
    apiUrl ++ "/" ++ (toString id)

focusOnEditCounterCommand : Cmd Action
focusOnEditCounterCommand =
    Task.attempt (\_ -> NoOp) (Dom.focus "editCounterName")

fetchCountersCommand : Cmd Action
fetchCountersCommand =
    fetchCounters
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchCounters

fetchCounters : Http.Request (List Counter)
fetchCounters =
    Http.get apiUrl countersDecoder

countersDecoder : Decoder (List Counter)
countersDecoder =
    list counterDecoder

counterDecoder : Decoder Counter
counterDecoder =
    decode Counter
        |> required "id" int
        |> required "name" string
        |> required "count" int

saveCounterCommand : Counter -> Cmd Action
saveCounterCommand counter =
    saveCounterRequest ( Debug.log "saving counter" counter )
        |> Http.send CounterSaved

saveCounterRequest : Counter -> Http.Request Counter
saveCounterRequest counter =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = apiUrlForCounter counter.id
        , body = counterEncoder counter |> Http.jsonBody
        , expect = Http.expectJson counterDecoder
        , timeout = Nothing
        , withCredentials = False
        }

counterEncoder : Counter -> Encode.Value
counterEncoder counter =
    let
        attributes =
            [ ( "id", Encode.int counter.id )
            , ( "name", Encode.string counter.name )
            , ( "count", Encode.int counter.count )
            ]
    in
        Encode.object attributes

createNewCounterCommand : Counter -> Cmd Action
createNewCounterCommand counter =
    createCounterRequest ( Debug.log "counter created" counter )
        |> Http.send CounterCreated

createCounterRequest : Counter -> Http.Request Counter
createCounterRequest counter =
    Http.request
        { method = "POST"
        , headers = []
        , url = apiUrl
        , body = Http.jsonBody (newCounterEncoder counter)
        , expect = Http.expectJson counterDecoder
        , timeout = Nothing
        , withCredentials = False
        }

newCounterEncoder : Counter -> Encode.Value
newCounterEncoder counter =
    Encode.object
        [ ( "name", Encode.string counter.name )
        , ( "count", Encode.int counter.count )
        ]

deleteCounterCommand : CounterId -> Cmd Action
deleteCounterCommand counterId =
    deleteCounterRequest (Debug.log "counter deleted" counterId)
        |> Http.send CounterDeleted

deleteCounterRequest : CounterId -> Http.Request String
deleteCounterRequest counterId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = apiUrlForCounter counterId
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

saveAllCommand : List Counter -> Cmd Action
saveAllCommand counters =
    let
        saveCounter counter =
            saveCounterRequest ( Debug.log "saving counter" counter )
                |> Http.toTask
        countersAsTasks counters =
            List.map Task.succeed counters
        saveCounters counters =
            List.map ( Task.andThen saveCounter ) (countersAsTasks counters)
    in
        saveCounters (Debug.log "saving all counters" counters)
            |> Task.sequence
            |> Task.attempt AllSaved

