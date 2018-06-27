module Msgs exposing (..)

import Models exposing (Vehicle)

type Msg =
    Reset Vehicle
    | Increment Vehicle
    | Decrement Vehicle
