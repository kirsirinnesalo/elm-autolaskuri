module Update exposing (..)

import Dom exposing (blur)
import Task exposing (attempt)
import RemoteData exposing (map, WebData)
import List exposing (take, drop)

import Actions exposing (..)
import Types exposing (Model, Counter, CounterId, newCounter, editingCounterNameId)
import Commands
    exposing
        ( focusOnEditCounterCommand
        , fetchCountersCommand
        , saveCounterCommand
        , createNewCounterCommand
        , deleteCounterCommand
        , saveAllCommand
        )
import Utils

update : Action -> Model -> (Model, Cmd Action)
update action model =
    case Debug.log "got action" action of
        OnFetchCounters response ->
            ( { model | counters = response }, Cmd.none )

        Reset counter ->
            let
                updatedCounters =
                    updateCounterTo 0 counter.id model
            in
                ( { model | counters = updatedCounters }, Cmd.none )

        Increase counter ->
            let
                plus1 counter =
                    inc counter 1

                updatedCounters =
                    updateCounterTo (plus1 counter) counter.id model
            in
                ( { model | counters = updatedCounters }, Cmd.none )

        Decrease counter ->
            let
                minus1 counter =
                    inc counter -1

                updatedCounters =
                    updateCounterTo (minus1 counter) counter.id model
            in
                ( { model | counters = updatedCounters }, Cmd.none )

        CreateCounter ->
            ( model, createNewCounterCommand (newCounter "Auto") )

        CounterCreated (Ok newCounter) ->
            let
                list_ =
                    Utils.asList model.counters
            in
                ( toggleEditing
                    newCounter
                    { model | counters = (appendAsLast newCounter model.counters) }
                , focusOnEditCounterCommand
                )

        Delete counter ->
            let
                list_ =
                    Utils.asList model.counters

                counters_ =
                    Utils.filterIdFrom counter.id list_
            in
                ( { model | counters = RemoteData.succeed counters_ }, deleteCounterCommand counter)

        CounterDeleted _ ->
            (model, fetchCountersCommand)

        EnableNameEditing counter ->
            ( toggleEditing counter model, focusOnEditCounterCommand )

        ChangeName counter newName ->
            let
                newNameIsEmpty =
                    String.isEmpty <| String.trim newName

                updatedCounter =
                    { counter | name = newName }

                toggledModel =
                    toggleEditing counter model
            in
                if newNameIsEmpty || newName == counter.name then
                    ( toggledModel, Cmd.none )
                else
                    ( toggledModel, saveCounterCommand updatedCounter )

        CounterSaved (Ok counter) ->
            ( updateViewedCounter model (Debug.log "counter saved" counter), Cmd.none )

        EnterPressed ->
            ( model, blur editingCounterNameId |> Task.attempt (\_ -> NoOp) )

        SaveAll ->
            ( model, saveAllCommand (Utils.asList model.counters) )

        AllSaved (Ok counterList) ->
            let
                _ = Debug.log "counters saved" counterList
            in
                ( model, fetchCountersCommand )

        Move counter ->
            ( { model | movingCounter = Just counter }, Cmd.none )

        DropOn counter ->
            let
                model_ =
                    { model
                        | counters =
                            updatedCounterListOnDrop counter model
                            |> RemoteData.Success
                        , movingCounter = Nothing
                    }
            in
                ( Debug.log "new model after drop" model_, saveAllCommand (Utils.asList model_.counters))

        _ ->
            ( model, Cmd.none )

toggleEditing : Counter -> Model -> Model
toggleEditing counter model =
    let
        toggledId =
            case model.editId of
                Nothing ->
                    Just counter.id
                Just editId ->
                    if editId == counter.id then
                        Nothing
                    else
                        Just counter.id
    in
        { model | editId = toggledId}

inc : Counter -> Int -> Int
inc counter amount =
    let
        counterGetsNegative =
            amount < 0 && counter.count + amount < 0
    in
        if counterGetsNegative then
            0
        else
            counter.count + amount

updateCounterTo : Int -> CounterId -> Model -> WebData (List Counter)
updateCounterTo newValue counterId model =
    let
        updateCountTo newValue counter =
            if newValue < 0 then
                { counter | count = 0}
            else
                { counter | count = newValue }

        updateCounter counter =
            if counter.id == counterId then
                updateCountTo newValue counter
            else
                counter

        updateCounters counters =
            List.map updateCounter counters
    in
        RemoteData.map updateCounters model.counters

updateViewedCounter : Model -> Counter -> Model
updateViewedCounter model counter =
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

appendAsLast : Counter -> WebData (List Counter) -> WebData (List Counter)
appendAsLast newCounter counters =
    let
        counters_ =
            Utils.asList counters

        appendCounter listOfCounters =
            List.append listOfCounters [ { newCounter | ordno = List.length counters_ } ]
    in
        appendCounter counters_ |> RemoteData.Success

updatedCounterListOnDrop : Counter -> Model -> List Counter
updatedCounterListOnDrop onCounter model =
    let
        movingCounter_ =
            case model.movingCounter of
                Nothing             -> onCounter
                Just movingCounter  -> movingCounter

        fromIndex =
            Utils.indexOf movingCounter_ (Utils.asList model.counters)

        list_ =
            Utils.asList model.counters
                |> Utils.filterIdFrom movingCounter_.id

        dropOnIndex =
            Utils.indexOf onCounter list_

        x =
            if fromIndex > dropOnIndex
                then dropOnIndex
                else dropOnIndex + 1

        fixOrdno (index, counter) =
            { counter | ordno = index + 1 }

        fixOrdnos list =
            List.indexedMap (\i c -> fixOrdno (i, c)) list
    in
        (++)
            ( take x list_ )
            ( movingCounter_
                :: ( drop x list_ )
            )
        |> fixOrdnos
