module Main exposing (..)

import Html exposing (Html, text, div, h1, button, input, span)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick)
import Random


---- MODEL ----


type alias Model =
    { dieFace : Int }


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )



---- UPDATE ----


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 6) )

        NewFace newFace ->
            ( Model newFace, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (toString model.dieFace) ]
        , div [ class "die-setting" ]
            [ input [ class "die", type_ "number", value "1" ] []
            , span [] [ text "d" ]
            , input [ class "die", type_ "number", value "6" ] []
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
