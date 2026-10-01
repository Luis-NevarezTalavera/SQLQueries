-- SQL script to Update Insurance Applications table, Questions field with the Updated Application Template Form

Update InsuranceApplications Set ApplicationQuestions=(Select Form from ApplicationTemplates Where TemplateName='Physician Surgeon Application' and IsActive=1) Where CategoryId=(Select Id from Categories Where CategoryName='PhysicianSurgeon');
Update InsuranceApplications Set ApplicationQuestions=(Select Form from ApplicationTemplates Where TemplateName='Healthcare Pro Application' and IsActive=1) Where CategoryId=(Select Id from Categories Where CategoryName='HealthCareProfessional');
Update InsuranceApplications Set ApplicationQuestions=(Select Form from ApplicationTemplates Where TemplateName='Facilities Application' and IsActive=1) Where CategoryId=(Select Id from Categories Where CategoryName='FacilityApp');
