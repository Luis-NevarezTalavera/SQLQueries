Use OrderProcessing
SELECT C.ProviderName, E.WorkflowInstanceID, E.SourceName,  E.Message, dateadd(hour, datediff(hour, getutcdate(), getdate()), E.CreatedDateTime) [CreatedDateTime] ,E.IngestionLogEventID
FROM [OrderProcessing].[dbo].[IngestionEvent] E with(nolock)
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH(NOLOCK) ON C.ContentProviderID = E.ContentProviderID
WHERE 
dateadd(hour, datediff(hour, getutcdate(), getdate()), E.CreatedDateTime) >= '11/03/2014'
--and WorkflowInstanceID = '1ED23390-C91D-48F7-A0FB-B9206F83D123'
--SourceName like '%jumpingthe%'
--[Message] like '%just go%'
order by e.CreatedDateTime DESC
