USE AssetLibrary
Select DISTINCT TOP (100000) AV.VariantId, AV.VariantName, C.CustomerID, C.CustomerName, VT.LookupValue as VariantType -- AV.Description, 
From	ALVariant AV	LEFT OUTER JOIN CPI..CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),AV.VariantId) = CV.VariantId 
						LEFT OUTER JOIN CPI..Customer C ON CV.CustomerID = C.CustomerID
						LEFT OUTER JOIN ALVariantTypeLookup VT on AV.VariantTypeID = VT.LookupID
Where	AV.IsDeleted=0  and C.IsDeleted=0
-- and C.CustomerName = 'Charter'
-- and VariantTypeID in (4,5,6,7,8)
-- and AV.VariantId in (271)
Order by AV.VariantId, C.CustomerID desc
-- select * from CPI..Customer
-- select * from AssetLibrary..ALVariantTypeLookup
-- select * from AlVariant

select * from CPI..CustomerVariant where IsDeleted=0 

Select Distinct C.CustomerID, CustomerName  
From CPI..CustomerVariant CV Inner Join CPI..Customer C on CV.CustomerID = C.CustomerID 
Where CV.IsDeleted=0  -- and Required=1
order by CustomerId