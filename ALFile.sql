use AssetLibrary
Select top (1000) S.StreamName, S.AssetId, S.StreamId, S.VariantId, s.FileUriPath+'\'+FileListXml.value('(/fileList/resourceFile/@uri)[1]', 'varchar(1000)') as FileUriPath, FA.ALFileAliasID, FA.FileName as AliasFileName, F.FileID, F.FileName, F.FileTypeID, F.FileSize, F.FileMD5Checksum, F.FilePFFFHash
From ALStream S Left Outer Join ALStreamFile SF ON S.StreamID=SF.StreamID 
				Left Outer Join ALFileAlias FA ON FA.ALFileAliasID=SF.ALFileAliasID 
				Left Outer Join ALFile F  On F.FileID=FA.FileID
Where  S.IsDeleted = 0  and S.VariantId in (1)
 and  S.AssetId  in (select TA.AssetID from ALTitle T WITH (NOLOCK) Left Outer Join ALTitleAsset TA ON T.TitleID = TA.TitleID  where  TitleName like  'QA_Regression_MultiPriority_2017/06/02%'  )
-- and  S.AssetId in (2309308) -- QA FF Regression
-- and  S.StreamId in (18909586) -- 
 and VariantID in (1)
 and StreamName Not like '%_ART_%'
-- and  FA.FileUriPath   like '_QASmoke%' ---- 
-- and  ( FA.FileName like 'SweetHome%'  or FA.FileName like 'BlackSails%' 
-- and  FileMD5Checksum>'' 
-- and  F.FileID in (163290,114840)
Order by FileSize desc, S.AssetId, S.StreamId, F.FileID, FA.ALFileAliasID, FA.FileName 

-- Select * From VirtualFileSystem.dbo.Job where JobId=190 --  a1-685376

/*
Select Count(*)-1 as Repeted,  FilePFFFHash, Min(FileMD5Checksum) as FirstMD5, Max(FileMD5Checksum) as LastMD5, Min(FileSize) as MinFileSize, Max(FileSize) as MaxFileSize
From ALFile
Where FilePFFFHash > '' and FileMD5Checksum > ''
Group by FilePFFFHash
Having Count(*)-1 >= 1
Order by Count(*)-1 desc
*/
-- Select * from ALFile where FilePFFFHash='110100000020000100FFFF0F0001:66BFC6A07A202EE9BFEF514542274289'

--Select top (1000) * from ALFileBaseLocation where FileID in (select FileID from ALFile where FileUriPath  like '_QASmoke%')
--select * from ALBaseLocationTypeLookup

-- update ALFile set FileUriPath='_QASmokeTest\VFS_Test1' where FileID=16254
-- update ALFileAlias set FileUriPath='_QASmokeTest\VFS_Test1' where ALFileAliasID=16254

--Delete ALElemStreamFile where ALFileAliasID in (select ALFileAliasID from ALFileAlias	where FileUriPath  like '_QASmoke%')
--Delete ALStreamFile		where ALFileAliasID in (select ALFileAliasID from ALFileAlias	where FileUriPath  like '_QASmoke%')
--Delete ALFileBaseLocation where FileID  in (select FileID from ALFile	where FileUriPath  like '_QASmoke%')
--Delete ALFileAlias		where FileUriPath  like '_QASmoke%'
--Delete ALFile			where FileUriPath  like '_QASmoke%'

/*
Star Wars: The Clone Wars (BBI-Warner) - Source		a1-10999	_BLOCKBUSTER\_WARNER\S\StarWars_TheCloneWars\Feature/STAR_WARS_THE_CLONE_WARS_2008_HD_PROGRESSIVE_23976fps_5_1_WBID_2888437.m2t
Star Wars: The Clone Wars (2008) (Warner) - Source	a1-85344	_ROGERS\_WARNER\S\StarWarsTheCloneWars_2008\Feature/Rogers_Deluxe_STAR_WARS_THE_CLONE_WARS_FEATURE_5_1_4534815.m2t

13786	1	_Vudu\_Gravitas\P\PlasticGalaxy_2014\Feature\PlasticGalaxyTheStoryofStarWarsToys_HD_Movie_2CH.mov
13808	1	_ATT\_GravitasVentures\P\PlasticGalaxy_2014\Feature\PlasticGalaxyTheStoryofStarWarsToys_HD_Movie_2CH.mov
*/