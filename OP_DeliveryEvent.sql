Use OrderProcessing
SELECT E.ContentID, E.CustomerID, E.WorkflowInstanceID, E.Message, dateadd(hour, datediff(hour, getutcdate(), getdate()), E.CreatedDateTime) [CreatedDateTime]
FROM [OrderProcessing].[dbo].[DeliveryEvent] E with(nolock)
--where E.ContentID = '3765f2e6-2048-45b9-96d3-736e4f13c271'
order by E.CreatedDateTime desc

/*
truncate table [OrderProcessing].[dbo].[DeliveryEvent]
*/

SELECT EM.ErrorMessage, E.ContentID, E.CustomerID, E.TitleID, E.DeliveryWorkflowRequest, dateadd(hour, datediff(hour, getutcdate(), getdate()), EM.CreatedDateTime) [CreatedDateTime]
FROM [OrderProcessing].[dbo].[DeliveryErrorLog] E WITH(NOLOCK)
LEFT OUTER JOIN [OrderProcessing].[dbo].[DeliveryErrorLogMessage] EM WITH(NOLOCK) ON EM.DeliveryErrorLogID = E.DeliveryErrorLogID

/*
truncate table [OrderProcessing].[dbo].[DeliveryErrorLogMessage]
truncate table [OrderProcessing].[dbo].[DeliveryErrorLog]
*/

SELECT TOP 1000 [CustomerPackageDataID], [CustomerID], [PackageData], [PackageType], [PackageID], [PackageSubID], [PackageVersion], [ALTitleID], [DeliveryDateTimeUTC], [IsDeleted], [CreatedDateTime], [CreatedBy], [UpdatedDateTime], [UpdatedBy]
  FROM [CPI].[dbo].[CustomerPackageData]
--  WHERE 
--  PackageID = 'u/QA2/Assets/a1/C2/A7/a1-53454/s1-382277/a1-53454-s1-382263-v1-2001.M2TS' 
--  and PackageSubID = 'a1-53454'
order by DeliveryDateTimeUTC desc