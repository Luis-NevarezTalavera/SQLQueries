/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[ServiceDeploymentHash]
      ,[SiteName]
      ,[RelativeServicePath]
      ,[RelativeApplicationPath]
      ,[ServiceName]
      ,[ServiceNamespace]
  FROM [OP_Persistence].[System.Activities.DurableInstancing].[ServiceDeploymentsTable]