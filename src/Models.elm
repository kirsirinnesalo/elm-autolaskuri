module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model =
    { vehicles : WebData (List Vehicle)
    }

initialModel : Model
initialModel =
    { vehicles = RemoteData.Loading
    }

type alias VehicleId =
    Int

type alias Vehicle =
    { id: VehicleId
    , name: String
    , count: Int
    }
