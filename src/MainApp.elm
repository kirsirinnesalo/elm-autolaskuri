import Html exposing (program)
import Actions exposing (Action)
import Commands exposing (fetchCountersCommand)
import Types exposing (Model, initialModel)
import Update exposing (update)
import View exposing (view)

main : Program Never Model Action
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }

init : (Model, Cmd Action)
init =
    ( initialModel
    , fetchCountersCommand
    )

