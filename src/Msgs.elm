module Msgs exposing (..)

import Models exposing (Vehicle, VehicleId)
import RemoteData exposing (WebData)

type Msg =
    OnFetchVehicles (WebData (List Vehicle))
    | Reset VehicleId
    | Increase VehicleId
    | Decrease VehicleId

