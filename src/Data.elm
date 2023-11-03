module Data exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

-- MODEL


type alias Design =
    { rcsb_id : String
    , method : String
    , exptl_crystal_grow : Maybe ExptlCrystalGrow
    , percentExcited : Float
    }

type alias ExptlCrystalGrow =
    { method : String
    , pH : Float
    }

type alias RcsbEntryInfo =
    { deposited_nonpolymer_entity_instance_count : Maybe Int
    , deposited_polymer_entity_instance_count : Maybe Int
    , disulfide_bond_count : Maybe Int
    , polymer_composition : Maybe String
    , resolution_combined : Maybe Int
    }

-- UPDATE

-- VIEW


designDecoder : Decoder Design
designDecoder =
    Decode.succeed Design
        |> required "rcsb_id" string
        |> required "exptl" (field "method" string) "Experimental method unknown" -- exptl or method?
        |> optional "exptl_crystal_grow" exptl_crystal_growDecoder "Experimental crystal growth method unknown"
        |> required "rcsb_accession_info" (field "deposit_date" string)
        |> optional "rcsb_entry_info" rcsb_entry_infoDecoder

exptl_crystal_growDecoder : Decoder ExptlCrystalGrow
exptl_crystal_growDecoder =
    Decode.succeed ExptlCrystalGrow
        |> required "method" (nullable string)
        |> required "pH" (nullable float)

rcsb_entry_infoDecoder : Decoder RcsbEntryInfo
rcsb_entry_infoDecoder =
    Decode.succeed RcsbEntryInfo
        |> required "deposited_nonpolymer_entity_instance_count" (nullable int)
        |> required "deposited_polymer_entity_instance_count" (nullable int)
        |> required "disulfide_bond_count" (nullable int)
        |> required "polymer_composition" (nullable string)
        |> required "resolution_combined" (nullable int)