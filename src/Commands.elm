module Commands
    exposing
        ( focusOnEditCounterCommand
        , fetchCountersCommand
        , saveCounterCommand
        , createNewCounterCommand
        , deleteCounterCommand
        )

import Http
import Json.Decode as Decode exposing (Decoder, list, string, int)
import Json.Decode.Pipeline exposing (decode, required)
import Actions exposing (..)
import Types exposing (Counter, CounterId, editedCounterNameId)
import RemoteData exposing (sendRequest)
import Json.Encode as Encode
import Task exposing (attempt)
import Dom exposing (focus, blur)


apiUrl : String
apiUrl =
    "http://localhost:4000/counters"

focusOnEditCounterCommand : Cmd Action
focusOnEditCounterCommand =
    Task.attempt (\_ -> NoOp) (Dom.focus "editCounterName")

fetchCountersCommand : Cmd Action
fetchCountersCommand =
    fetchApi
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchCounters

fetchApi : Http.Request (List Counter)
fetchApi =
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
    saveCounterRequest counter
        |> Http.send OnCounterSave

saveCounterUrl : CounterId -> String
saveCounterUrl id =
    apiUrl ++ "/" ++ (toString id)

saveCounterRequest : Counter -> Http.Request Counter
saveCounterRequest counter =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = saveCounterUrl counter.id
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
    createCounterRequest counter
        |> Debug.log "counter created" Http.send CounterCreated

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
    deleteCounterRequest counterId
        |> Http.send CounterDeleted

deleteCounterRequest : CounterId -> Http.Request String
deleteCounterRequest counterId =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = apiUrl ++ "/" ++ (toString counterId)
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

