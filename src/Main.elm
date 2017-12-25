module Main exposing (..)

import Html exposing (Html, text, div, h1, h3, button, input, span)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onInput)
import Random


---- MODEL ----


type alias Model =
    { dieFaces : List Int, faceNum : Int, times : Int }


init : ( Model, Cmd Msg )
init =
    ( { dieFaces = [ ]
      , faceNum = 6
      , times = 1
      }
      , Cmd.none )



---- UPDATE ----


type Msg
    = Roll
    | NewFaces (List Int)
    | FaceNum String
    | Times String

toInt : String -> Int -> Int
toInt str default = Result.withDefault default 
                    <| String.toInt str

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        Roll ->
            let
                cmd = Random.int 1 model.faceNum
                      |> Random.list model.times
                      |> Random.generate NewFaces
            in                    
            ( model, cmd )

        NewFaces newFaces ->
            ( { model | dieFaces = newFaces }, Cmd.none )

        Times newTimes ->
            ( { model | times = (toInt newTimes model.times) }, Cmd.none )

        FaceNum newNum ->
            ( { model | faceNum = (toInt newNum model.faceNum) }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view { dieFaces, faceNum, times } =
    let
        sum = if List.isEmpty dieFaces
              then "-"
              else List.sum dieFaces |> toString
        list = List.foldl (\a b -> a ++ ", " ++ b)
                    ( Maybe.withDefault "-" (List.head dieFaces |> Maybe.map toString) )
                    ( List.map toString ( Maybe.withDefault [] <| List.tail dieFaces ) )
    in
    div []
        [ h1 [] [ text sum ]
        , h3 [] [ text list ]
        , div [ class "die-setting" ]
            [ input [ class "die", type_ "number", value (toString times), onInput Times ] []
            , span [] [ text "d" ]
            , input [ class "die", type_ "number", value (toString faceNum), onInput FaceNum ] []
            ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
