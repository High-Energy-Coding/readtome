port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



---- MODEL ----


type alias Model =
    Route


type IsRunning
    = IsPlaying
    | IsPaused


type Route
    = StampPage S3Link String IsRunning
    | Homepage


type alias S3Link =
    String


type alias Id =
    String


init : String -> ( Model, Cmd Msg )
init path =
    ( flagToRoute path, initAudioEl "something" )


flagToRoute : String -> Route
flagToRoute pathFlag =
    if String.startsWith "/stamps/" pathFlag then
        let
            uuid =
                String.dropLeft 8 pathFlag
        in
        case stampUuidToS3Link uuid of
            Just s3Link ->
                StampPage uuid s3Link IsPaused

            Nothing ->
                Homepage

    else
        Homepage


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ playing Playing, pausing Pausing ]



---- UPDATE ----


type Msg
    = GoToHomepage
    | Play
    | Pause
    | Playing Bool
    | Pausing Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToHomepage ->
            ( Homepage, Cmd.none )

        Play ->
            ( model, play "audio" )

        Pause ->
            ( model, pause "audio" )

        Playing _ ->
            ( makeModelPlay model, Cmd.none )

        Pausing _ ->
            ( makeModelPause model, Cmd.none )


makeModelPlay model =
    case model of
        StampPage url link _ ->
            StampPage url link IsPlaying

        _ ->
            model


makeModelPause model =
    case model of
        StampPage url link _ ->
            StampPage url link IsPaused

        _ ->
            model


port play : String -> Cmd msg


port pause : String -> Cmd msg


port initAudioEl : String -> Cmd msg


port playing : (Bool -> msg) -> Sub msg


port pausing : (Bool -> msg) -> Sub msg



---- VIEW ----


view : Model -> Html Msg
view model =
    case model of
        StampPage _ s3Link isRunning ->
            div [ class "stamp-page" ]
                [ div [] [ text s3Link ]
                , div [ class "button-container" ]
                    [ button
                        [ class "play-button"
                        , togglePlaying isRunning
                        ]
                        [ playPauseButtonView isRunning ]
                    ]
                , div []
                    [ audio [ src s3Link ] []
                    ]
                ]

        Homepage ->
            h1 [] [ text "homepage yay" ]


togglePlaying isRunning =
    case isRunning of
        IsPlaying ->
            onClick Pause

        IsPaused ->
            onClick Play


playPauseButtonView isRunning =
    case isRunning of
        IsPlaying ->
            text "⏸️"

        IsPaused ->
            text "▶️"


stampUuidToS3Link uuid =
    case uuid of
        "7733b6ad-dad1-4d35-aa11-1c4f10500d8b" ->
            Just "https://s3.us-east-2.amazonaws.com/vondysolutions.com/jamberry.m4a"

        "a55dfc4c-f537-463d-826e-c4cef5c85383" ->
            Just "https://s3.us-east-2.amazonaws.com/vondysolutions.com/night_before_xmas.m4a"

        _ ->
            Nothing



---- PROGRAM ----


main : Program String Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
