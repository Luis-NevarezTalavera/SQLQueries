use AssetLibrary
Select top(100) S.AssetID, S.StreamId, S.StreamName, FileUriPath+'\'+FileListXml.value('(/fileList/resourceFile/@uri)[1]', 'varchar(100)') as FileUriPath, S.Status, s.CreatedDateTime, s.UpdatedDateTime, sbl.BaseLocationID, bl.BaseLocationTypeID, bl.BaseUriPath, bl.PrefixPath, bl.Description, bll.LookupValue, bll.LookupDescription, 
				BL.BaseLocationTransferModeId, BLT.Name as TransferMode
from ALStream S inner join ALStreamBaseLocation SBL on S.StreamID = SBL.StreamID
				inner join ALBaseLocation BL on SBL.BaseLocationID = BL.BaseLocationID
				inner join ALBaseLocationTypeLookup BLL on BL.BaseLocationTypeID = BLL.LookupID
				inner join ALBaseLocationTransferMode BLT on BL.BaseLocationTransferModeID = BLT.BaseLocationTransferModeID
Where S.VariantId in (1) and S.IsDeleted in (0)
-- and  S.AssetId  in (select TA.AssetID from ALTitle T WITH (NOLOCK) Left Outer Join ALTitleAsset TA ON T.TitleID = TA.TitleID  where  TitleName like  'QA_Regression_MultiPriority_2016/11/%'  )
 and  S.AssetId in (367397,367399,   367388)  -- Phani MD5 testing
Order by S.StreamId

-- update ALStreamBaseLocation set BaseLocationID=5 where StreamID = (Select StreamId from ALStream where VariantId=1 and AssetId in (367395) and IsDeleted=0)  -- StremId for VariantId=1 (Source Asset)
-- select * from ALBaseLocation

 /*
 select BLL.*,BL.*,CBL.*  
 from ALBaseLocation BL	Left Outer Join ALConfigurationBaseLocation CBL on BL.BaseLocationID=CBL.BaseLocationID 
						Left Outer Join ALBaseLocationTypeLookup BLL on BL.BaseLocationTypeID = BLL.LookupID
 where BL.BaseLocationTypeID in (3) -- 3	Archived
 */
-- select top(10) * from ALStreamBaseLocation -- Where StreamID in (364111)
-- Select * from ALBaseLocationTransferMode
-- select * from ALBaseLocationTypeLookup 

 Select * from ALBaseLocation where BaseLocationID=3
 Select * from ALViewingLocation  where ViewingLocationID=20
 select * from ALCredential

-- Update QA1/QA2 FileTek baseLocations pointing to Prod
-- update ALBaseLocation set PrefixPath='/RFS/ContentServer/' where BaseLocationId=3
-- update ALViewingLocation set ViewingUriPath='ftp://storhouse-read.d3nw.net:2100/ContentServer/' where ViewingLocationID=20

-- Update QA2 Disk Archive baseLocations pointing to QA2
-- update ALBaseLocation set BaseUriPath='la1pvarcftp.d3nw.net', PrefixPath='/ring/fs/d3/Archive/QA2/' where BaseLocationID=27
-- update ALViewingLocation set ViewingUriPath='ftp://la1pvarcftp.d3nw.net:21/ring/fs/d3/Archive/QA2/' where ViewingLocationID=21
-- update ALCredential set password ='66NG7Prgrx' where CredentialID=10

-- update ALBaseLocation set BaseUriPath='\\la1pvarccifs.d3nw.net\QA2\ContentServer\AL\Content\TFA\' where BaseLocationId=5
 -- baseLocationId=3	BaseUriPath='storhouse-write.d3nw.net'									PrefixPath='/RFS/ContentServer/QA2/'
 -- baseLocationId=5	BaseUriPath='\\la1pvarccifs.d3nw.net\QA2\ContentServer\AL\Content\TFA\'	PrefixPath=null
/*
BaseLocationTypeID			LookupDescription
0	Undefined				Asset location is unknown
1	Burbank					Asset is located at Burbank
2	Content Server			Asset is at CoreSite
3	Archived				Asset is on FileTek
4	Deluxe CDN				Asset is at Deluxe CDN
5	Content Server Source	Initial location for Level 0 assets
6	Content Server Internal	Initial location for Level 1 assets
7	Workflow				Workflow Location
8	B to B Aspera			B to B Aspera
10	Staging					Null Packager Staging
11	Thumbnails				Thumbnails

BaselocationId	
	Description
1	Burbank San
2	L2 Drive
3	Filetech Write
4	LimeLight Default Origin
5	L0 Drive
6	L1 Drive
7	LimeLight SmoothStream Origin
8	Level 3 Defaut Origin
9	Level 3 SmoothStream Origin
10	LimeLight Default Origin
11	LimeLight SmoothStream Origin
12	Level 3 Defaut Origin
13	Level 3 SmoothStream Origin
18	Staging Location
19	NULL
20	LimeLight WV APAC Origin
21	LimeLight PR APAC Origin
22	LimeLight WV APAC Origin
23	LimeLight PR APAC Origin
24	NULL

*/