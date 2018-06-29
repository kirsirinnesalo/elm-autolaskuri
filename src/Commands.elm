module Commands exposing (..)

import Http
import Json.Decode exposing (Decoder, list, string, int)
import Json.Decode.Pipeline exposing (decode, required)
import Msgs exposing (Msg)
import Models exposing (Vehicle)
import RemoteData


fetchVehicles : Cmd Msg
fetchVehicles =
    fetchApi
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchVehicles

fetchApi : Http.Request (List Vehicle)
fetchApi =
    Http.get api vehiclesDecoder

api : String
api =
    "http://localhost:4000/vehicles"

vehiclesDecoder : Decoder (List Vehicle)
vehiclesDecoder =
    list vehicleDecoder

vehicleDecoder : Decoder Vehicle
vehicleDecoder =
    decode Vehicle
        |> required "id" int
        |> required "name" string
        |> required "count" int

