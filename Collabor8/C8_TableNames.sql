SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' 
  -- and TABLE_NAME like '%Document%'
ORDER BY TABLE_NAME;

SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME  in ('Set')
ORDER BY TABLE_NAME;

EXEC sp_help 'Set';

Select * from ActivityLogs;

Select * from ClientFileLogs;
Select * from NotificationLogs;
Select * from FolderUserNotifications;
Select * from [HangFire].[Set];
Select * from [HangFire].[State];


/*
TABLE_NAME
__EFMigrationsHistory
ActivityLogs
AggregatedCounter
ClientFileLogs
ClientFiles
ClientFolders
Clients
Counter
FolderUserNotifications
Hash
Job
JobParameter
JobQueue
Links
List
NotificationLogs
Roles
Schema
Server
Set
State
UserClients
UserRoles
UserRootFolders
Users
*/
