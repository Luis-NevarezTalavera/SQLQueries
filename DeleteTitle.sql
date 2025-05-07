BEGIN TRY

BEGIN TRANSACTION
DECLARE @TitleID int
SET @TitleID = 51275

--OrderProcessing

Select * from [OrderProcessing].[dbo].[CMRLoadStatusLog] CMRLog
Inner join [AssetLibrary].dbo.ALAsset ALA on CMRLog.AssetID = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)
DELETE CMRLOG from [OrderProcessing].[dbo].[CMRLoadStatusLog] CMRLog
Inner join [AssetLibrary].dbo.ALAsset ALA on CMRLog.AssetID = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)

select * from [OrderProcessing].[dbo].[EMAConversionStatusLog] EMALog
Inner join [AssetLibrary].dbo.ALAsset ALA on EMALog.AssetID = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)
DELETE EMALog from [OrderProcessing].[dbo].[EMAConversionStatusLog] EMALog
Inner join [AssetLibrary].dbo.ALAsset ALA on EMALog.AssetID = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)

select * from [OrderProcessing].[dbo].[StreamVariant] AS SV
where TitleId in (Select OPT.TitleId from [OrderProcessing].[dbo].[Title] OPT
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID))
DELETE SV from [OrderProcessing].[dbo].[StreamVariant] AS SV
where TitleId in (Select OPT.TitleId from [OrderProcessing].[dbo].[Title] OPT
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID))

Select * from [OrderProcessing].[dbo].[Event] E
Inner Join [OrderProcessing].[dbo].[Title] OPT on OPT.TitleId = E.TitleId
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)
DELETE E from [OrderProcessing].[dbo].[Event] E
Inner Join [OrderProcessing].[dbo].[Title] OPT on OPT.TitleId = E.TitleId
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)

Select * from [OrderProcessing].[dbo].[Title] OPT
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)
DELETE OPT from [OrderProcessing].[dbo].[Title] OPT
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)

Select * from [OrderProcessing].[dbo].[MasterTitle] MT
Inner Join [OrderProcessing].[dbo].[Title] OPT on OPT.MasterTitleId = MT.MasterTitleId
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)
DELETE MT from [OrderProcessing].[dbo].[MasterTitle] MT
Inner Join [OrderProcessing].[dbo].[Title] OPT on OPT.MasterTitleId = MT.MasterTitleId
Inner join [AssetLibrary].dbo.ALAsset ALA on OPT.ALAssetId = 'a1-'+ CONVERT(varchar(20), ALA.AssetID)
where ALA.AssetID in (Select AssetID from [AssetLibrary].dbo.ALTitleAsset where TitleID = @TitleID)


--CPI DATABASE

Select * from CPI.dbo.CustomerTitleEditionProperty as p
inner join CPI.dbo.CustomerTitleEdition as ct on p.TitleEditionRelationshipID = ct.CustomerTitleEditionID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID
DELETE P from CPI.dbo.CustomerTitleEditionProperty AS p
inner join CPI.dbo.CustomerTitleEdition as ct on p.TitleEditionRelationshipID = ct.CustomerTitleEditionID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID

Select * from CPI.dbo.CustomerAvails as v
inner join CPI.dbo.CustomerTitleEdition as ct on v.TitleEditionRelationshipID = ct.CustomerTitleEditionID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID
DELETE V from CPI.dbo.CustomerAvails as v
inner join CPI.dbo.CustomerTitleEdition as ct on v.TitleEditionRelationshipID = ct.CustomerTitleEditionID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID

select * from CPI.DBO.CustomerAsset as ca
inner join [CPI].[dbo].[CustomerTitleEdition] as ct on ct.CustomerTitleEditionID = ca.CustomerTitleEditionID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID
DELETE CA from CPI.DBO.CustomerAsset as ca
inner join [CPI].[dbo].[CustomerTitleEdition] as ct on ct.CustomerTitleEditionID = ca.CustomerTitleEditionID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID

select * from CPI.DBO.CustomerTitleEditionAlternativeName AS an
inner join [CPI].[dbo].[CustomerTitleEdition] as ct on ct.CustomerTitleEditionID = an.TitleEditionRelationshipID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID
DELETE AN from CPI.DBO.CustomerTitleEditionAlternativeName AS an
inner join [CPI].[dbo].[CustomerTitleEdition] as ct on ct.CustomerTitleEditionID = an.TitleEditionRelationshipID
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID

Select * from CPI.dbo.CustomerTitleEdition as ct
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID
DELETE CT from CPI.dbo.CustomerTitleEdition as ct
inner join [AssetLibrary].[dbo].ALTitleEdition as at on ct.TitleEditionID = 'te1-' + CONVERT(varchar(20), at.titleeditionid)
where at.TitleID = @TitleID


--ASSETLIBRARY DATABASE

