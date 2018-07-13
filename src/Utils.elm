module Utils exposing
    ( asList
    , (=>)
    , indexOf
    , filterIdFrom
    )

import RemoteData exposing (WebData)
import Types exposing (Model, Counter, CounterId)

(=>) = (,)

asList : WebData (List Counter) -> List Counter
asList response =
    case response of
        RemoteData.NotAsked
            -> []
        RemoteData.Loading
            -> []
        RemoteData.Failure _
            -> []
        RemoteData.Success counterList
            -> counterList

filterIdFrom : CounterId -> List Counter -> List Counter
filterIdFrom id counters =
    List.filter (\counter -> counter.id /= id) counters

indexOf : a -> List a -> Int
indexOf x list =
    findIndex 0 ( (==) x ) list

findIndex : Int -> (a -> Bool) -> List a -> Int
findIndex index predicate list =
    case list of
        [] -> 0
        x :: tail ->
            if predicate x then
                index
            else
                findIndex (index + 1) predicate tail

