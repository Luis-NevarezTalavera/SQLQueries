-- Do
-- Declare
-- contentOwnerName text := 'AT&T';

-- Begin
Select Count("AssetID"), Min("AssetID") as FirstAssetID, Max("AssetID") as LastAssetID, fileext, filewrapper,
VideoCODEC, "Display_A/R", width, height, "Frame_Rate", scantype, "Picture_A/R", "Picture_Format", -- , Max("Picture_A/R") as,  Max("Picture_Format") as 
AudioCODEC, bitdepth, samplerate, "Channel_Config", "Audio_Subtype", "audiolang", subtitletype, "subtitlelang" -- lower(audiolang) as audiolang, subtitletype, lower(subtitlelang) as subtitlelang
From (
	SELECT DISTINCT v."AssetID", "AssetUUID", filename, filesize, "Asset_Status", createddatetime, "TitleHRID", "CGID", "VersionID", "Version", titletype,
fileext, filewrapper, VideoCODEC, "Display_A/R", width, height, "Frame_Rate", scantype, "Picture_A/R", "Picture_Format",
AudioCODEC, bitdepth, samplerate, "Channel_Config", "Audio_Subtype", audiolang, subtitletype, subtitlelang
	FROM (
		SELECT DISTINCT "AssetID", "AssetUUID", "Asset_Status", createddatetime, "TitleHRID", "CGID", "VersionID", "Version", titletype,
		SUBSTRING(lower(filename), char_length(filename)-(Case When position('.ts' in lower(filename)) >=1 Then 2 Else 3 End), char_length(filename)) as fileext,
		filename, filesize, filewrapper, codec as VideoCODEC, "Picture_A/R", "Display_A/R", width, height, "Picture_Format", "Frame_Rate", scantype
		FROM sourceAssetTypes WHERE stream IN('VIDEO') and "ContentOwner_Name" = 'Charter' -- 
		) v
		LEFT OUTER JOIN (
			Select DISTINCT "AssetID", codec as AudioCODEC, Case When bitdepth='' Then '16' Else bitdepth End,
			Case When samplerate='48' Then '48000' Else Case When samplerate='' Then '48000' Else samplerate End End,
			"Channel_Config", "Audio_Subtype", lower("language") as audiolang
			FROM sourceAssetTypes WHERE stream IN('AUDIO') and "ContentOwner_Name" = 'Charter' -- 
		) a on v."AssetID" = a."AssetID"
		LEFT OUTER JOIN (
			Select DISTINCT "AssetID", subtitlelang, subtitletype
			FROM sourceAssetTypes WHERE stream IN('SUBTITLE') and "ContentOwner_Name" = 'Charter' -- 
		) s on v."AssetID" = s."AssetID"
		-- LIMIT 1000
		-- WHERE v."AssetID" in ('A12729792','A12729792')
		Order by fileext, filewrapper, VideoCODEC, "Display_A/R", width, height, "Frame_Rate", scantype, "Picture_A/R", "Picture_Format", AudioCODEC, bitdepth, samplerate, "Channel_Config", "Audio_Subtype", audiolang,  subtitletype, subtitlelang
	) as AssetTypesTmp
Group by fileext, filewrapper, VideoCODEC, "Display_A/R", width, height, "Frame_Rate", scantype, "Picture_A/R", "Picture_Format",
AudioCODEC, bitdepth, samplerate, "Channel_Config", "Audio_Subtype", "audiolang", subtitletype, "subtitlelang"
-- Having
Order by Count(*) desc;
-- End;
/*
 Select A1."AssetID", A1."codec" as "Acodec1", A1."samplerate" as sr1, A2."samplerate" as sr2 -- codec, samplerate --filename, filewrapper -- "Display_A/R", width, height, "Picture_A/R"
 FROM public."Rogers_Raw_AssetsData" A1
 Update public."Shaw_Raw_AssetsData"
 Set filewrapper = 'Material eXchange Format' -- "samplerate" ='48000' --
--	Inner Join public."Rogers_Raw_AssetsData" A2 on A1."AssetID" = A2."AssetID"
--	(Select A2."codec" from public."Rogers_Raw_AssetsData" A2 Where A2."AssetID"=A1."AssetID"
--		and A2.stream IN('AUDIO')
--		and A2."samplerate" not in ('','48000')
WHERE
--stream IN('AUDIO')
-- ("samplerate"='4800')
-- and "Picture_A/R" != ''
 position('.mxf' in lower(filename)) >=1
 and filewrapper != 'Material eXchange Format'
LIMIT 100
*/