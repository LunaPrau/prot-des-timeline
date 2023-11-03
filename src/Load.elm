module Load exposing (..)

-- LOADING THE PROTEIN DATA
-- based heavily on https://elmprogramming.com/fetching-data-using-get.html

-- TODO:
-- href links to new pages with more details about the protein
-- sort by time
-- add filters for searching / selecting proteins

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Decoders exposing (..)

-- TYPES

type alias ProteinStructure =
    Decoders.ProteinStructure
--    { identifier : String
--    , typePS : String
--    }

type alias Model =
    { proteinStructures : List ProteinStructure
    }

type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error ( List ProteinStructure) )

-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from server" ]
        , viewProteinData model.proteinStructures
        ]

-- FUNCTIONS
-- ### getting the data

url : String
url = 
    "http://localhost:8000/src/data.json"

getData : Cmd Msg
getData =
    Http.get
        { url = url
        , expect = Http.expectJson DataReceived (list proteinStructureDecoder)
        }

-- ### viewing the protein data

viewProteinData : List ProteinStructure -> Html Msg
viewProteinData proteinStructures =
    div []
        [ h3 [] [ text "Protein data:" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewData proteinStructures)
        ]

viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "Identifiers:" ]
        ]

viewData : ProteinStructure -> Html Msg
viewData proteinStructure =
    tr []
        [ td []
            [ text proteinStructure.identifier ]
        ]

-- DECODERS

proteinStructureDecoder : Decoder ProteinStructure
proteinStructureDecoder = Decoders.proteinStructureDecoder
--proteinStructureDecoder = : Decoder ProteinStructure
--proteinStructureDecoder =
--    Decode.succeed ProteinStructure
--        |> required "identifier" string
--        |> required "typePS" string

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( { model | proteinStructures = [] }, getData )

        DataReceived result ->
            case result of
                Ok proteinDataJson ->
                    ( { model | proteinStructures = proteinDataJson }, Cmd.none )
                Err _ ->
                    ( { model | proteinStructures = [] }, Cmd.none )

-- INITIALISE

init : () -> ( Model, Cmd Msg )
init _ =
    ( { proteinStructures = [] }
    , Cmd.none
    )

-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }