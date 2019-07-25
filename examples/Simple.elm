module Main exposing (main)

import Compat.Date as Date
import Compat.Time as Time exposing (Month(..))
import Html exposing (text)


main =
    text <| Date.toIsoString <| Date.fromCalendarDate 2020 Jan 1
