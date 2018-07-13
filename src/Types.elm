module Types exposing (..)

import RemoteData exposing (WebData)

type alias Model =
    { counters : WebData (List Counter)
    , editId : Maybe CounterId
    , dragged : Maybe Counter
    , movingCounter : Maybe Counter
    }

type alias CounterId =
    Int

type alias Counter =
    { id : CounterId
    , name : String
    , count : Int
    , ordno : Int
    }

initialModel : Model
initialModel =
    { counters = RemoteData.Loading
    , editId = Nothing
    , dragged = Nothing
    , movingCounter = Nothing
    }

newCounterId : CounterId
newCounterId = -1

editingCounterNameId : String
editingCounterNameId = "editCounterName"

newCounter : String -> Counter
newCounter name =
    { id = newCounterId
    , name = name
    , count = 0
    , ordno = 0
    }

