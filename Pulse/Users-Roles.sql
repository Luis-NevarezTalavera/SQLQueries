Select * from AspNetUsers Where Email like 'kati%' ;
Select * From AspNetUserRoles;
Select * from AspNetRoles where Name in ('Agent') -- 'Admin', 'Agent', 'CSR', 'Individual', 'Underwriter'
Select * from AspNetUserTokens;
Select * from AspNetUserClaims where ClaimType  in ('UWVerified','enabledMfa','agencyId','AgentId','InsuredId'); -- and UserId='D6BE3890-75D0-459C-281D-08DE3CB7B6A7'  -- ClaimValue='6CDB05C9-A61A-4283-D7BA-08DE3E6724E6'; -- and 
Select * from Agencies;
Select * from Agents order by Lastname, FirstName;
Select * from Insureds Where InsuredName like 'katie%' ;
Select * from InsuredAgencies;

Select Id, Username, InsuredName, FirstName, MiddleName, LastName, Email, CreateDate, CreatedBy 
From Insureds 
 Where InsuredName like 'Agent%' 
Order by InsuredName;

-- Delete  AspNetUserClaims Where Id=310;

Select  U.ID, U.FirstName, U.LastName, U.UserName, U.Email as UserEmail, I.UserName as InsuredUserName, I.Email as InsuredEmail, U.PhoneNumber, U.SelfRegistered, U.EmailConfirmed, U.UWVerified, U.LastLoginDateTime, U.LockoutEnd, 
AI.Name as InsuredAgencyName, R.Name as RoleName, C.ClaimType, U.TwoFactorEnabled, U.AccessFailedCount, U.LockoutEnabled, U.LockoutEnd, U.AgentId, U.IsActive, U.PasswordHash
-- T.Name as TokenName, T.Value as TokenValue, 
From AspNetUsers U  Left Outer Join AspNetUserRoles UR on U.Id = UR.UserId
                    Left Outer Join AspNetRoles R on UR.RoleId = R.Id
                    -- Left Outer Join AspNetUserTokens T on U.Id = T.UserId
                    Left Outer Join AspNetUserClaims C on U.Id = C.UserId
                    Left Outer Join Insureds I on U.Id = I.UserId
                    Left Outer Join InsuredAgencies IA on I.Id = IA.InsuredId
                    Left Outer Join Agencies AI on IA.AgencyId = AI.Id
                    Left Outer Join Agencies G on C.ClaimValue = G.Id and C.ClaimType='AgencyId'
                    Left Outer Join Agents A   on C.ClaimValue = A.Id and C.ClaimType='AgentId'  
Where U.UWVerified in (0,1)
    and U.EmailConfirmed in (0,1)
    -- and U.TwoFactorEnabled in (0,1)
    -- and U.LastLoginDateTime Is Null
    -- and R.Name != 'Individual' -- in ('Agent', 'Admin', 'Individual', 'Underwriter') -- 'CSR') -- 
    -- and T.Name != 'AuthenticatorKey' -- is Null
    and U.email like 'katie@%' -- = 'luis.nevarez@mailsac.com' -- U.UserName like 'jj%' --
    -- and C.ClaimType in ('InsuredId') -- 'AgencyId','AgentId','InsuredId') -- = 'UWVerified' -- C.ClaimType Is Null --
    -- and U.ID='D6C95FB6-BE02-4686-87E2-08DDB8A09B20'
Order by  U.UserName -- R.Name -- U.LastLoginDateTime desc --


/* Inser rows at AspNetUserClaims
Declare @email NVARCHAR(100);
Set @email = 'luis.nevarez@mailsac.com';
 Insert Into AspNetUserClaims (UserId, ClaimType, ClaimValue) values ((Select Id from AspNetUsers Where email = @email), 'InsuredId', (Select Id from Insureds Where Email = @email));
 Insert Into AspNetUserClaims (UserId, ClaimType, ClaimValue) values ((Select Id from AspNetUsers Where email = @email), 'UWVerified', 'true');
 Insert Into AspNetUserClaims (UserId, ClaimType, ClaimValue) values ((Select Id from AspNetUsers Where email = @email), 'agencyId', (Select Id from Agencies Where Name = 'Nevarez Agency'));
*/

/* Delete a USER
Declare @user NVARCHAR(100);
Set @user = 'jimmy.james@mailsac.com';
Delete from AspNetUserTokens Where UserId in (Select Id from AspNetUsers Where Username = @user);
Delete from AspNetUserRoles Where UserId in (Select Id from AspNetUsers Where Username  = @user);
Delete from AspNetUserClaims Where UserId in (Select Id from AspNetUsers Where Username  = @user);
Delete from AspNetUsers Where Username = @user;
Delete from InsuredAgencies WHERE InsuredId IN (SELECT Id FROM Insureds WHERE Username = @user);
Delete from Insureds WHERE Username = @user;
*/

-- Update AspNetUsers Set LockoutEnd = Null Where Username = 'luis.talavera@bbrown.com';
-- Update AspNetUsers Set Username='Johanna.qajuaadmin',AccessFailedCount=0, LockoutEnd=Null Where Username in ( 'Johanna.qajuaadmin@mailsac.com'); 
-- Update AspNetUsers Set Email='Agent.QA@mailsac.com' Where Email like 'Agent.QA@maailsaac.com'; -- TwoFactorEnabled=1
-- Update Insureds Set UserName='luis.nevarez@mailsac.com', phone='760-213-2483', InsuredAddress_Email='luis.nevarez@mailsac.com', AgencyId='6CDB05C9-A61A-4283-D7BA-08DE3E6724E6' Where InsuredName = 'Nevarez, Luis';
-- Update Insureds Set phone='760-213-2483'Where InsuredName like  '%Nevarez%';

-- Update Agents Set Email='Agent.QA@mailsac.com' Where Email like 'Agent.QA@maailsaac.com';
-- Update AspNetUserRoles Set RoleId = (Select Id from AspNetRoles Where Name = 'CSR') Where UserId in (Select Id from AspNetUsers Where Username = 'luis.nevarez.talavera@outlook.com');

-- Delete from AspNetUserRoles Where AspNetUserRoles.RoleId = (Select Id from AspNetRoles Where Name = 'Admin') and UserId in (Select Id from AspNetUsers Where Username  = 'luis.nevarez.1966@gmail.com');
