USE CPI
SELECT TOP (5000)  CT.TitleId, MT.MovieTitle, CTE.CustomerTitleID, CTE.Status, CTE.Active, CTE.Version, CA.AssetID, T.AssetName, CAT.RuleName, CA.Status, CA.IsDeleted, 
				C.CustomerID, GETUTCDATE() as UTC_DateTime, CA.ALCreationDate+C.CreatedPurgeDays as CalcALCreationPurgeDate, CA.VODExpireOn+C.ExpiredPurgeDays as CalcExpiredPurgeDate, 
				  -- CTE.VODAvailableOn, CTE.VODExpireOn, CTE.ESTAvailableOn, CTE.ESTExpireOn, CT.CreatedDateTime, 
				  CA.ALCreationDate, CA.VODAvailableOn, CA.VODExpireOn, CA.IsSelected, CA.CreatedDateTime, CA.UpdatedDateTime, CA.ESTAvailableOn, CA.ESTExpireOn, CA.FreeAvailableOn, CA.FreeExpireOn, CA.EpisodeNumber, 
				  C.CustomerName, C.IgnoreDates, C.RequireContentReview, C.RequireMetadata, C.CreatedPurgeDays, C.ExpiredPurgeDays
FROM   CustomerAsset CA LEFT OUTER JOIN CustomerTitleEdition CTE ON CA.CustomerTitleEditionID = CTE.CustomerTitleEditionID 
						LEFT OUTER JOIN CustomerTitle CT ON CTE.CustomerTitleID = CT.CustomerTitleID 
						LEFT OUTER JOIN Customer C ON CT.CustomerID = C.CustomerID
						LEFT OUTER JOIN CustomerAssetType CAT on CA.CustomerAssetTypeID = CAT.CustomerAssetTypeID
						LEFT OUTER JOIN OrderProcessing.dbo.Title T on CA.AssetID = T.ALAssetId
						LEFT OUTER JOIN OrderProcessing.dbo.MasterTitle MT on T.MasterTitleId = MT.MasterTitleId
Where CA.IsDeleted in (0) 
-- and (C.CreatedPurgeDays != 0 or C.ExpiredPurgeDays != 0) 
-- and ( GETUTCDATE() >= CA.ALCreationDate+C.CreatedPurgeDays  or  GETUTCDATE() >= CA.VODExpireOn+C.ExpiredPurgeDays ) 
-- and ( GETUTCDATE() < CA.ALCreationDate+C.CreatedPurgeDays  or  GETUTCDATE() < CA.VODExpireOn+C.ExpiredPurgeDays ) 
 and C.CustomerID  in (26) -- (1,5,22,23,24,25,26,29,31,33) -- 1,2,3,4,5,6,7,22,23,24,25,26,27,29,30,31,32,33,35,36,37,38 
-- and  (T.ALAssetId  in ('a1-39674','a1-88192','a1-88193','a1-90942') )
-- and CT.Status in ('Complete','Incomplete')
-- and RuleName in ('Features')
-- and CA.Status in ('Complete')
-- and CT.TitleID in ('t1-17495','t1-18181','t1-9063') -- 
-- and MT.MovieTitle like 'QA_Smoke%'
Order by CT.TitleID, AssetId, CustomerId

USE CPI
 Select Customer.CustomerID, Customer.CustomerName, CreatedPurgeDays, ExpiredPurgeDays from Customer where CustomerId in (55)
-- Update Customer Set CreatedPurgeDays = ROUND(RAND()*100,0), ExpiredPurgeDays = ROUND(RAND()*5,0)  where CustomerId <> 26
-- Update Customer Set CreatedPurgeDays = 90, ExpiredPurgeDays = 90 where CustomerId = 26
-- select * from CustomerAsset CA where CA.AssetID  in ('a1-32789','a1-32792','a1-32793','a1-32794','a1-32795','a1-32796','a1-32797') 
-- select * from CustomerTitle where TitleId in ('t1-12472')
-- select GETUTCDATE() as UTC_DateTime
-- select * from cpi..CPIStatusReasonLookup
-- select * from cpi..CPIAssetSubStateLookup
/*
CustomerID	CustomerName
1	Deluxe Digital Distributions
2	Zip.ca
3	Blockbuster
4	Dish
5	Starz
6	LGE
22	MoviePlex
23	Encore
24	Sensio
25	Barnes and Noble
26	Charter
27	B&N Test
28	Trial Customer
29	Sandbox
30	Spirit Clips
31	Rogers
32	Choose Digital
33	Omni
34	MobiTV
35	Samsung
36	Vudu
37	Cineplex
38	Spigot


DECLARE @customer AS int
SET @customer = 1
WHILE (@customer <= 38)
BEGIN
	Update Customer Set CreatedPurgeDays = ROUND(RAND()*500,0), ExpiredPurgeDays = ROUND(RAND()*10,0)  where CustomerId = @customer
	SET @customer = @customer + 1
End


*/
