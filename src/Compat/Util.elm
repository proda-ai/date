module Compat.Util exposing (fromInt, modBy)


modBy : Int -> Int -> Int
modBy a b =
    b % a


fromInt : Int -> String
fromInt =
    toString
