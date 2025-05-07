 -- L2 Variants per Customer
 Use CPI
Select Distinct CONVERT(int,(SUBSTRING(CV.VariantID,4,4))) AS VariantID, V.Description, V.VariantName, CV.CustomerID, C.CustomerName 
From  CPI.dbo.CustomerVariant CV LEFT OUTER JOIN CPI.dbo.Customer C	WITH (NOLOCK) ON CV.CustomerID 	= C.CustomerID
								 LEFT OUTER JOIN AssetLibrary.dbo.ALVariant V (NOLOCK) ON SUBSTRING(CV.VariantID,4,4) = V.VariantID
Where C.CustomerID is not Null
Order by CONVERT(int,(SUBSTRING(CV.VariantID,4,4))), CV.CustomerID, C.CustomerName 