-- Query to Obtain the Parent L1 streams for a specific assetId/L2 streamId, also with the corresponding ALConfiguration records
Use QATest
Drop Table VariantsByCustomer
Select VariantID, VariantName, Description, VariantLevel, CustomerID, CustomerName, Priority, Weight, ROW_NUMBER() OVER(Partition by VariantID Order by Weight desc) AS VarCustPiority INTO VariantsByCustomer
From (	SELECT	SC.VariantID, V2.VariantName, V2.Description, 'L2' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
		FROM	AssetLibrary..ALVariant V2 Left Outer Join AssetLibrary..ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
								Left Outer Join AssetLibrary..ALVariant V1 on V1.VariantID = SC.SourceVariantID
								Left Outer Join AssetLibrary..ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
								LEFT OUTER JOIN CPI..CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
								LEFT OUTER JOIN CPI..Customer Cu ON CV.CustomerID = Cu.CustomerID
								LEFT OUTER JOIN CustomerPriority CP ON CV.CustomerID = CP.CustomerID
		Where	C.StreamLevel = 2 
		 and SC.VariantID  >= 26 
		 and Cu.CustomerId Is Not Null 
		UNION 
		SELECT	SC.SourceVariantID as VariantID, V1.VariantName, V1.Description, 'L1' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
		FROM	AssetLibrary..ALVariant V2 Left Outer Join AssetLibrary..ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
								Left Outer Join AssetLibrary..ALVariant V1 on V1.VariantID = SC.SourceVariantID
								Left Outer Join AssetLibrary..ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
								LEFT OUTER JOIN CPI..CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
								LEFT OUTER JOIN CPI..Customer Cu ON CV.CustomerID = Cu.CustomerID
								LEFT OUTER JOIN CustomerPriority CP ON CV.CustomerID = CP.CustomerID
		Where	C.StreamLevel = 2 
		 and SC.VariantID  >= 26 
 	 	 and Cu.CustomerId Is Not Null 
		 ) VariantsByCustomer
Order by VariantID, Weight desc

-- Select VariantID, VariantName, Description, VariantLevel, Max(CustomerID) as CustomerID, Max(CustomerName) as CustomerName, Max(Priority) as Priority, Max(Weight) as Weight 
Select VariantID, VariantName, Description, VariantLevel, CustomerID, CustomerName, Priority, Weight
From VariantsByCustomer
Where VarCustPiority = 1

-- select * from VariantsByCustomer
-- select * from CustomerPriority