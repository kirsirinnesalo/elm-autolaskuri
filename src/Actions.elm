module Actions exposing (..)

import Http exposing (Error)
import Types exposing (Counter, CounterId)
import RemoteData exposing (WebData)
import Dom

type Action
    = NoOp
    | OnFetchCounters (WebData (List Counter))

    | Reset CounterId
    | Increase Counter
    | Decrease Counter
    | SaveState

    | CreateCounter
    | CounterCreated (Result Http.Error Counter)

    | Delete CounterId
    | CounterDeleted (Result Http.Error String)

    | EnableEditing Counter
    | EditName Counter String
    | OnCounterSave (Result Http.Error Counter)
    | EnterPressed

