module Update exposing (..)

import Html
import Actions exposing (..)
import Types exposing (Model, Counter, CounterId, newCounter, newCounterId, editedCounterNameId)
import Dom exposing (blur)
import Task exposing (attempt)
import RemoteData exposing (map, WebData)
import Commands
    exposing
        ( focusOnEditCounterCommand
        , fetchCountersCommand
        , saveCounterCommand
        , createNewCounterCommand
        , deleteCounterCommand
        )

update : Action -> Model -> (Model, Cmd Action)
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        OnFetchCounters response ->
            ( { model | counters = response }, Cmd.none )

        Reset id ->
            let
                updatedCounters =
                    updateCount id 0 model
            in
                ( { model | counters = updatedCounters }, Cmd.none )

        Increase counter ->
            let
                updatedCounters =
                    updateCount counter.id (inc counter 1) model
            in
                ( { model | counters = updatedCounters }, Cmd.none )

        Decrease counter ->
            let
                updatedCounters =
                    updateCount counter.id (inc counter -1) model
            in
                ( { model | counters = updatedCounters }, Cmd.none )

        SaveState ->
            ( model, Cmd.none )

        CreateCounter ->
            ( model, createNewCounterCommand (newCounter "Auto") )

        CounterCreated (Ok counter) ->
            ( toggleEditing
                { model | counters = appendCounter counter model.counters }
                counter
            , focusOnEditCounterCommand
            )

        Delete id ->
            let
                filterIdFrom counters =
                    List.filter (\counter -> counter.id /= id) counters
            in
                ( { model | counters = RemoteData.map filterIdFrom model.counters }
                , deleteCounterCommand id)

        CounterDeleted _ ->
            (model, fetchCountersCommand)

        EnableEditing counter ->
            ( toggleEditing model counter, focusOnEditCounterCommand )

        EditName counter newName ->
            let
                updatedCounter =
                    { counter | name = newName }
                toggledModel =
                    toggleEditing model counter
            in
                if String.trim newName == "" || newName == counter.name then
                    ( toggledModel, Cmd.none )
                else
                    ( toggledModel, saveCounterCommand updatedCounter )

        OnCounterSave (Ok counter) ->
            ( saveCounter model counter, Cmd.none )

        EnterPressed ->
            ( model, blur editedCounterNameId |> Task.attempt (\_ -> NoOp) )

        _ ->
            ( model, Cmd.none )


toggleEditing : Model -> Counter -> Model
toggleEditing model counter =
    if model.editCounterId == counter.id then
        { model | editCounterId = -1 }
    else
        { model | editCounterId = counter.id }

inc : Counter -> Int -> Int
inc counter amount =
    if amount < 0 && counter.count + amount < 0 then
        0
    else
        counter.count + amount

updateCount : CounterId -> Int -> Model -> WebData (List Counter)
updateCount id newValue model =
    let
        updateCounter counter =
            if counter.id == id then
                if newValue < 0 then
                    { counter | count = 0}
                else
                    { counter | count = newValue }
            else
                counter

        updateCounters counters =
            List.map updateCounter counters
    in
        RemoteData.map updateCounters model.counters

saveCounter : Model -> Counter -> Model
saveCounter model counter =
    let
        pick current =
            if counter.id == current.id then
                counter
            else
                current

        updateCounterList counters =
            List.map pick counters

        updatedCounters =
            RemoteData.map updateCounterList model.counters
    in
        { model | counters = updatedCounters }

appendCounter : Counter -> WebData (List Counter) -> WebData (List Counter)
appendCounter newCounter counters =
    let
        appendCounter : List Counter -> List Counter
        appendCounter listOfCounters =
            List.append listOfCounters [ newCounter ]
    in
        RemoteData.map appendCounter counters


