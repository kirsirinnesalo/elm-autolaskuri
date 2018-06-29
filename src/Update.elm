module Update exposing (..)

import Msgs exposing (..)
import Models exposing (Model, Vehicle, VehicleId)
import RemoteData exposing (map)
import RemoteData exposing (WebData)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnFetchVehicles response ->
            ( { model | vehicles = response }, Cmd.none )

        Reset vehicleId ->
            let
                updatedVehicles =
                    updateCount vehicleId 0 model
            in
                ( { model | vehicles = updatedVehicles }, Cmd.none )

        Increase vehicleId ->
            let
                increasedVehicles =
                    add vehicleId 1 model
            in
                ( { model | vehicles = increasedVehicles }, Cmd.none)

        Decrease vehicleId ->
            let
                decreasedVehicles =
                    add vehicleId -1 model
            in
                ( { model | vehicles = decreasedVehicles }, Cmd.none)

add : VehicleId -> Int -> Model -> WebData (List Vehicle)
add vehicleId value model =
    let
        addVehicle vehicle =
            if vehicle.id == vehicleId then
                if value < 0 && vehicle.count+value < 0 then
                    { vehicle | count = 0 }
                else
                    { vehicle | count = vehicle.count + value }
            else
                vehicle
        addVehicles vehicles =
            List.map addVehicle vehicles
    in
        RemoteData.map addVehicles model.vehicles

updateCount : VehicleId -> Int -> Model -> WebData (List Vehicle)
updateCount vehicleId newValue model =
    let
        updateVehicle vehicle =
            if vehicle.id == vehicleId then
                if newValue < 0 then
                    { vehicle | count = 0}
                else
                    { vehicle | count = newValue }
            else
                vehicle

        updateVehicles vehicles =
            List.map updateVehicle vehicles
    in
        RemoteData.map updateVehicles model.vehicles

