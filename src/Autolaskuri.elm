import Html exposing (program)
import Msgs exposing (..)
import Models exposing (..)
import View exposing (..)

main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }

init : (Model, Cmd Msg)
init = (initialModel, Cmd.none)

-- Update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Reset vehicle ->
            ( reset model vehicle, Cmd.none)
        Increment vehicle ->
            ( add model vehicle 1, Cmd.none)
        Decrement vehicle ->
            ( add model vehicle -1, Cmd.none)

reset : Model -> Vehicle -> Model
reset model vehicle =
    let
        resetVehicles v =
            if v.id == vehicle.id then
                { v | count = 0 }
            else
                v
        resetedVehicles =
            List.map resetVehicles model.vehicles
    in
        { model | vehicles = resetedVehicles }

add : Model -> Vehicle -> Int -> Model
add model vehicle value =
    let
        addVehicles v =
            if v.id == vehicle.id then
                { v | count = vehicle.count + value }
            else
                v
        updatedVehicles =
            List.map addVehicles model.vehicles
    in
        { model | vehicles = updatedVehicles }

