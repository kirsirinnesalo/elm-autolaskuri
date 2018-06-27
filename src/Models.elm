module Models exposing (..)

type alias Model =
    { vehicles : List Vehicle
    }

initialModel : Model
initialModel =
    { vehicles = [
        Vehicle 1 "Mopo" 0
        , Vehicle 2 "Henkilöauto" 0
        ]
    }

type alias Vehicle =
    { id: Int
    , name: String
    , count: Int
    }

