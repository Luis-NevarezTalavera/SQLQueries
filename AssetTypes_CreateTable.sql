--SELECT "One-Sources";
DROP TABLE sourceAssetTypes;
CREATE TABLE sourceAssetTypes
(
    "AssetID" VARCHAR(20) NOT NULL, -- primary key column
    "AssetUUID" VARCHAR(50) Default Null, -- alternate key column
    "filename" VARCHAR(500) Default Null,
    "filesize" VARCHAR(20) Default Null,
    "filewrapper" VARCHAR(30) Default Null,
    "Asset_Status" VARCHAR(10) Default Null,
    "createddatetime"  TIMESTAMP ,
    "stream" VARCHAR(10) Default Null,
    "TitleHRID" VARCHAR(10) Default Null,
    "CGID" VARCHAR(20) Default Null,
    "VersionID" VARCHAR(10) Default Null,
    "Version" VARCHAR(300) Default Null,
    "titletype" VARCHAR(20) Default Null,
    "Picture_A/R" VARCHAR(10) Default Null,
    "Display_A/R" VARCHAR(10) Default Null,
    "Picture_Format" VARCHAR(10) Default Null,
    "Frame_Rate" VARCHAR(10) Default Null,
    "scantype" VARCHAR(20) Default Null,
    "codec" VARCHAR(20) Default Null,
    "bitdepth" VARCHAR(10) Default Null,
    "samplerate" VARCHAR(10) Default Null,
    "Channel_Config" VARCHAR(10) Default Null,
    "Audio_Subtype" VARCHAR(20) Default Null,
    "language" VARCHAR(15) Default Null,
    "subtitlelang" VARCHAR(15) Default Null,
    "subtitletype" VARCHAR(10) Default Null,
    "width" VARCHAR(10) Default Null,
    "height" VARCHAR(10) Default Null,
	"ContentOwner_Name" VARCHAR(50) NOT NULL
);