module Tests exposing (..)

import Expect
import Main exposing (..)
import Test exposing (..)



-- Check out https://package.elm-lang.org/packages/elm-explorations/test/latest to learn more about testing in Elm!


all : Test
all =
    describe "flagToRoute"
        [ test "homepage" <|
            \_ ->
                Expect.equal Homepage (flagToRoute "/")
        , test "homepage with a random url" <|
            \_ ->
                Expect.equal Homepage (flagToRoute "/gobbledygook/Whattheheck")
        , test "stamproute" <|
            \_ ->
                Expect.equal
                    (StampPage
                        "7733b6ad-dad1-4d35-aa11-1c4f10500d8b"
                        "https://s3.us-east-2.amazonaws.com/vondysolutions.com/jamberry.m4a"
                        IsPaused
                    )
                    (flagToRoute "/stamps/7733b6ad-dad1-4d35-aa11-1c4f10500d8b")
        ]
