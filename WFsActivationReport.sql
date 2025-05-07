/****** IF YOU SEE L2 PACKAGING STREAMS THAT ARE NOT ACTIVATED IT IS NORMAL SINCE THE WF IS EXECUTING STILL  ******/
DECLARE @CHECKTIME DATETIME
SET @CHECKTIME = DATEADD(MINUTE, 59, DATEADD(HOUR, 6, GETDATE()))

SELECT @CHECKTIME AS CHECKTIME, DATEADD(HOUR, 7, GETDATE()) AS [NOW], '1 MINUTE CHECK' AS CHECK_DELAY ,
 (SELECT COUNT ([InstanceId]) FROM [OP_Persistence].[System.Activities.DurableInstancing].[Instances] WITH(NOLOCK) WHERE ServiceDeploymentId = 2) AS INSTANCES,
 (SELECT COUNT ([InstanceId]) FROM [OP_Persistence].[System.Activities.DurableInstancing].[Instances] WITH(NOLOCK) WHERE ServiceDeploymentId = 2 AND LastUpdatedTime >= @CHECKTIME) AS ACTIVATED,
 (SELECT COUNT ([InstanceId]) FROM [OP_Persistence].[System.Activities.DurableInstancing].[Instances] WITH(NOLOCK) WHERE ServiceDeploymentId = 2 AND LastUpdatedTime < @CHECKTIME) AS NOT_ACTIVATED

SELECT * FROM [OP_Persistence].[System.Activities.DurableInstancing].[Instances]
  WHERE ServiceDeploymentId = 15 AND LastUpdatedTime < @CHECKTIME
 
SELECT OPTITLE.TitleId, OPTITLE.ALAssetId, OPTITLE.AssetName, OPSTATE.DisplayName, OPTITLE.WorkflowInstanceId, INSTANCE.SurrogateInstanceId
FROM [OrderProcessing].[dbo].[Title] AS OPTITLE WITH(NOLOCK)
 INNER JOIN [OrderProcessing].[dbo].[TitleState] AS OPSTATE WITH(NOLOCK) ON OPTITLE.TitleStateId = OPSTATE.TitleStateId
 Left JOIN [OP_Persistence].[System.Activities.DurableInstancing].[InstancesTable] AS INSTANCE WITH(NOLOCK) ON [INSTANCE].[ID] = OPTITLE.WorkflowInstanceId
 WHERE WorkflowInstanceId IN (SELECT InstanceId FROM [OP_Persistence].[System.Activities.DurableInstancing].[Instances] WITH(NOLOCK) WHERE ServiceDeploymentId = 2 AND LastUpdatedTime < @CHECKTIME) 
 ORDER BY AssetName
