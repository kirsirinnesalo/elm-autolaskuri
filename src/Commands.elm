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
import Json.Decode exposing (Decoder, list, string, int)
import Json.Decode.Pipeline exposing (decode, required, optional)
import RemoteData exposing (sendRequest)
import Json.Encode as Encode
import Task
import Dom exposing (focus)

import Actions exposing (..)
import Types exposing (Counter, CounterId)


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
    Http.get (apiUrl ++ "?_sort=ordno") countersDecoder

countersDecoder : Decoder (List Counter)
countersDecoder =
    list counterDecoder

counterDecoder : Decoder Counter
counterDecoder =
    decode Counter
        |> required "id" int
        |> required "name" string
        |> required "count" int
        |> optional "ordno" int 0

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
            , ( "ordno", Encode.int counter.ordno )
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

deleteCounterCommand : Counter -> Cmd Action
deleteCounterCommand counter =
    deleteCounterRequest (Debug.log "counter deleted" counter)
        |> Http.send CounterDeleted

deleteCounterRequest : Counter -> Http.Request String
deleteCounterRequest counter =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = apiUrlForCounter counter.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

saveAllCommand : List Counter -> Cmd Action
saveAllCommand counters =
    let
        _ = Debug.log "saving all counters" counters

        counterTasks =
            List.map Task.succeed counters

        saveCounter counter =
            saveCounterRequest ( Debug.log "saving counter" counter )
                |> Http.toTask

        saveCounters =
            List.map ( Task.andThen saveCounter ) counterTasks
    in
        saveCounters
            |> Task.sequence
            |> Task.attempt AllSaved

