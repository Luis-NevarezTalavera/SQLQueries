SET Client_Encoding = 'UTF8';

DROP TABLE public."Member" CASCADE;
CREATE TABLE public."Member"
(
    MemberId INTEGER PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	Email VARCHAR(100),
	Street VARCHAR(100),
	City VARCHAR(100) NOT NULL DEFAULT 'Corona',
	State VARCHAR(2) NOT NULL DEFAULT 'CA',
	ZipCode VARCHAR(5),
	Phone VARCHAR(15) NOT NULL,
	Birthday DATE DEFAULT '1900-01-01',
	Gender INTEGER NOT NULL,
	Status INTEGER NOT NULL DEFAULT 0,
	MaritalStatus INTEGER NOT NULL,
	CreatedDate DATE DEFAULT Current_date,
	UpdatedDate DATE DEFAULT '1900-01-01',
	UpdatedBy VARCHAR (50) DEFAULT 'LifeGroups'
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public."Member"
    OWNER to postgres;

--------------------------

DROP TABLE public."Group" CASCADE;
CREATE TABLE public."Group"
(
    GroupId INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	GroupType INTEGER NOT NULL DEFAULT 1,
	Age INTEGER NOT NULL DEFAULT 1,
	GroupName VARCHAR(100),
	CoachLeaderId INTEGER NOT NULL,
	DirectorLeaderId INTEGER NOT NULL,
	MeetingPeriodicity INTEGER NOT NULL DEFAULT 0,
	MeetingDoW INTEGER NOT NULL,
	MeetingTime TIME NOT NULL DEFAULT '07:00 PM',
	Street VARCHAR(100),
	City VARCHAR(100) NOT NULL DEFAULT 'Corona',
	State VARCHAR(2) NOT NULL DEFAULT 'CA',
	ZipCode VARCHAR(5),
	Comment VARCHAR(100),
	Status INTEGER NOT NULL DEFAULT 0,
	CreatedDate DATE NOT NULL DEFAULT Current_date,
	UpdatedDate DATE,
	UpdatedBy VARCHAR (50) DEFAULT 'LifeGroups'
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public."Group"
    OWNER to postgres;

--------------------------

DROP TABLE public."Enrollment";
CREATE TABLE public."Enrollment"
(
    EnrollmentId INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	MemberId INTEGER NOT NULL REFERENCES public."Member"(MemberId),
	GroupId INTEGER NOT NULL REFERENCES public."Group"(GroupId),
	Status INTEGER NOT NULL,
	LeaderStatus INTEGER NOT NULL,
	Comment VARCHAR(200),
	EnrollmentDate DATE NOT NULL DEFAULT Current_date, 
	UpdatedDate DATE,
	UpdatedBy VARCHAR (50) DEFAULT 'LifeGroups'
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public."Enrollment"
    OWNER to postgres;

--------------------------

DROP TABLE public."Leader";
CREATE TABLE public."Leader"
(
    LeaderId INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	LeaderType INTEGER NOT NULL,
	MemberId INTEGER NOT NULL REFERENCES public."Member"(MemberId),
	Comment VARCHAR(100),
	Status VARCHAR(20) NOT NULL,
	CreatedDate DATE NOT NULL DEFAULT Current_date,
	UpdatedDate DATE,
	UpdatedBy VARCHAR (50) DEFAULT 'LifeGroups'
)
TABLESPACE pg_default;
ALTER TABLE IF EXISTS public."Leader"
    OWNER to postgres;
