Use AssetLibrary
select v2.VariantID as L2vID, v2.VariantName, v2.VariantTypeID, L1.LookupValue, SC.ConfigurationID, c.Name, v2.AudioChannels, v2.VideoResolution, v2.VideoAspectRatio, v2.IsAdaptive, v1.VariantID as L1vID, v1.Description, v1.AudioChannels, v1.VideoResolution, v2.VideoAspectRatio, SC.OrderNumber, v1.IsTrickPlay
					from ALVariant v2	Inner Join ALStreamSourceConfiguration SC on v2.VariantID=SC.VariantID
										Inner Join ALVariant v1 on SC.SourceVariantID = v1.VariantID
										Left Outer Join ALConfiguration C ON SC.ConfigurationID = C.ConfigurationID
										Left Outer Join ALVariantTypeLookup L1 ON v2.VariantTypeID = L1.LookupID
Where -- C.ConfigurationID in (6,7,10,12)  -- (6) WV -- (7) PR -- (10) DTS -- (12) CableLabs
  V2.VariantId in (428,429,430) -- (2510,2511,2512,2513) -- 
--  and SourceVariantID in (427)
order by v2.VariantID, SC.OrderNumber, v1.VariantID desc
 
-- Select * from ALVariant where VariantId in (428,429,430)
-- Select * from ALStreamSourceConfiguration where VariantId in (2510,2511,2512,2513) and SourceVariantID in (417)


--update ALStreamSourceConfiguration set SourceVariantID = '228' where VariantID='312' and SourceVariantID='117'
