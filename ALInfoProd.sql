Use AssetLibrary
SELECT  TOP(4000)  T.TitleID, T.TitleName,TE.titleeditionid,A.AssetName, A.Duration, AL.LookupValue as ContentType, S.StreamName, A.AssetID, S.StreamID, S.VariantID, -- s.PipelineConfigurationGuid, S.StreamStateTypeID, S.StreamSubStateTypeID, S.ContainerTypeID, S.EncryptionTypeID,
				   Case  When S.ContainerTypeID=347 Then Case  When S.EncryptionTypeID=547 Then 'http://cdn3.d3nw.com/u/'+FileUriPath+'/'+SUBSTRING(CONVERT(varchar(8000),FileListXML),48,23)+'/manifest'  
						 Else Case  When S.EncryptionTypeID=365 Then 'http://cdn2.d3nw.com/u/'+FileUriPath+'/'+SUBSTRING(CONVERT(varchar(8000),FileListXML),48,29) Else FileUriPath+'/'+SUBSTRING(CONVERT(varchar(8000),FileListXML),48,60) End End Else FileUriPath End as CDN_FileUrlPath,
				   LE.LookupValue as StState, LE1.LookupValue as StSubState, S.Status, LE2.LookupValue as Encryption, -- B.BaseLocationID, BL.Description as BaseLocation, B.CreatedDateTime as BLDateTime, 
				   S.CreatedDateTime,S.UpdatedDateTime, S.IsDeleted, S.FileListXML
FROM ALTitle T WITH (NOLOCK) Left Outer Join ALTitleAsset TA ON T.TitleID = TA.TitleID 
							 Left Outer Join ALTitleEdition TE ON T.TitleID = TE.TitleID 
							 Left Outer Join ALAsset A ON TA.AssetID = A.AssetID 
							 Left Outer Join ALStream S ON A.AssetID = S.AssetID
							 -- Left Outer Join ALStreamBaseLocation B ON S.StreamID = B.StreamID
							 -- left Outer Join ALBaseLocation BL On B.BaseLocationID = BL.BaseLocationID
							 Left Outer Join ALAssetTypeLookup AL ON A.AssetTypeID = AL.LookupID 
							 Left Outer Join LookupEnum LE ON S.StreamStateTypeID = LE.LookupID 
							 Left Outer Join LookupEnum LE1 ON S.StreamSubStateTypeID = LE1.LookupID
							 Left Outer Join LookupEnum LE2 ON S.EncryptionTypeID = LE2.LookupID
 Where (TitleName like 'QA_Regression_2013/07/02%')  and S.IsDeleted = 0  ---- TitleName like 'CPS-770%'  or TitleName like 'SlowPlay%' or TitleName like 'CPS-559%' or 
-- and B.BaseLocationID < 13 
-- or T.TitleID in (21659) 
-- and A.AssetName  like '%4-3%' -- and A.AssetName not like '%MPEG4_CineForm%' 
-- and  A.AssetId  in (98619) --(99541,99542,99543,99544,99545,99546,99547,99548,99549,99550,99551,99552,99553,99554,99555,99556,99557,99558,99559,99560,99561,99562,99563,99564,99565,99566,99567,99568,99571,99572,99573,99574) and S.IsDeleted = 0
-- and (Select AssetId from ALAssetProperty Where PropertyName = 'FILE0_FRAME_WIDTH' And ValueInt < 1920) 
-- and  'a1-' + CONVERT(varchar(5),A.AssetId)  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where  MasterTitle.MovieTitle like 'QA_Regression_2013/06/28%' ) -- Title.TitleStateId=14 and)
-- and (S.VariantID   in (1) or (S.VariantID >= 317 and S.VariantID <= 320 ) )-- Samsung and Vudu L1 Variants
-- and S.VariantID in (372,373,374,375,376,377) --  < 2004 
-- and LE.LookupValue  in ('Failed') -- ,'pending') -- ,'TranscodedNotTested') --  ('completed') --  
-- and LE1.LookupValue  in ('Failed_QC') 
-- or StreamID  in (2046680) 
-- and (StreamName  like '%480 %' or StreamName  like '%720%' or StreamName  like '%1080%' or StreamName  like '%854x480%')  
-- and CONVERT(varchar(8000),FileListXML) like '%wvm%'
-- Where (S.Status like '%REVIEW%') --'%Source%Caching%' OR S.Status like 'Transcoder Failure Point 2: Object reference not set to an instance of an object%' ) -- OR S.Status like '%average bitrate%' OR S.Status like '%The Client was unable to process the callback%' OR S.Status like '%Error % in GetMedia%' OR S.Status like '%Error % in Connect%' OR S.Status like '%Error % in Validate%' OR S.Status like '%n_frames value%' OR S.Status like '%the average') 
-- and S.Status not in  ('Job Canceled!','Transcode Successful', Null) 
-- Where (S.CreatedDateTime > '2012-10-22 22:00:00.000' AND S.UpdatedDateTime > '2012-10-22 23:00:00.000' )
-- and ContainerTypeID in (347) -- None -- (351) -- MPEG4 -- (362) -- Other
 and S.EncryptionTypeId in (365,547)  --  (365) -- WV -- (547) -- PR -- (561) Unencrypted -- (363) None
-- and PATINDEX('%PlayReady%', S.StreamName )>1
ORDER BY  TA.TitleId desc, A.AssetID, S.variantId, S.StreamID desc --, --  S.UpdatedDateTime desc,  -- S.EncryptionTypeID, 
-- Order by S.CreatedDateTime, S.UpdatedDateTime 

/*
select * from LookupEnum where LookupGroup in ('ALEncryptionType')
Select count(StreamId) as StreamsCount from ALStream Where AssetID in (73973)  
Select * from ALTitle T where T.TitleID in (21659) 
select * from AlAsset order by AssetId desc  -- where IsDeleted=1  77118 (deleted), 77847 (and up, does not exists)
	StreamStateTypeID Values
	343 = Pending
	345 = Completed
	346 = Failed
	512 = TranscodedSuccesfull, Not Baton QC Tested
	15 = Transcoding Error       
	
	Select * from ALAssetTypeLookup
1	FeatureFilm
2	TVEpisode
3	ShortFilm
4	Trailer
5	DeletedScene
6	Featurette
7	Interview
8	MakingOf
9	Outtake
10	RatingCard
11	WarningCard
12	Logo
13	Slate
14	Other
15	ArtReference
16	BrandingPreroll
17	AdvertisingPreroll
18	InfoTour
19	Preview
	 */
