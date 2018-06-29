module Models exposing (..)

import RemoteData exposing (WebData)
import Json.Decode as Json

type alias Model =
    { counters : WebData (List Counter)
    , editCounterId : Int
    }

initialModel : Model
initialModel =
    { counters = RemoteData.Loading
    , editCounterId = -1
    }

newCounter : Int -> String -> Counter
newCounter id name =
    { id = id
    , name = name
    , count = 0
    }

type alias CounterId =
    Int

type alias Counter =
    { id : CounterId
    , name : String
    , count : Int
    }

type EditMode = Editing | NotEditing
