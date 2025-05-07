Use assetLibrary
Select * from ALBaseLocation

Select Top 500 S.Assetid, S.StreamID, S.StreamName, S.EncryptionTypeID, S.StreamStateTypeID, BL.BaseLocationID, BL.BaseLocationTransferModeID, BL.BaseUriPath, BL.Description 
	from ALStream S Left outer Join ALStreamBaselocation SBL on S.StreamID = SBL.StreamID
					Left outer Join ALBaseLocation BL on SBL.BaselocationID = BL.BaselocationID
Order by S.AssetID desc, S.StreamID desc

--update ALBaseLocation set BaseUriPath = '\\LA1RVCONSVR001\ContentServer\'					where BaseLocationID = 2 -- Assets in QA2
--update ALBaseLocation set BaseUriPath = '\\LA1RVCONSVR001\ContentServer\Output\'			where BaseLocationID = 6 -- Output in QA2
--update ALBaseLocation set BaseUriPath = '\\LA1RVCONSVR001\ContentServer\AL\Content\TFA\'	where BaseLocationID = 5 -- Source assets in QA2
