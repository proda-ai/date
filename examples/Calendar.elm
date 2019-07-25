module Calendar exposing (main)

import Compat.Date as Date exposing (Date, Interval(..), Unit(..))
import Compat.Time as Time exposing (Month(..))
import Html exposing (Html)
import Html.Attributes exposing (style)
import Task exposing (Task)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias Model =
    Date


type Msg
    = ReceiveDate Date


init : ( Model, Cmd Msg )
init =
    ( Date.fromCalendarDate 2019 Jan 1
    , Date.today |> Task.perform ReceiveDate
    )



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update (ReceiveDate today) _ =
    let
        _ =
            Debug.log "today?" today
    in
    ( today
    , Cmd.none
    )



-- helpers


monthDates : Int -> Month -> List Date
monthDates year month =
    let
        start =
            Date.fromCalendarDate year month 1
                |> Date.floor Monday

        until =
            start |> Date.add Days 42
    in
    Date.range Day 1 start until


groupsOf : Int -> List a -> List (List a)
groupsOf n list =
    if List.isEmpty list then
        []

    else
        List.take n list :: groupsOf n (List.drop n list)



-- view


view : Model -> Html Msg
view date =
    Html.div
        [ style
            [ ( "padding", "2em" )
            , ( "font-family", "Helvetica, Arial, san-serif" )
            , ( "font-size", "16px" )
            ]
        ]
        [ Html.h2
            [ style
                [ ( "font-size", "16px" )
                , ( "margin", "0" )
                , ( "padding", "0 0.5em 2em" )
                ]
            ]
            [ Html.text (date |> Date.format "MMMM yyyy")
            ]
        , viewMonthTable date
        ]


weekdayHeader : Html a
weekdayHeader =
    Html.thead
        []
        [ Html.tr
            []
            ([ "Mo", "Tu", "We", "Th", "Fr", "Sa", "Su" ]
                |> List.map
                    (\str ->
                        Html.th
                            [ style
                                [ ( "padding", "0.5em" )
                                , ( "font-weight", "normal" )
                                , ( "font-style", "italic" )
                                , ( "color", "gray" )
                                ]
                            ]
                            [ Html.text str
                            ]
                    )
            )
        ]


viewMonthTable : Date -> Html a
viewMonthTable target =
    let
        weeks =
            monthDates (Date.year target) (Date.month target)
                |> groupsOf 7
    in
    Html.table
        [ style
            [ ( "border-collapse", "collapse" )
            , ( "text-align", "right" )
            ]
        ]
        [ weekdayHeader
        , Html.tbody
            []
            (weeks
                |> List.map
                    (\weekdates ->
                        Html.tr
                            []
                            (weekdates
                                |> List.map
                                    (\date ->
                                        let
                                            color =
                                                if Date.month date == Date.month target then
                                                    "black"

                                                else
                                                    "lightgray"

                                            background =
                                                if date == target then
                                                    "lightskyblue"

                                                else
                                                    "transparent"
                                        in
                                        Html.td
                                            [ style
                                                [ ( "padding", "0.5em" )
                                                , ( "background", background )
                                                , ( "color", color )
                                                ]
                                            ]
                                            [ Html.text (Date.day date |> toString)
                                            ]
                                    )
                            )
                    )
            )
        ]
