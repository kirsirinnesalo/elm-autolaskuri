import Html exposing (program)
import Msgs exposing (Msg)
import Commands exposing (fetchCountersCmd)
import Models exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)

main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }

init : (Model, Cmd Msg)
init =
    ( initialModel
    , fetchCountersCmd
    )

