import Html exposing (program)
import Msgs exposing (..)
import Commands exposing (fetchVehicles)
import Models exposing (..)
import Update exposing (..)
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
init = (initialModel, fetchVehicles)

