SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' 
  -- and TABLE_NAME like '%Document%'
ORDER BY TABLE_NAME;

SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME  in ('ADUsers','Users','ProfitCenters','PCExceptions','ProfitCenterSilos')
ORDER BY TABLE_NAME;

EXEC sp_help 'ADUsers';

/*
TABLE_NAME
__EFMigrationsHistory
ADUsers
Answers
CommandLog
DbUserPermissionsAudit
PCExceptions
ProfitCenters
ProfitCenterSilos
Queue
Templates
Users
UsersStatusNotActive
*/
