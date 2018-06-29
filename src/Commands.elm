module Commands
    exposing
        ( focusOnEditCounterCmd
        , fetchCountersCmd
        , saveCounterCmd
        , createNewCounterCmd
        , deleteCounterCmd
        )

import Http
import Json.Decode as Decode exposing (Decoder, list, string, int)
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (..)
import Models exposing (Counter, CounterId)
import RemoteData
import Json.Encode as Encode
import Task exposing (Task)
import Dom


focusOnEditCounterCmd : Cmd Msg
focusOnEditCounterCmd =
    Task.attempt (\_ -> NoOp) (Dom.focus "editCounterName")

fetchCountersCmd : Cmd Msg
fetchCountersCmd =
    fetchApi
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchCounters

fetchApi : Http.Request (List Counter)
fetchApi =
    Http.get apiUrl countersDecoder

apiUrl : String
apiUrl =
    "http://localhost:4000/counters"

countersDecoder : Decoder (List Counter)
countersDecoder =
    list counterDecoder

counterDecoder : Decoder Counter
counterDecoder =
    decode Counter
        |> required "id" int
        |> required "name" string
        |> required "count" int

saveCounterCmd : Counter -> Cmd Msg
saveCounterCmd counter =
    saveCounterRequest counter
        |> Http.send Msgs.OnCounterSave

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

createNewCounterCmd : Counter -> Cmd Msg
createNewCounterCmd counter =
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

deleteCounterCmd : CounterId -> Cmd Msg
deleteCounterCmd counterId =
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


