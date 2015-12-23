

/****** Object:  Table [bluebin].[BlueBinUser]    Script Date: 10/2/2015 8:34:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if not exists (select * from sys.tables where name = 'MasterLog')
BEGIN
CREATE TABLE [bluebin].[MasterLog](
	[MasterLogID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[BlueBinUserID] int NOT NULL,
	[ActionType] varchar (30) NULL,
    [ActionName] varchar (60) NULL,
	[ActionID] int NULL,
	[ActionDateTime] datetime not null
)
END
GO

if not exists (select * from sys.tables where name = 'Config')
BEGIN
CREATE TABLE [bluebin].[Config](
	[ConfigID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[ConfigName] varchar (30) NOT NULL,
	[ConfigValue] varchar (50) NOT NULL,
    [Active] int not null,
	[LastUpdated] datetime not null,
	[ConfigType] varchar(50)
)

insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated)
VALUES
('TrainingTitle','Tech','DMS',1,getdate()),
('BlueBinHardwareCustomer','Demo','DMS',1,getdate()),
('TimeOffset','3','DMS',1,getdate()),
('CustomerImage','BlueBin_Logo.png','DMS',1,getdate()),
('REQ_LOCATION','BB','Tableau',1,getdate()),
('Version','1.2.20151211','DMS',1,getdate()),
('PasswordExpires','90','DMS',1,getdate()),
('SiteAppURL','BlueBinOperations_Demo','DMS',1,getdate()),
('TableaURL','/bluebinanalytics/views/Demo/','Tableau',1,getdate()),
('LOCATION','STORE','Tableau',1,getdate())

END
GO


if not exists (select * from sys.tables where name = 'BlueBinResource')
BEGIN
CREATE TABLE [bluebin].[BlueBinResource](
	[BlueBinResourceID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[FirstName] varchar (30) NOT NULL,
	[LastName] varchar (30) NOT NULL,
	[MiddleName] varchar (30) NULL,
    [Login] varchar (30) NULL,
	[Email] varchar (50) NULL,
	[Phone] varchar (20) NULL,
	[Cell] varchar (20) NULL,
	[Title] varchar (50) NULL,
    [Active] int not null,
	[LastUpdated] datetime not null
)
END
GO


if not exists (select * from sys.tables where name = 'BlueBinUser')
BEGIN
CREATE TABLE [bluebin].[BlueBinUser](
	[BlueBinUserID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[UserLogin] varchar (30) NOT NULL,
	[FirstName] varchar (30) NOT NULL,
	[LastName] varchar (30) NOT NULL,
	[MiddleName] varchar (30) NULL,
    [Email] varchar (50) NULL,
    [Active] int not null,
	[Password] varchar(30) not null,
	[RoleID] int null,
	[LastLoginDate] datetime not null,
	[MustChangePassword] int not null,
	[PasswordExpires] int not null,
	[LastUpdated] datetime not null
)

ALTER TABLE [bluebin].[MasterLog] WITH CHECK ADD FOREIGN KEY([BlueBinUserID])
REFERENCES [bluebin].[BlueBinUser] ([BlueBinUserID])

ALTER TABLE [bluebin].[BlueBinUser] ADD CONSTRAINT U_Login UNIQUE(UserLogin)

END
GO


if not exists (select * from sys.tables where name = 'BlueBinOperations')
BEGIN
CREATE TABLE [bluebin].[BlueBinOperations](
	[OpID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[OpName] varchar (50) NOT NULL
)
END
GO


if not exists (select * from sys.tables where name = 'BlueBinRoles')
BEGIN
CREATE TABLE [bluebin].[BlueBinRoles](
	[RoleID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[RoleName] varchar (50) NOT NULL
)

ALTER TABLE [bluebin].[BlueBinUser] WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [bluebin].[BlueBinRoles] ([RoleID])

insert into [bluebin].[BlueBinRoles] (RoleName) VALUES
('BlueBelt'),
('BlueBinPersonnel'),
('Manager'),
('Supervisor'),
('Tech'),
('SuperUser')

END
GO


if not exists (select * from sys.tables where name = 'BlueBinUserOperations')
BEGIN
CREATE TABLE [bluebin].[BlueBinUserOperations](
	[BlueBinUserID] INT NOT NULL,
	[OpID] INT NOT NULL
)

ALTER TABLE [bluebin].[BlueBinUserOperations] WITH CHECK ADD FOREIGN KEY([BlueBinUserID])
REFERENCES [bluebin].[BlueBinUser] ([BlueBinUserID])

END
GO
--DROP TABLE [bluebin].[Image]
--select * from  [bluebin].[Image]


if not exists (select * from sys.tables where name = 'Image')
BEGIN
CREATE TABLE [bluebin].[Image](
	[ImageID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[ImageName] varchar(100) not null,
	[ImageType] varchar(10) not NULL,
	[ImageSource] varchar(100) not NULL,
	[ImageSourceID] int not null,	
	[Image] varbinary(max) NOT NULL,
	[Active] int not null,
	[DateCreated] DateTime not null,
	[LastUpdated] DateTime not null

)
END
GO

if not exists (select * from sys.tables where name = 'BlueBinTraining')
BEGIN
CREATE TABLE [bluebin].[BlueBinTraining](
	[BlueBinTrainingID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[BlueBinResourceID] INT NOT NULL,
	[Form3000] varchar(10) not null,
		[Form3001] varchar(10) not null,
			[Form3002] varchar(10) not null,
				[Form3003] varchar(10) not null,
					[Form3004] varchar(10) not null,
						[Form3005] varchar(10) not null,
							[Form3006] varchar(10) not null,
								[Form3007] varchar(10) not null,
									[Form3008] varchar(10) not null,
										[Form3009] varchar(10) not null,
											[Form3010] varchar(10) not null,
	[Active] int not null,
	[BlueBinUserID] int NULL,
	[LastUpdated] datetime not null
)
;
ALTER TABLE [bluebin].[BlueBinTraining] WITH CHECK ADD FOREIGN KEY([BlueBinResourceID])
REFERENCES [bluebin].[BlueBinResource] ([BlueBinResourceID])
;
ALTER TABLE [bluebin].[BlueBinTraining] WITH CHECK ADD FOREIGN KEY([BlueBinUserID])
REFERENCES [bluebin].[BlueBinUser] ([BlueBinUserID])
;
insert into [bluebin].[BlueBinTraining]
select BlueBinResourceID,'No','No','No','No','No','No','No','No','No','No','No',1,NULL,getdate()
from bluebin.BlueBinResource
where BlueBinResourceID not in (select BlueBinResourceID from bluebin.BlueBinTraining)
	and Title in (select ConfigValue from bluebin.Config where ConfigName = 'TrainingTitle')
END
GO

SET ANSI_PADDING OFF
GO

