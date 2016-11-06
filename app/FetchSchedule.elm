module FetchSchedule exposing (fetchSchedule)

import Http
import Json.Decode as Decode

import Model exposing (..)
import Message exposing (..)
import Types exposing (..)

fetchSchedule : Direction -> Maybe RouteStop -> Cmd Msg
fetchSchedule direction maybeRouteStop =
    case maybeRouteStop of
        Nothing ->
            Cmd.none
        Just routeStop ->
            Http.send LoadSchedule (getSchedule direction routeStop)


getSchedule : Direction -> RouteStop -> Http.Request Schedule
getSchedule direction {route, stop} =
    Http.get
        ( "http://commuter-api-production.herokuapp.com/api/v1/predictions?direction="
          ++ directionName direction
          ++ "&route_id="
          ++ route.id
          ++ "&stop_id="
          ++ stop
        )
        decodeSchedule


decodeSchedule : Decode.Decoder Schedule
decodeSchedule = Decode.list decodeTrain


decodeTrain : Decode.Decoder Train
decodeTrain =
  Decode.map2 Train
    (Decode.field "scheduled_arrival_utc" Decode.string)
    (Decode.field "predicted_arrival_utc" Decode.string)