select * from [AssetLibrary].[dbo].[ALElemStreamProperty] (NOLOCK) where ElemStreamID in 
(Select ElemStreamID from [AssetLibrary].[dbo].[ALElemStream] (NOLOCK) where StreamID in
(select StreamID from AssetLibrary.dbo.ALStream (NOLOCK) where AssetID in 
(Select AssetID from AssetLibrary.dbo.ALTitleAsset (NOLOCK) where TitleID = @TitleID)))
DELETE FROM [AssetLibrary].[dbo].[ALElemStreamProperty] WHERE ElemStreamID in 
(SELECT ElemStreamID FROM [AssetLibrary].[dbo].[ALElemStream] (NOLOCK) WHERE StreamID in
(SELECT StreamID FROM AssetLibrary.dbo.ALStream (NOLOCK) WHERE AssetID in 
(SELECT AssetID FROM AssetLibrary.dbo.ALTitleAsset (NOLOCK) WHERE TitleID = @TitleID)))

SELECT * FROM [AssetLibrary].[dbo].[ALElemStreamBaseLocation] (NOLOCK) WHERE ElemStreamID IN
(Select ElemStreamID from [AssetLibrary].[dbo].ALElemStream (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)))
DELETE FROM [AssetLibrary].[dbo].[ALElemStreamBaseLocation] WHERE ElemStreamID IN
(Select ElemStreamID from [AssetLibrary].[dbo].ALElemStream (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)))

Select * from [AssetLibrary].[dbo].ALStreamFile (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))
DELETE FROM [AssetLibrary].[dbo].ALStreamFile where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))

--new
Select * from [AssetLibrary].[dbo].ALElemStreamLanguage (NOLOCK) where ElemStreamID in 
(select ElemStreamID from [AssetLibrary].[dbo].ALElemStream (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)))
DELETE FROM [AssetLibrary].[dbo].ALElemStreamLanguage where ElemStreamID in 
(select ElemStreamID from [AssetLibrary].[dbo].ALElemStream (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)))

Select * from [AssetLibrary].[dbo].ALStreamLanguage (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))
DELETE FROM [AssetLibrary].[dbo].ALStreamLanguage where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))


Select * from [AssetLibrary].[dbo].ALElemStream (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))
DELETE FROM [AssetLibrary].[dbo].ALElemStream where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))


select * from [AssetLibrary].[dbo].ALStreamBaseLocation (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))
DELETE from [AssetLibrary].[dbo].ALStreamBaseLocation where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))

select * from [AssetLibrary].[dbo].ALStreamProperty (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))
DELETE from [AssetLibrary].[dbo].ALStreamProperty where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))

select * from [AssetLibrary].[dbo].ALStreamLanguage (NOLOCK) where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))
DELETE from [AssetLibrary].[dbo].ALStreamLanguage where StreamID in 
(select StreamID from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID))

select * from [AssetLibrary].[dbo].ALStream (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALStream where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALAssetProperty (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALAssetProperty where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALAssetNote (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALAssetNote where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALAssetMRProvider (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALAssetMRProvider where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALAssetMRMatch (NOLOCK) where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALAssetMRMatch where AssetID in 
(Select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID)

DECLARE @TempAssetIDs TABLE ( AssetID int )
INSERT INTO @TempAssetIDs (AssetID)
select AssetID from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID

select * from [AssetLibrary].[dbo].ALTitleAsset (NOLOCK) where TitleID = @TitleID
DELETE from [AssetLibrary].[dbo].ALTitleAsset where TitleID = @TitleID

select * from [AssetLibrary].[dbo].ALTitleEditionAsset (NOLOCK) where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALTitleEditionAsset where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALAsset (NOLOCK) where AssetID in 
(Select AssetID from @TempAssetIDs)
DELETE from [AssetLibrary].[dbo].ALAsset where AssetID in 
(Select AssetID from @TempAssetIDs)

select * from [AssetLibrary].[dbo].ALTitleEditionProperty (NOLOCK) where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALTitleEditionProperty where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALTitleEditionMRProvider (NOLOCK) where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALTitleEditionMRProvider where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALTitleEditionMRMatch (NOLOCK) where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)
DELETE from [AssetLibrary].[dbo].ALTitleEditionMRMatch where TitleEditionID in 
(select TitleEditionID from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID)

select * from [AssetLibrary].[dbo].ALTitleProperty (NOLOCK) where TitleID = @TitleID
DELETE from [AssetLibrary].[dbo].ALTitleProperty where TitleID = @TitleID

select * from [AssetLibrary].[dbo].ALTitleMRProvider (NOLOCK) where TitleID = @TitleID
DELETE from [AssetLibrary].[dbo].ALTitleMRProvider where TitleID = @TitleID

select * from [AssetLibrary].[dbo].ALTitleMRMatch (NOLOCK) where TitleID = @TitleID
DELETE from [AssetLibrary].[dbo].ALTitleMRMatch where TitleID = @TitleID

select * from [AssetLibrary].[dbo].ALTitleEdition (NOLOCK) where TitleID = @TitleID
DELETE from [AssetLibrary].[dbo].ALTitleEdition where TitleID = @TitleID

select * from [AssetLibrary].[dbo].ALTitle (NOLOCK) where TitleID = @TitleID
DELETE from [AssetLibrary].[dbo].ALTitle where TitleID = @TitleID

COMMIT TRANSACTION

END TRY

BEGIN CATCH
DECLARE @ERRORMESSAGE VARCHAR(500)
SET @ERRORMESSAGE = ERROR_MESSAGE() + ' ROLLBACK TRANSACTION. '
ROLLBACK TRANSACTION
RAISERROR (@ERRORMESSAGE, 16, 1)
END CATCH
GO
