module Actions exposing (..)

import Http exposing (Error)
import Types exposing (Counter, CounterId)
import RemoteData exposing (WebData)

type Action
    = NoOp
    | OnFetchCounters (WebData (List Counter))

    | Reset CounterId
    | Increase Counter
    | Decrease Counter

    | CreateCounter
    | CounterCreated (Result Http.Error Counter)

    | Delete CounterId
    | CounterDeleted (Result Http.Error String)

    | EnableEditing Counter
    | EditName Counter String
    | CounterSaved (Result Http.Error Counter)
    | EnterPressed

    | SaveAll
    | AllSaved (Result Http.Error (List Counter))

