Use AssetLibrary
Select A.AssetID, A.AssetName, S.StreamId, S.VariantId, SF.FileID, F.FileName, F.FileUriPath, F.FileTypeID, F.FileSize, F.FileMD5Checksum, F.IsDeleted, F.IsPurged, F.IsVerified 
	From ALAsset A	Inner Join ALStream S ON A.AssetID=S.assetId
					Inner Join ALStreamFile SF On S.StreamId=SF.StreamId
					Inner Join ALFile F ON SF.FileID=F.FileID

	select * from ALFile
	select Distinct FileId from ALStreamFile
/*
select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='ALStreamFile'

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='ALFile'
*/