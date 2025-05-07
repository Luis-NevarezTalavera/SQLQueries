Use AssetLibrary
Select  -- Top(1) 
		ALC.ConfigurationId, ALC.Name, ALC.EncryptionTypeId, CBL.BaseLocationId, CBL.[Primary], BLV.ViewingLocationId, ViewingUriPath,[Description]
From ALConfiguration ALC	Left Outer Join ALConfigurationBaseLocation CBL ON ALC.ConfigurationId = CBL.ConfigurationId
							Left Outer Join ALBaseLocationViewing BLV ON CBL.BaseLocationId = BLV.BaseLocationId
							Left Outer Join ALViewingLocation AVL ON BLV.ViewingLocationId = AVL.ViewingLocationId
 Where 
 -- ALC.ConfigurationId = 7 -- PR
  EncryptionTypeId  in (561, 363) and
  BLV.ViewingLocationId Is Not Null
Order by BLV.ViewingLocationId desc

-- select * from ALConfiguration where ConfigurationId = 7 -- PR
-- select * from ALConfigurationBaseLocation where ConfigurationId = 7 -- and [Primary] = 1   -- PR
-- select * from ALBaseLocationViewing where BaseLocationId in (2,11,29) -- PR
-- select * from ALViewingLocation where ViewingLocationId in(6,11) -- PR

/*
ConfigurationID	Name
1	Source
2	Transcode
3	Key Disc, AACS
4	Key Disc, Clear
5	Widevine Transcode
6	Widevine
7	Playready
8	Art Reference: Cover Art
9	Art Reference: Image
10	L1s Only
11	Closed Caption Transform
12	Null Package, Clear
13	DCD Package, Clear
14	Thumbnails
15	Sidecar
16	Unified Streaming
17	Unencrypted Passthrough
18	HLS
19	Modular
20	FairPlay
21	BiffImage
22	PlayreadyDirt
23	ModularDirt
24	FairplayDirt
*/