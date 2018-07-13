module Actions exposing (..)

import Http exposing (Error)
import Types exposing (Counter, CounterId)
import RemoteData exposing (WebData)

type Action
    = NoOp
    | OnFetchCounters (WebData (List Counter))

    | Reset Counter
    | Increase Counter
    | Decrease Counter

    | CreateCounter
    | CounterCreated (Result Http.Error Counter)

    | Delete Counter
    | CounterDeleted (Result Http.Error String)

    | EnableNameEditing Counter
    | ChangeName Counter String
    | CounterSaved (Result Http.Error Counter)
    | EnterPressed

    | SaveAll
    | AllSaved (Result Http.Error (List Counter))

    | Move Counter
    | DropOn Counter
