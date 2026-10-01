
-- Insert Answers ---
-- USD
Declare @MyTemplayeId UNIQUEIDENTIFIER;
Declare @MySurveyId UNIQUEIDENTIFIER;
Declare @Currency VARCHAR(5);
Declare @Env VARCHAR(3);
Select  @Env = 'uat' -- 'dev'

Select @Currency = 'USD';
Select @MyTemplayeId = TemplateId from Templates Where Name like '%SurveyAndIncidentReport' and Currency like @Currency+'%';
Select @MySurveyId = NewID();
Insert Into Answers (TemplateId, Answers, SurveyId, SurveyURL, EmployeeNumber, EmployeeEmail, EmployeeName, ProfitCenterNumber, ProfitCenterName, ViewedSurvey, DateEmailSent, AnsweredSurvey, Month, Quarter, Year, CreateDate, ModifiedDate, IsActive, Currency) Values (@MyTemplayeId, NULL, @MySurveyId, CONCAT('https://grs-',@Env,'.bbrownretapps.com/survey/',@MyTemplayeId,'/'), '484848', 'luis.talavera@bbrown.com', 'Luis Talavera', '621', '621 Risk Solutions', 0, NULL, 0, MONTH(GETDATE()), 'Q2', YEAR(GETDATE()), CAST(GETDATE() AS DateTime), NULL, 1, @Currency);

-- CAD
Select @Currency = 'CAD';
Select @MyTemplayeId = TemplateId from Templates Where Name like '%SurveyAndIncidentReport' and Currency like @Currency+'%';
Select @MySurveyId = NewID();
Insert Into Answers (TemplateId, Answers, SurveyId, SurveyURL, EmployeeNumber, EmployeeEmail, EmployeeName, ProfitCenterNumber, ProfitCenterName, ViewedSurvey, DateEmailSent, AnsweredSurvey, Month, Quarter, Year, CreateDate, ModifiedDate, IsActive, Currency) Values (@MyTemplayeId, NULL, @MySurveyId, CONCAT('https://grs-',@Env,'.bbrownretapps.com/survey/',@MyTemplayeId,'/'), '484848', 'luis.talavera@bbrown.com', 'Luis Talavera', '784', '784 Waterloo (CLIS)', 0, NULL, 0, MONTH(GETDATE()), 'Q2', YEAR(GETDATE()), CAST(GETDATE() AS DateTime), NULL, 1, @Currency);

-- GBP
Select @Currency = 'GBP';
Select @MyTemplayeId = TemplateId from Templates Where Name like '%SurveyAndIncidentReport' and Currency like @Currency+'%';
Select @MySurveyId = NewID();
Insert Into Answers (TemplateId, Answers, SurveyId, SurveyURL, EmployeeNumber, EmployeeEmail, EmployeeName, ProfitCenterNumber, ProfitCenterName, ViewedSurvey, DateEmailSent, AnsweredSurvey, Month, Quarter, Year, CreateDate, ModifiedDate, IsActive, Currency) Values (@MyTemplayeId, NULL, @MySurveyId, CONCAT('https://grs-',@Env,'.bbrownretapps.com/survey/',@MyTemplayeId,'/'), '484848', 'luis.talavera@bbrown.com', 'Luis Talavera', '938', '938 HFIS Limited', 0, NULL, 0, MONTH(GETDATE()), 'Q2', YEAR(GETDATE()), CAST(GETDATE() AS DateTime), NULL, 1, @Currency);

Select T.Name, T.Currency, A.* from Answers A Left Outer Join Templates T on A.TemplateId = T.TemplateId
Where A.IsActive in (0,1) and AnsweredSurvey in (0,1) -- 
And A.Currency in ('USD','CAD','GBP')
And EmployeeEmail='luis.talavera@bbrown.com' 
And Month = MONTH(GETDATE())
Order by T.Name, CreateDate desc;

-- Delete Answers Where Id = '507647'
