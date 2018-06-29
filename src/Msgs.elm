module Msgs exposing (..)

import Http exposing (Error)
import Models exposing (Counter, CounterId)
import RemoteData exposing (WebData)

type Msg
    = NoOp
    | OnFetchCounters (WebData (List Counter))
    | Reset CounterId
    | Increase Counter
    | Decrease Counter
    | EnableEditing Counter
    | EditName Counter String
    | SaveState
    | CreateCounter
    | CounterCreated (Result Http.Error Counter)
    | Delete CounterId
    | CounterDeleted (Result Http.Error String)
    | OnCounterSave (Result Http.Error Counter)

