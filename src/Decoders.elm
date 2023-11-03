module Decoders exposing (..)

-- DECODING THE PROTEIN DATA JSON
-- mostly from chatGPT

import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (..)

-- TYPES

type alias EntityPoly =
    { pdbxSeqOneLetterCodeCan : String }

type alias RcsbAssemblyInfo =
    { polymerEntityInstanceCount : Int }

type alias StructKeywords =
    { pdbxKeywords : String }

type alias RcsbPrimaryCitation =
    { pdbxDatabaseIdDOI : String }

type alias RcsbEntryInfo =
    { depositedNonpolymerEntityInstanceCount : Int
    , depositedPolymerEntityInstanceCount : Int
    , disulfideBondCount : Int
    , polymerComposition : String
    , resolutionCombined : Maybe String
    }

type alias RcsbEntryContainerIdentifiers =
    { entryId : String }

type alias RcsbAccessionInfo =
    { depositDate : String }

type alias Exptl =
    { method : String }

type alias Data =
    { rcsbId : String
    , em3DReconstruction : Maybe String
    , exptl : List Exptl
    , exptlCrystalGrow : Maybe String
    , rcsbAccessionInfo : RcsbAccessionInfo
    , rcsbEntryContainerIdentifiers : RcsbEntryContainerIdentifiers
    , rcsbEntryInfo : RcsbEntryInfo
    , rcsbPrimaryCitation : RcsbPrimaryCitation
    , refine : Maybe String
    , structKeywords : StructKeywords
    , polymerEntities : List EntityPoly
    , assemblies : List RcsbAssemblyInfo
    , nonpolymerEntities : Maybe String
    }

type alias ProteinStructure =
    { identifier : String
--    , data : Data
    , typePS : String
    }

-- DECODERS

entityPolyDecoder : Decoder EntityPoly
entityPolyDecoder =
    Decode.succeed EntityPoly
        |> required "pdbx_seq_one_letter_code_can" string

rcsbAssemblyInfoDecoder : Decoder RcsbAssemblyInfo
rcsbAssemblyInfoDecoder =
    Decode.succeed RcsbAssemblyInfo
        |> required "polymer_entity_instance_count" int

structKeywordsDecoder : Decoder StructKeywords
structKeywordsDecoder =
    Decode.succeed StructKeywords
        |> required "pdbx_keywords" string

rcsbPrimaryCitationDecoder : Decoder RcsbPrimaryCitation
rcsbPrimaryCitationDecoder =
    Decode.succeed RcsbPrimaryCitation
        |> required "pdbx_database_id_DOI" string

rcsbEntryInfoDecoder : Decoder RcsbEntryInfo
rcsbEntryInfoDecoder =
    Decode.succeed RcsbEntryInfo
        |> required "deposited_nonpolymer_entity_instance_count" int
        |> required "deposited_polymer_entity_instance_count" int
        |> required "disulfide_bond_count" int
        |> required "polymer_composition" string
        |> required "resolution_combined" (Decode.nullable string)

rcsbEntryContainerIdentifiersDecoder : Decoder RcsbEntryContainerIdentifiers
rcsbEntryContainerIdentifiersDecoder =
    Decode.succeed RcsbEntryContainerIdentifiers
        |> required "entry_id" string

rcsbAccessionInfoDecoder : Decoder RcsbAccessionInfo
rcsbAccessionInfoDecoder =
    Decode.succeed RcsbAccessionInfo
        |> required "deposit_date" string

exptlDecoder : Decoder Exptl
exptlDecoder =
    Decode.succeed Exptl
        |> required "method" string

dataDecoder : Decoder Data
dataDecoder =
    Decode.succeed Data
        |> required "rcsb_id" string
        |> required "em_3d_reconstruction" (Decode.nullable string)
        |> required "exptl" (Decode.list exptlDecoder)
        |> required "exptl_crystal_grow" (Decode.nullable string)
        |> required "rcsb_accession_info" rcsbAccessionInfoDecoder
        |> required "rcsb_entry_container_identifiers" rcsbEntryContainerIdentifiersDecoder
        |> required "rcsb_entry_info" rcsbEntryInfoDecoder
        |> required "rcsb_primary_citation" rcsbPrimaryCitationDecoder
        |> required "refine" (Decode.nullable string)
        |> required "struct_keywords" structKeywordsDecoder
        |> required "polymer_entities" (Decode.list entityPolyDecoder)
        |> required "assemblies" (Decode.list rcsbAssemblyInfoDecoder)
        |> required "nonpolymer_entities" (Decode.nullable string)

proteinStructureDecoder : Decoder ProteinStructure
proteinStructureDecoder =
    Decode.succeed ProteinStructure
        |> required "identifier" string
--        |> required "data" dataDecoder
        |> required "typePS" string