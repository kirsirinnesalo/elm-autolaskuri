module Types exposing (..)

import RemoteData exposing (WebData)

type alias Model =
    { counters : WebData (List Counter)
    , editCounterId : Int
    }

type alias CounterId =
    Int

type alias Counter =
    { id : CounterId
    , name : String
    , count : Int
    }


initialModel : Model
initialModel =
    { counters = RemoteData.Loading
    , editCounterId = newCounterId
    }

newCounterId : Int
newCounterId = -1

editedCounterNameId : String
editedCounterNameId = "editCounterName"

newCounter : String -> Counter
newCounter name =
    { id = newCounterId
    , name = name
    , count = 0
    }

