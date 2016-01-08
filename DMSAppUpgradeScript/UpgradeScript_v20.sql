--Upgrade Script v
--Backward compatible to V1.0
--Created By Gerry Butler 20151124

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

SET NOCOUNT ON
GO

--*************************************************************************************************************************************************
--Schema Updates
--*************************************************************************************************************************************************

--*****************************************************
--**************************NEWSCHEMA**********************

if not exists (select * from sys.schemas where name = 'gemba')
BEGIN
EXEC sp_executesql N'Create SCHEMA gemba AUTHORIZATION  dbo'
Print 'Schema gemba created'
END
GO

--*****************************************************
--**************************NEWSCHEMA**********************
if not exists (select * from sys.schemas where name = 'qcn')
BEGIN
EXEC sp_executesql N'Create SCHEMA qcn AUTHORIZATION  dbo'
Print 'Schema qcn created'
END
GO

--*****************************************************
--**************************NEWSCHEMA**********************
if not exists (select * from sys.schemas where name = 'bluebin')
BEGIN
EXEC sp_executesql N'Create SCHEMA bluebin AUTHORIZATION  dbo'
Print 'Schema bluebin created'
END
GO

--*****************************************************
--**************************NEWSCHEMA**********************
if not exists (select * from sys.schemas where name = 'scan')
BEGIN
EXEC sp_executesql N'Create SCHEMA scan AUTHORIZATION  dbo'
Print 'Schema scan created'
END
GO


Print 'Schema Updates Complete'


--*************************************************************************************************************************************************
--Table Updates
--*************************************************************************************************************************************************
/*
if exists(select email from bluebin.BlueBinUser)
BEGIN
alter table bluebin.BlueBinUser add Email varchar(50);
update bluebin.BlueBinUser set Email = email;
alter table bluebin.BlueBinUser drop column email;
END
*/
ALTER TABLE bluebin.Config ALTER COLUMN ConfigValue varchar(100)
GO

if not exists(select * from sys.columns where name = 'Description' and object_id = (select object_id from sys.tables where name = 'BlueBinOperations'))
BEGIN
ALTER TABLE bluebin.BlueBinOperations ADD [Description] varchar(255);
END
GO

if not exists(select * from sys.columns where name = 'ConfigType' and object_id = (select object_id from sys.tables where name = 'Config'))
BEGIN
ALTER TABLE bluebin.Config ADD ConfigType varchar(50);
END
GO

if exists(select ConfigType from bluebin.Config)  
BEGIN
update bluebin.Config set ConfigType = 'DMS' where ConfigName not in ('REQ_LOCATION','LOCATION','TableauURL');
update bluebin.Config set ConfigType = 'Tableau' where ConfigName in ('REQ_LOCATION','LOCATION','TableauURL');
END
GO

if not exists(select * from bluebin.Config where ConfigName = 'TrainingTitle')  
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,Active,LastUpdated,ConfigType)
select 'TrainingTitle','Tech',1,getdate(),'DMS'
END
GO

if not exists(select * from bluebin.Config where ConfigName like 'MENU-%')  
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES
('MENU-Dashboard','1','DMS',1,getdate()),
('MENU-QCN','1','DMS',1,getdate()),
('MENU-Gemba','1','DMS',1,getdate()),
('MENU-Hardware','1','DMS',1,getdate()),
('MENU-Scanning','1','DMS',1,getdate()),
('MENU-Other','1','DMS',1,getdate())
END
GO

if not exists(select * from bluebin.Config where ConfigName like 'MENU-Dashboard-%')  
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES
('MENU-Dashboard-HuddleBoard','1','DMS',1,getdate()),
('MENU-Dashboard-SupplyChain','1','DMS',1,getdate()),
('MENU-Dashboard-Sourcing','1','DMS',1,getdate()),
('MENU-Dashboard-Ops','1','DMS',1,getdate())
END
GO


if not exists(select * from bluebin.BlueBinOperations where OpName like 'ADMIN%')  
BEGIN
Insert into bluebin.BlueBinOperations (OpName,[Description]) VALUES
('ADMIN-MENU','Give User ability to see the Main Admin Menu'),
('ADMIN-CONFIG','Give User ability to see the Sub Admin Menu Config'),
('ADMIN-USERS','Give User ability to see the Sub Admin Menu User Administration'),
('ADMIN-RESOURCES','Give User ability to see the Sub Admin Menu Resources'),
('ADMIN-TRAINING','Give User ability to see the Sub Admin Menu Training')
END
GO

Print 'Table Updates Complete'
--*************************************************************************************************************************************************
--Table Adds
--*************************************************************************************************************************************************

--*****************************************************
--**************************NEWTABLE**********************
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


--*****************************************************
--**************************NEWTABLE**********************

if not exists (select * from sys.tables where name = 'BlueBinRoleOperations')
BEGIN
CREATE TABLE [bluebin].[BlueBinRoleOperations](
	[RoleID] INT NOT NULL,
	[OpID] INT NOT NULL
)

ALTER TABLE [bluebin].[BlueBinRoleOperations] WITH CHECK ADD FOREIGN KEY([RoleID])
REFERENCES [bluebin].[BlueBinRoles] ([RoleID])

ALTER TABLE [bluebin].[BlueBinRoleOperations] WITH CHECK ADD FOREIGN KEY([OpID])
REFERENCES [bluebin].[BlueBinOperations] ([OpID])

insert into [bluebin].[BlueBinRoleOperations]
select 
RoleID,--(select RoleID from bluebin.BlueBinRoles where RoleName = 'Manager'),
OpID
from  [bluebin].[BlueBinOperations],bluebin.BlueBinRoles 
WHERE OpName like 'ADMIN%' and RoleName in ('Manager','Supervisor','BlueBinPersonnel','BlueBelt')

END
GO

--*****************************************************
--**************************NEWTABLE**********************

/****** Object:  Table [bluebin].[BlueBinTraining]     ******/
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

--*****************************************************
--**************************NEWTABLE**********************

/****** Object:  Table [scan].[ScanBatch]     ******/

if not exists (select * from sys.tables where name = 'ScanBatch')
BEGIN
CREATE TABLE [scan].[ScanBatch](
	[ScanBatchID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[LocationID] char(7) NOT NULL,
	[BlueBinUserID] int NOT NULL,
	[Active] int NOT NULL,
	[Extracted] int NOT NULL,
	[ScanDateTime] datetime not null
)
END
GO

--*****************************************************
--**************************NEWTABLE**********************


/****** Object:  Table [scan].[ScanLine]     ******/
if not exists (select * from sys.tables where name = 'ScanLine')
BEGIN
CREATE TABLE [scan].[ScanLine](
	[ScanLineID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[ScanBatchID] int NOT NULL,
	[Line] int NOT NULL,
	[ItemID] char (32) NOT NULL,
	[Qty] int NOT NULL,
	[Active] int NOT NULL,
	[Extracted] int NOT NULL,
    [ScanDateTime] datetime NOT NULL
)

ALTER TABLE [scan].[ScanLine] WITH CHECK ADD FOREIGN KEY([ScanBatchID])
REFERENCES [scan].[ScanBatch] ([ScanBatchID])

END
GO


--*****************************************************
--**************************NEWTABLE**********************

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

--*****************************************************
--**************************NEWTABLE**********************

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
;
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
('LOCATION','STORE','Tableau',1,getdate()),
('MENU-Dashboard','1','DMS',1,getdate()),
('MENU-QCN','1','DMS',1,getdate()),
('MENU-Gemba','1','DMS',1,getdate()),
('MENU-Hardware','1','DMS',1,getdate()),
('MENU-Scanning','1','DMS',1,getdate()),
('MENU-Other','1','DMS',1,getdate())
;
END
GO

--*****************************************************
--**************************NEWTABLE**********************

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

--*****************************************************
--**************************NEWTABLE**********************

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


--*****************************************************
--**************************NEWTABLE**********************
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

--*****************************************************
--**************************NEWTABLE**********************

if not exists (select * from sys.tables where name = 'BlueBinOperations')
BEGIN
CREATE TABLE [bluebin].[BlueBinOperations](
	[OpID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[OpName] varchar (50) NOT NULL,
	[Description] varchar (255) NULL
)

Insert into bluebin.BlueBinOperations (OpName,[Description]) VALUES
('ADMIN-MENU','Give User ability to see the Main Admin Menu'),
('ADMIN-CONFIG','Give User ability to see the Sub Admin Menu Config'),
('ADMIN-USERS','Give User ability to see the Sub Admin Menu User Administration'),
('ADMIN-RESOURCES','Give User ability to see the Sub Admin Menu Resources'),
('ADMIN-TRAINING','Give User ability to see the Sub Admin Menu Training')

END
GO

--*****************************************************
--**************************NEWTABLE**********************


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
--ALTER TABLE [bluebin].[Image] WITH CHECK ADD FOREIGN KEY([ImageTypeID])
--REFERENCES [gemba].[GembaAuditNode] ([GembaAuditNodeID])


--*****************************************************
--**************************NEWTABLE**********************

if not exists (select * from sys.tables where name = 'GembaAuditStage')
BEGIN
CREATE TABLE [gemba].[GembaAuditStage](
	[GembaAuditStageID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[Date] datetime not null,
	[AuditerUserID]  int NOT NULL,
	[KanbansFilled]  int NOT NULL,
	[KanbansFilledText]  varchar(max) NULL,
	[LeftBehind]  int NOT NULL,
	[FollowUpDistrib]  int NOT NULL,
	[FollowUpDistribText]  varchar(max) NULL,
	[Concerns]  varchar(max) NULL,
	[DirectOrderBins]  int NOT NULL,
	[OldestBin]  datetime NOT NULL,
	[CheckOpenOrders]  int NOT NULL,
	[CheckOpenOrdersText]  varchar(max) NULL,
	[HowManyLate]  int NOT NULL,
	[FollowUpBuyers]  int NOT NULL,
	[FollowUpBuyersText]  varchar(max) NULL,
	[UpdatedStatusTag]  int NOT NULL,
	[UpdatedStatusTagText]  varchar(max) NULL,
	[ReqsSubmitted]  int NULL,
	[ReqsSubmittedText]  varchar(max) NULL,
	[BinsInOrder]  int NULL,
	[BinsInOrderText]  varchar(max) NULL,
	[AreaNeatTidy]  int NULL,
	[AreaNeatTidyText]  varchar(max) NULL,
	[CartsClean]  int NULL,
	[CartsCleanText]  varchar(max) NULL,
	[AdditionalComments] varchar(max) NULL,
	[Active] int not null,
	[LastUpdated] datetime not null

)

ALTER TABLE [gemba].[GembaAuditStage] WITH CHECK ADD FOREIGN KEY([AuditerUserID])
REFERENCES [bluebin].[BlueBinUser] ([BlueBinUserID])

END
GO

--*****************************************************
--**************************NEWTABLE**********************
if not exists (select * from sys.tables where name = 'GembaAuditNode')
BEGIN
CREATE TABLE [gemba].[GembaAuditNode](
	[GembaAuditNodeID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[Date] datetime not null,
	[LocationID] char(5) not null,
	[AuditerUserID]  int NOT NULL,
	[AdditionalComments] varchar(max) NULL,
    [PS_EmptyBins] int NOT NULL,
	    [PS_BackBins] int NOT NULL,
		    [PS_StockOuts] int NOT NULL,
			    [PS_ReturnVolume] int NOT NULL,
				    [PS_NonBBT] int NOT NULL,
						[PS_OrangeCones] int NOT NULL,
				[PS_Comments] varchar(max) NULL,
    [RS_BinsFilled] int NOT NULL,
	    [RS_EmptiesCollected] int NOT NULL,
			[RS_BinServices] int NOT NULL,
				[RS_NodeSwept] int NOT NULL,
					[RS_NodeCorrections] int NOT NULL,
							[RS_ShadowedUserID] int NULL,
				[RS_Comments] varchar(max) NULL,
	 [SS_Supplied] int NOT NULL,
	    [SS_KanbansPP] int NOT NULL,
		    [SS_StockoutsPT] int NOT NULL,
			    [SS_StockoutsMatch] int NOT NULL,
					[SS_HuddleBoardMatch] int NOT NULL,
				[SS_Comments] varchar(max) NULL,
	    [NIS_Labels] int NOT NULL,
		    [NIS_CardHolders] int NOT NULL,
			    [NIS_BinsRacks] int NOT NULL,
				    [NIS_GeneralAppearance] int NOT NULL,
					    [NIS_Signage] int NOT NULL,
				[NIS_Comments] varchar(max) NULL,
[PS_TotalScore] int Not null,
[RS_TotalScore] int not null,
[SS_TotalScore] int not null,
[NIS_TotalScore] int not null,
[TotalScore] int not null,
[Active] int not null,
[LastUpdated] datetime not null

)

--ALTER TABLE [qcn].[QCNRequest] WITH CHECK ADD FOREIGN KEY([LocationID])
--REFERENCES [bluebin].[DimBin] ([LocationID])

--ALTER TABLE [qcn].[QCNRequest] WITH CHECK ADD FOREIGN KEY([ItemID])
--REFERENCES [bluebin].[DimBin] ([ItemID])

ALTER TABLE [gemba].[GembaAuditNode] WITH CHECK ADD FOREIGN KEY([AuditerUserID])
REFERENCES [bluebin].[BlueBinUser] ([BlueBinUserID])

ALTER TABLE [gemba].[GembaAuditNode] WITH CHECK ADD FOREIGN KEY([RS_ShadowedUserID])
REFERENCES [bluebin].[BlueBinResource] ([BlueBinResourceID])
END
GO

--*****************************************************
--**************************NEWTABLE**********************
if not exists (select * from sys.tables where name = 'QCN')
BEGIN
CREATE TABLE [qcn].[QCN](
	[QCNID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[LocationID] char(5) not null,
	[ItemID] char(32) null,
	[RequesterUserID] int NOT NULL,
	[AssignedUserID] int NULL,
	[QCNTypeID] int NOT NULL,
	[Details] varchar(max) NULL,
	[Updates] varchar(max) NULL,
	[DateEntered] datetime not null,
	[DateCompleted] datetime null,
	[QCNStatusID] int NOT NULL,
	[Active] int not null,
	[LastUpdated] datetime not null

)

ALTER TABLE [qcn].[QCN] WITH CHECK ADD FOREIGN KEY([RequesterUserID])
REFERENCES [bluebin].[BlueBinResource] ([BlueBinResourceID])

ALTER TABLE [qcn].[QCN] WITH CHECK ADD FOREIGN KEY([AssignedUserID])
REFERENCES [bluebin].[BlueBinResource] ([BlueBinResourceID])
END
GO


--*****************************************************
--**************************NEWTABLE**********************

if not exists (select * from sys.tables where name = 'QCNStatus')
BEGIN
CREATE TABLE [qcn].[QCNStatus](
	[QCNStatusID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[Status] [varchar](255) NOT NULL,
	[Active] int not null,
	[LastUpdated] datetime not null
)

ALTER TABLE [qcn].[QCN] WITH CHECK ADD FOREIGN KEY([QCNStatusID])
REFERENCES [qcn].[QCNStatus] ([QCNStatusID])

Insert into [qcn].[QCNStatus] VALUES 
('New',1,getdate()),
('InReview',1,getdate()),
('InProgress',1,getdate()),
('Rejected',1,getdate()),
('OnHold',1,getdate()),
('FutureVersion',1,getdate()),
('Completed',1,getdate())

END
GO

--*****************************************************
--**************************NEWTABLE**********************

if not exists (select * from sys.tables where name = 'QCNType')
BEGIN
CREATE TABLE [qcn].[QCNType](
	[QCNTypeID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[Name] [varchar](255) NOT NULL,
	[Active] int not null,
	[LastUpdated] datetime not null
)

ALTER TABLE [qcn].[QCN] WITH CHECK ADD FOREIGN KEY([QCNTypeID])
REFERENCES [qcn].[QCNType] ([QCNTypeID])

Insert into [qcn].[QCNType] VALUES 
('ADD',1,getdate()),
('CHANGE',1,getdate()),
('UPDATE',1,getdate())

END


--*****************************************************

GO
SET ANSI_PADDING OFF
GO

Print 'Table Adds Complete'
--*************************************************************************************************************************************************
--Sproc Updates
--*************************************************************************************************************************************************

--*****************************************************
--**************************SPROC**********************

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertUserOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertUserOperations
GO


CREATE PROCEDURE sp_InsertUserOperations
@BlueBinUserID int,
@OpID int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

insert into bluebin.BlueBinUserOperations select @BlueBinUserID,@OpID

END
GO
grant exec on sp_InsertUserOperations to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertRoleOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertRoleOperations
GO


CREATE PROCEDURE sp_InsertRoleOperations
@RoleID int,
@OpID int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

insert into bluebin.BlueBinRoleOperations select @RoleID,@OpID

END
GO
grant exec on sp_InsertRoleOperations to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectUserOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectUserOperations
GO

--exec sp_SelectUserOperations 'Butler'
CREATE PROCEDURE sp_SelectUserOperations
@Name varchar(50)
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select 
bbuo.BlueBinUserID,
bbuo.OpID,
bbu.UserLogin,
bbu.LastName + ', ' + FirstName as Name,
bbr.RoleName as [CurrentRole],
bbo.OpName 
from bluebin.BlueBinUserOperations bbuo
inner join bluebin.BlueBinUser bbu on bbuo.BlueBinUserID = bbu.BlueBinUserID
inner join bluebin.BlueBinRoles bbr on bbu.RoleID = bbr.RoleID
inner join bluebin.BlueBinOperations bbo on bbuo.OpID = bbo.OpID
where bbu.Active = 1
  and
  ([LastName] like '%' + @Name + '%' 
	OR [FirstName] like '%' + @Name + '%' )
order by bbu.LastName + ', ' + FirstName,bbo.OpName

END
GO
grant exec on sp_SelectUserOperations to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectRoleOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectRoleOperations
GO

--exec sp_SelectRoleOperations
CREATE PROCEDURE sp_SelectRoleOperations

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select 
bbro.RoleID,
bbro.OpID,
bbr.RoleName,
bbo.OpName 
from bluebin.BlueBinRoleOperations bbro
inner join bluebin.BlueBinRoles bbr on bbro.RoleID = bbr.RoleID
inner join bluebin.BlueBinOperations bbo on bbro.OpID = bbo.OpID
order by bbr.RoleName,bbo.OpName

END
GO
grant exec on sp_SelectRoleOperations to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditOperations
GO


CREATE PROCEDURE sp_EditOperations
@OpID int,
@OpName varchar(50),
@Description varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

update bluebin.BlueBinOperations set OpName = @OpName, [Description] = @Description where OpID = @OpID
END
GO
grant exec on sp_EditOperations to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertOperations
GO


CREATE PROCEDURE sp_InsertOperations
@OpName varchar(50),
@Description varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if not exists(select * from bluebin.BlueBinOperations where OpName = @OpName)
BEGIN
insert into bluebin.BlueBinOperations select @OpName,@Description
END

END
GO
grant exec on sp_InsertOperations to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectOperations') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectOperations
GO


CREATE PROCEDURE sp_SelectOperations



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select OpID,OpName,
isnull([Description],'') as [Description] from bluebin.BlueBinOperations
order by OpName

END
GO
grant exec on sp_SelectOperations to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_ValidateMenus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ValidateMenus
GO

--exec sp_ValidateMenus 'MENU-QCN'

CREATE PROCEDURE [dbo].[sp_ValidateMenus]
	@ConfigName NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;

declare @Menu as Table (ConfigValue varchar(50))

Select 
Case	
	When ConfigValue = 1 or ConfigValue = 'Yes' Then 'Yes'
	Else 'No'
	End as ConfigValue
from bluebin.Config 
where ConfigName = @ConfigName


END
GO
grant exec on sp_ValidateMenus to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_ValidateBlueBinRole') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ValidateBlueBinRole
GO

--exec sp_ValidateBlueBinRole 'dhagan@bluebin.com','ADMIN-CONFIG'

CREATE PROCEDURE [dbo].[sp_ValidateBlueBinRole]
      @UserLogin NVARCHAR(30),
	  @OpName NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;
--Select RoleName from bluebin.BlueBinRoles
--where RoleID in (select RoleID from bluebin.BlueBinUser where UserLogin = @UserLogin)

declare @UserOp as Table (OpName varchar(50))

insert into @UserOp
select 
Distinct 
OpName 
from bluebin.BlueBinOperations
where 
OpID in (select OpID from bluebin.BlueBinUserOperations where BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))
or
OpID in (select OpID from bluebin.BlueBinRoleOperations where RoleID in (select RoleID from bluebin.BlueBinUser where UserLogin = @UserLogin))


if exists(select * from @UserOp where OpName = @OpName)
BEGIN
	Select 'Yes'
END
ELSE
	Select 'No'


END
GO
grant exec on sp_ValidateBlueBinRole to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectBlueBinTraining
GO

--exec sp_SelectBlueBinTraining 'Butler'
CREATE PROCEDURE sp_SelectBlueBinTraining
@Name varchar (30)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
bbt.[BlueBinTrainingID],
bbt.[BlueBinResourceID], 
bbr.[LastName] + ', ' +bbr.[FirstName] as ResourceName, 
bbr.Title,
case when 
		bbt.[Form3000]='Trained' and bbt.[Form3001]='Trained' and bbt.[Form3002]='Trained' and 
		bbt.[Form3003]='Trained' and bbt.[Form3004]='Trained' and bbt.[Form3005]='Trained' and 
		bbt.[Form3006]='Trained' and bbt.[Form3007]='Trained' and bbt.[Form3008]='Trained' and 
		bbt.[Form3009]='Trained' and bbt.[Form3010] ='Trained' then 'Yes' Else 'No' end as FullyTrained,
	bbt.[Form3000],
		bbt.[Form3001],
			bbt.[Form3002],
				bbt.[Form3003],
					bbt.[Form3004],
						bbt.[Form3005],
							bbt.[Form3006],
								bbt.[Form3007],
									bbt.[Form3008],
										bbt.[Form3009],
											bbt.[Form3010],

ISNULL((bbu.[LastName] + ', ' +bbu.[FirstName]),'N/A') as Updater,
bbt.LastUpdated

FROM [bluebin].[BlueBinTraining] bbt
inner join [bluebin].[BlueBinResource] bbr on bbt.[BlueBinResourceID] = bbr.[BlueBinResourceID]
left join [bluebin].[BlueBinUser] bbu on bbt.[BlueBinUserID] = bbu.[BlueBinUserID]

WHERE 
bbt.Active = 1 and 
(bbr.[LastName] like '%' + @Name + '%' 
	OR bbr.[FirstName] like '%' + @Name + '%') 
	
ORDER BY bbr.[LastName]
END

GO
grant exec on sp_SelectBlueBinTraining to appusers
GO


--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteScanLine') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteScanLine
GO

--exec sp_DeleteScanLine

CREATE PROCEDURE sp_DeleteScanLine
@ScanLineID int
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

Delete from scan.ScanLine where ScanLineID = @ScanLineID


END
GO
grant exec on sp_DeleteScanLine to public
GO


--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteScanBatch
GO

--exec sp_DeleteScanBatch

CREATE PROCEDURE sp_DeleteScanBatch
@ScanBatchID int
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

Update scan.ScanBatch set Active = 0 where ScanBatchID = @ScanBatchID
Update scan.ScanLine set Active = 0 where ScanBatchID = @ScanBatchID


END
GO
grant exec on sp_DeleteScanBatch to public
GO


--*****************************************************
--**************************SPROC**********************



if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertScanLine') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertScanLine
GO

/* 
select * from scan.ScanLine
select * from scan.ScanBatch
exec sp_InsertScanLine 1,'0001217','20',1
exec sp_InsertScanLine 1,'0001218','5',2
exec sp_InsertScanLine 1,'0002205','100',3
*/

CREATE PROCEDURE sp_InsertScanLine
@ScanBatchID int,
@Item varchar(30),
@Qty int,
@Line int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

if exists (select * from bluebin.DimItem where ItemID = @Item) 
BEGIN
insert into scan.ScanLine (ScanBatchID,Line,ItemID,Qty,Active,ScanDateTime,Extracted)
	select 
	@ScanBatchID,
	@Line,
	@Item,
	@Qty,
	1,--Active Default to Yes
	getdate(),
	0 --Extracted default to No
END
	ELSE
	BEGIN
	SELECT -1 -- Must Change Password
	delete from scan.ScanLine where ScanBatchID = @ScanBatchID
	delete from scan.ScanBatch where ScanBatchID = @ScanBatchID
	END

END
GO
grant exec on sp_InsertScanLine to public
GO


--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertScanBatch
GO

/*
declare @Location char(5),@Scanner varchar(255) = 'gbutler@bluebin.com'
select @Location = LocationID from bluebin.DimLocation where LocationName = 'DN NICU 1'
exec sp_InsertScanBatch @Location,@Scanner
*/

CREATE PROCEDURE sp_InsertScanBatch
@Location char(5),
@Scanner varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

insert into scan.ScanBatch (LocationID,BlueBinUserID,Active,ScanDateTime,Extracted)
select 
@Location,
(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Scanner),
1, --Default Active to Yes
getdate(),
0 --Default Extracted to No

Declare @ScanBatchID int  = SCOPE_IDENTITY()

exec sp_InsertMasterLog @Scanner,'Scan','New Scan Batch Entered',@ScanBatchID

Select @ScanBatchID

END
GO
grant exec on sp_InsertScanBatch to public
GO


--*****************************************************
--**************************SPROC**********************



if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectScanBatch
GO

--exec sp_SelectScanBatch

CREATE PROCEDURE sp_SelectScanBatch

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
select 
sb.ScanBatchID,
sb.LocationID,
dl.LocationName as LocationName,
max(sl.Line) as BinsScanned,
sb.ScanDateTime as [DateScanned],
bbu.LastName + ', ' + bbu.FirstName as ScannedBy,
case when sb.Extracted = 0 then 'No' Else 'Yes' end as Extracted

from scan.ScanBatch sb
inner join bluebin.DimLocation dl on sb.LocationID = dl.LocationID
inner join scan.ScanLine sl on sb.ScanBatchID = sl.ScanBatchID
inner join bluebin.BlueBinUser bbu on sb.BlueBinUserID = bbu.BlueBinUserID
where sb.Active = 1

group by 
sb.ScanBatchID,
sb.LocationID,
dl.LocationName,
sb.ScanDateTime,
bbu.LastName + ', ' + bbu.FirstName,
sb.Extracted
order by sb.ScanDateTime desc

END
GO
grant exec on sp_SelectScanBatch to public
GO


--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectScanLines') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectScanLines
GO

--exec sp_SelectScanLines 1

CREATE PROCEDURE sp_SelectScanLines
@ScanBatchID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
select 
sb.ScanBatchID,
db.BinKey,
db.BinSequence,
sb.LocationID,
dl.LocationName as LocationName,
sl.ItemID,
di.ItemDescription,
sl.Qty,
sl.Line,
sb.ScanDateTime as [DateScanned],
case when sb.Extracted = 0 then 'No' Else 'Yes' end as Extracted

from scan.ScanLine sl
inner join scan.ScanBatch sb on sl.ScanBatchID = sb.ScanBatchID
inner join bluebin.DimBin db on sb.LocationID = db.LocationID and sl.ItemID = db.ItemID
inner join bluebin.DimItem di on sl.ItemID = di.ItemID
inner join bluebin.DimLocation dl on sb.LocationID = dl.LocationID
where sl.ScanBatchID = @ScanBatchID and sl.Active = 1
order by sl.Line



END
GO
grant exec on sp_SelectScanLines to public
GO



--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_ItemLocator') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_ItemLocator
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_ItemLocator

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
	a.ITEM as LawsonItemNumber,
	ISNULL(c.MANUF_NBR,'N/A') as ItemManufacturerNumber,
	ISNULL(b.ClinicalDescription,'*NEEDS*') as ClinicalDescription,
	a.LOCATION as LocationCode,
	a.NAME as LocationName,
	a.Cart,
	a.Row,
	a.Position
FROM 
(SELECT 
	ITEM,
	LOCATION,
	b.NAME,
	LEFT(PREFER_BIN, 1) as Cart,
	SUBSTRING(PREFER_BIN, 2,1) as Row,
	SUBSTRING(PREFER_BIN, 3,2) as Position	
FROM ITEMLOC a INNER JOIN RQLOC b ON a.LOCATION = b.REQ_LOCATION 
WHERE LEFT(REQ_LOCATION, 2) IN (SELECT [ConfigValue] FROM   [bluebin].[Config] WHERE  [ConfigName] = 'REQ_LOCATION' AND Active = 1)) a
LEFT JOIN 
(SELECT 
	ITEM, 
	USER_FIELD3 as ClinicalDescription
FROM ITEMLOC 
WHERE LOCATION IN (SELECT [ConfigValue] FROM [bluebin].[Config] WHERE  [ConfigName] = 'LOCATION' AND Active = 1) AND LEN(LTRIM(USER_FIELD3)) > 0) b
ON a.ITEM = b.ITEM
left join ITEMMAST c on a.ITEM = c.ITEM

END
GO
grant exec on tb_ItemLocator to public
GO


--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareCustomer') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareCustomer
GO


CREATE PROCEDURE sp_SelectHardwareCustomer

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'BlueBinHardwareCustomer'

END

GO
grant exec on sp_SelectHardwareCustomer to appusers
GO
--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'tb_QCNDashboard') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_QCNDashboard
GO

--exec tb_QCNDashboard 
CREATE PROCEDURE tb_QCNDashboard

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

select 
	q.[QCNID],
	q.[LocationID],
        dl.[LocationName],
		db.BinSequence,
	u.LastName + ', ' + u.FirstName  as RequesterUserName,
        u.[Login] as RequesterLogin,
    u.[Title] as RequesterTitleName,
    case when v.Login = 'None' then '' else v.LastName + ', ' + v.FirstName end as AssignedUserName,
        v.[Login] as AssignedLogin,
    v.[Title] as AssignedTitleName,
	qt.Name as QCNType,
q.[ItemID],
di.[ItemClinicalDescription],
db.[BinQty] as Par,
db.[BinUOM] as UOM,
di.[ItemManufacturer],
di.[ItemManufacturerNumber],
	q.[Details] as [DetailsText],
            case when q.[Details] ='' then 'No' else 'Yes' end Details,
	q.[Updates] as [UpdatesText],
            case when q.[Updates] ='' then 'No' else 'Yes' end Updates,
	case when qs.Status = 'Completed' then convert(int,(q.[DateCompleted] - q.[DateEntered]))
		else convert(int,(getdate() - q.[DateEntered])) end as DaysOpen,
            q.[DateEntered],
	q.[DateCompleted],
	qs.Status,
    case when db.BinCurrentStatus is null then 'N/A' else db.BinCurrentStatus end as BinStatus,
    q.[LastUpdated]
from [qcn].[QCN] q
left join [bluebin].[DimBin] db on q.LocationID = db.LocationID and rtrim(q.ItemID) = rtrim(db.ItemID)
left join [bluebin].[DimItem] di on rtrim(q.ItemID) = rtrim(di.ItemID)
        inner join [bluebin].[DimLocation] dl on q.LocationID = dl.LocationID and dl.BlueBinFlag = 1
inner join [bluebin].[BlueBinResource] u on q.RequesterUserID = u.BlueBinResourceID
left join [bluebin].[BlueBinResource] v on q.AssignedUserID = v.BlueBinResourceID
inner join [qcn].[QCNType] qt on q.QCNTypeID = qt.QCNTypeID
inner join [qcn].[QCNStatus] qs on q.QCNStatusID = qs.QCNStatusID

WHERE q.Active = 1 
            order by q.[DateEntered] asc--,convert(int,(getdate() - q.[DateEntered])) desc

END
GO
grant exec on tb_QCNDashboard to public
GO



--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCN
GO

--exec sp_SelectQCN ''
CREATE PROCEDURE sp_SelectQCN
@LocationName varchar(50)
,@Completed int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
declare @QCNStatus int = 0
declare @QCNStatus2 int = 0
if @Completed = 0
begin
select @QCNStatus = QCNStatusID from qcn.QCNStatus where Status = 'Completed'
select @QCNStatus2 = QCNStatusID from qcn.QCNStatus where Status = 'Rejected'
end

select 
	q.[QCNID],
	q.[LocationID],
        dl.[LocationName],
	u.LastName + ', ' + u.FirstName  as RequesterUserName,
        u.[Login] as RequesterLogin,
    u.[Title] as RequesterTitleName,
    case when v.Login = 'None' then '' else v.LastName + ', ' + v.FirstName end as AssignedUserName,
        v.[Login] as AssignedLogin,
    v.[Title] as AssignedTitleName,
	qt.Name as QCNType,
q.[ItemID],
di.[ItemClinicalDescription],
db.[BinQty] as Par,
db.[BinUOM] as UOM,
di.[ItemManufacturer],
di.[ItemManufacturerNumber],
	q.[Details] as [DetailsText],
            case when q.[Details] ='' then 'No' else 'Yes' end Details,
	q.[Updates] as [UpdatesText],
            case when q.[Updates] ='' then 'No' else 'Yes' end Updates,
	case when qs.Status in ('Rejected','Completed') then convert(int,(q.[DateCompleted] - q.[DateEntered]))
		else convert(int,(getdate() - q.[DateEntered])) end as DaysOpen,
            q.[DateEntered],
	q.[DateCompleted],
	qs.Status,
    case when db.BinCurrentStatus is null then 'N/A' else db.BinCurrentStatus end as BinStatus,
    q.[LastUpdated]
from [qcn].[QCN] q
left join [bluebin].[DimBin] db on q.LocationID = db.LocationID and rtrim(q.ItemID) = rtrim(db.ItemID)
left join [bluebin].[DimItem] di on rtrim(q.ItemID) = rtrim(di.ItemID)
        inner join [bluebin].[DimLocation] dl on q.LocationID = dl.LocationID and dl.BlueBinFlag = 1
inner join [bluebin].[BlueBinResource] u on q.RequesterUserID = u.BlueBinResourceID
left join [bluebin].[BlueBinResource] v on q.AssignedUserID = v.BlueBinResourceID
inner join [qcn].[QCNType] qt on q.QCNTypeID = qt.QCNTypeID
inner join [qcn].[QCNStatus] qs on q.QCNStatusID = qs.QCNStatusID

WHERE q.Active = 1 and dl.LocationName LIKE '%' + @LocationName + '%' 
and q.QCNStatusID not in (@QCNStatus,@QCNStatus2)
            order by q.[DateEntered] asc--,convert(int,(getdate() - q.[DateEntered])) desc

END
GO
grant exec on sp_SelectQCN to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteConfig
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_DeleteConfig
@original_ConfigID int,
@original_ConfigName varchar(30),
@original_ConfigValue varchar(30)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	DELETE FROM bluebin.[Config] 
	WHERE [ConfigID] = @original_ConfigID 
		AND [ConfigName] = @original_ConfigName 
			AND [ConfigValue] = @original_ConfigValue 
				

END
GO
grant exec on sp_DeleteConfig to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteGembaAuditNode') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteGembaAuditNode
GO

CREATE PROCEDURE sp_DeleteGembaAuditNode
@GembaAuditNodeID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [gemba].[GembaAuditNode] set Active = 0, LastUpdated = getdate() where GembaAuditNodeID = @GembaAuditNodeID  

END
GO
grant exec on sp_DeleteGembaAuditNode to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteGembaAuditStage
GO

CREATE PROCEDURE sp_DeleteGembaAuditStage
@GembaAuditStageID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [gemba].[GembaAuditStage] set Active = 0, LastUpdated = getdate() where GembaAuditStageID = @GembaAuditStageID  

END
GO
grant exec on sp_DeleteGembaAuditStage to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteQCN
GO

CREATE PROCEDURE sp_DeleteQCN
@QCNID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [qcn].[QCN] set [Active] = 0, [LastUpdated] = getdate() where QCNID = @QCNID

END
GO
grant exec on sp_DeleteQCN to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (Select * from dbo.sysobjects where id = object_id(N'sp_DeleteQCNStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteQCNStatus
GO

--exec sp_DeleteQCNStatus 

CREATE PROCEDURE sp_DeleteQCNStatus
@original_QCNStatusID int,
@original_Status varchar(255)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update qcn.[QCNStatus] Set Active = 0 WHERE [QCNStatusID] = @original_QCNStatusID AND [Status] = @original_Status

END
GO
grant exec on sp_DeleteQCNStatus to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteQCNType
GO

--exec sp_DeleteQCNType 

CREATE PROCEDURE sp_DeleteQCNType
@original_QCNTypeID int,
@original_Name varchar(255)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	
	Update qcn.[QCNType] set Active = 0
	WHERE 
	[QCNTypeID] = @original_QCNTypeID 
		AND [Name] = @original_Name
END
GO
grant exec on sp_DeleteQCNType to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditBlueBinResource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditBlueBinResource
GO

--exec sp_EditBlueBinResource 'TEST'

CREATE PROCEDURE sp_EditBlueBinResource
@BlueBinResourceID int
,@FirstName varchar (30)
,@LastName varchar (30)
,@MiddleName varchar (30)
,@Login varchar (30)
,@Email varchar (50)
,@Phone varchar (20)
,@Cell varchar (20)
,@Title varchar (50)
,@Active int



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update bluebin.BlueBinResource set 
FirstName = @FirstName
,LastName = @LastName
,MiddleName = @MiddleName
,[Login] = @Login
,Email = @Email
,Phone = @Phone
,Cell = @Cell
,Title = @Title
,Active = @Active, LastUpdated = getdate() 
where BlueBinResourceID = @BlueBinResourceID	

END
GO
grant exec on sp_EditBlueBinResource to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditConfig
GO

--exec sp_EditConfig 10,'3','Tableau',1


CREATE PROCEDURE sp_EditConfig
@ConfigID int
,@ConfigValue varchar (100)
,@ConfigType varchar(50)
,@Active int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update bluebin.Config set ConfigValue = @ConfigValue,ConfigType = @ConfigType,Active = @Active, LastUpdated = getdate() where ConfigID = @ConfigID

END
GO
grant exec on sp_EditConfig to appusers
GO



--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditGembaAuditStage
GO

--exec sp_EditGembaAuditStage 'TEST'

CREATE PROCEDURE sp_EditGembaAuditStage
	@GembaAuditStageID int,
	@KanbansFilled int,
	@KanbansFilledText varchar(max),
	@LeftBehind int,
	@FollowUpDistrib int,
	@FollowUpDistribText varchar(max),
	@Concerns varchar(max),
	@DirectOrderBins int,
	@OldestBin datetime,
	@CheckedOpenOrders int,
	@CheckedOpenOrdersText varchar(max),
	@HowManyLate int,
	@FollowUpBuyers int,
	@FollowUpBuyersText varchar(max),
	@UpdatedStatusTag int,
	@UpdatedStatusTagText varchar(max),
	@ReqsSubmitted int,
	@ReqsSubmittedText varchar(max),
	@BinsInOrder int,
	@BinsInOrderText varchar(max),
	@AreaNeatTidy int,
	@AreaNeatTidyText varchar(max),
	@CartsClean int,
	@CartsCleanText varchar(max),
	@AdditionalCommentsText varchar(max)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [gemba].[GembaAuditStage] Set

	[KanbansFilled] = @KanbansFilled,
	[KanbansFilledText] = @KanbansFilledText,
	[LeftBehind] = @LeftBehind,
	[FollowUpDistrib] = @FollowUpDistrib,
	[FollowUpDistribText] = @FollowUpDistribText,
	[Concerns] = @Concerns,
	[DirectOrderBins] = @DirectOrderBins,
	[OldestBin] = @OldestBin,
	[CheckOpenOrders] = @CheckedOpenOrders,
	[CheckOpenOrdersText] = @CheckedOpenOrdersText,
	[HowManyLate] = @HowManyLate,
	[FollowUpBuyers] = @FollowUpBuyers,
	[FollowUpBuyersText] = @FollowUpBuyersText,
	[UpdatedStatusTag] = @UpdatedStatusTag,
	[UpdatedStatusTagText] = @UpdatedStatusTagText,
	[ReqsSubmitted] = @ReqsSubmitted,
	[ReqsSubmittedText] = @ReqsSubmittedText,
	[BinsInOrder] = @BinsInOrder,
	[BinsInOrderText] = @BinsInOrderText,
	[AreaNeatTidy] = @AreaNeatTidy,
	[AreaNeatTidyText] = @AreaNeatTidyText,
	[CartsClean] = @CartsClean,
	[CartsCleanText] = @CartsCleanText,
	[AdditionalComments] = @AdditionalCommentsText,
    [LastUpdated] = getdate()
	Where [GembaAuditStageID] = @GembaAuditStageID	

END
GO
grant exec on sp_EditGembaAuditStage to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditQCN
GO

--exec sp_EditQCN 

CREATE PROCEDURE sp_EditQCN
@QCNID int,
@LocationID varchar(5),
@ItemID varchar(32),
@Requester varchar(255),
@Assigned varchar(255),
@QCNType varchar(255),
@Details varchar(max),
@Updates varchar(max),
@QCNStatus varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	
update [qcn].[QCN] set
[LocationID] = @LocationID,
[ItemID] = @ItemID,
[RequesterUserID] = (select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Requester),
[AssignedUserID] = (select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Assigned),
[QCNTypeID] = (select [QCNTypeID] from [qcn].[QCNType] where [Name] = @QCNType),
[Details] = @Details,
[Updates] = @Updates,
[DateCompleted] = Case when @QCNStatus in ('Rejected','Completed') and DateCompleted is null then getdate() 
                        when @QCNStatus in ('Rejected','Completed') and DateCompleted is not null then DateCompleted
                            else NULL end,
[QCNStatusID] = (select [QCNStatusID] from [qcn].[QCNStatus] where [Status] = @QCNStatus),
[LastUpdated] = getdate() 
WHERE QCNID = @QCNID



END

GO
grant exec on sp_EditQCN to appusers
GO



--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditQCNStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditQCNStatus
GO

--exec sp_EditQCNStatus 'TEST'

CREATE PROCEDURE sp_EditQCNStatus
@QCNStatusID int
,@Status varchar (255)
,@Active int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update qcn.QCNStatus set [Status] = @Status,[Active] = @Active, [LastUpdated ]= getdate() where QCNStatusID = @QCNStatusID

END

GO
grant exec on sp_EditQCNStatus to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditQCNType
GO

--exec sp_EditQCNType 'TEST'

CREATE PROCEDURE sp_EditQCNType
@QCNTypeID int
,@Name varchar (255)
,@Active int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	Update qcn.QCNType set Name = @Name,Active = @Active, LastUpdated = getdate() where QCNTypeID = @QCNTypeID

END

GO
grant exec on sp_EditQCNType to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertBlueBinTraining
GO

--exec sp_InsertBlueBinTraining 1,'Yes','No','No','No','No','No','No','No','No','No','No','gbutler@bluebin.com'


CREATE PROCEDURE sp_InsertBlueBinTraining
@BlueBinResource int,--varchar(255), 
@Form3000 varchar(10),
@Form3001 varchar(10),
@Form3002 varchar(10),
@Form3003 varchar(10),
@Form3004 varchar(10),
@Form3005 varchar(10),
@Form3006 varchar(10),
@Form3007 varchar(10),
@Form3008 varchar(10),
@Form3009 varchar(10),
@Form3010 varchar(10),
@Updater varchar(255)

--WITH ENCRYPTION 
AS
BEGIN
SET NOCOUNT ON
select * from bluebin.BlueBinResource

if not exists (select * from bluebin.BlueBinTraining where Active = 1 and BlueBinResourceID in (select BlueBinResourceID from bluebin.BlueBinResource where BlueBinResourceID  = @BlueBinResource))--
	BEGIN
	insert into [bluebin].[BlueBinTraining]
	select 
	@BlueBinResource,
	--(select BlueBinResourceID from bluebin.BlueBinResource where LastName + ', ' + FirstName = @BlueBinResource),
	@Form3000,
	@Form3001,
	@Form3002,
	@Form3003,
	@Form3004,
	@Form3005,
	@Form3006,
	@Form3007,
	@Form3008,
	@Form3009,
	@Form3010,
	1, --Default Active to Yes
	(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Updater),
	getdate()

	;
	declare @BlueBinTrainingID int
	SET @BlueBinTrainingID = SCOPE_IDENTITY()
		exec sp_InsertMasterLog @Updater,'Training','New Training Record Entered',@BlueBinTrainingID
	END
END
GO

grant exec on sp_InsertBlueBinTraining to appusers
GO



--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteBlueBinTraining
GO

CREATE PROCEDURE sp_DeleteBlueBinTraining
@BlueBinTrainingID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [bluebin].[BlueBinTraining] set [Active] = 0, [LastUpdated] = getdate() where BlueBinTrainingID = @BlueBinTrainingID

END
GO
grant exec on sp_DeleteBlueBinTraining to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditBlueBinTraining
GO

--exec sp_EditBlueBinTraining '2','Yes','Yes','Yes','No','No','No','No','No','No','No','No','gbutler@bluebin.com'
--select * from [bluebin].[BlueBinTraining]


CREATE PROCEDURE sp_EditBlueBinTraining
@BlueBinTrainingID int, 
@Form3000 varchar(10),
@Form3001 varchar(10),
@Form3002 varchar(10),
@Form3003 varchar(10),
@Form3004 varchar(10),
@Form3005 varchar(10),
@Form3006 varchar(10),
@Form3007 varchar(10),
@Form3008 varchar(10),
@Form3009 varchar(10),
@Form3010 varchar(10),
@Updater varchar(255)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON


update [bluebin].[BlueBinTraining]
set
	Form3000 = @Form3000,
	Form3001 = @Form3001,
	Form3002 = @Form3002,
	Form3003 = @Form3003,
	Form3004 = @Form3004,
	Form3005 = @Form3005,
	Form3006 = @Form3006,
	Form3007 = @Form3007,
	Form3008 = @Form3008,
	Form3009 = @Form3009,
	Form3010 = @Form3010,
	BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Updater),
	LastUpdated = getdate()
where BlueBinTrainingID = @BlueBinTrainingID
	;
exec sp_InsertMasterLog @Updater,'Training','Training Record Updated',@BlueBinTrainingID
END
GO

grant exec on sp_EditBlueBinTraining to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertBlueBinResource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertBlueBinResource
GO

--exec sp_InsertBlueBinResource 'TEST'

CREATE PROCEDURE sp_InsertBlueBinResource
@FirstName varchar (30)
,@LastName varchar (30)
,@MiddleName varchar (30)
,@Login varchar (30)
,@Email varchar (50)
,@Phone varchar (20)
,@Cell varchar (20)
,@Title varchar (50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from bluebin.BlueBinResource where FirstName = @FirstName and LastName = @LastName and [Login] = @Login)
	BEGIN
		if not exists (select * from bluebin.BlueBinTraining where BlueBinResourceID in (select BlueBinResourceID from bluebin.BlueBinResource where FirstName = @FirstName and LastName = @LastName and [Login] = @Login))
		BEGIN
		insert into [bluebin].[BlueBinTraining]
			select BlueBinResourceID,'No','No','No','No','No','No','No','No','No','No','No',1,NULL,getdate()
			from bluebin.BlueBinResource
			where FirstName = @FirstName and LastName = @LastName and [Login] = @Login
			and Title in (select ConfigValue from bluebin.Config where ConfigName = 'TrainingTitle')
		END
		GOTO THEEND
	END
;
insert into bluebin.BlueBinResource (FirstName,LastName,MiddleName,[Login],Email,Phone,Cell,Title,Active,LastUpdated) 
VALUES (@FirstName,@LastName,@MiddleName,@Login,@Email,@Phone,@Cell,@Title,1,getdate())
;
insert into [bluebin].[BlueBinTraining]
		select BlueBinResourceID,'No','No','No','No','No','No','No','No','No','No','No',1,NULL,getdate()
		from bluebin.BlueBinResource
		where FirstName = @FirstName and LastName = @LastName and [Login] = @Login
		and Title in (select ConfigValue from bluebin.Config where ConfigName = 'TrainingTitle')

END
THEEND:

GO
grant exec on sp_InsertBlueBinResource to appusers
GO



--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertConfig
GO

--exec sp_InsertConfig 'TEST'

CREATE PROCEDURE sp_InsertConfig
@ConfigName varchar (30)
,@ConfigValue varchar (100)
,@ConfigType varchar (50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from bluebin.Config where ConfigName = @ConfigName and ConfigType = 'DMS')
BEGIN
GOTO THEEND
END
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES (@ConfigName,@ConfigValue,@ConfigType,1,getdate())

END
THEEND:

GO
grant exec on sp_InsertConfig to appusers
GO
--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertMasterLog') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertMasterLog
GO

CREATE PROCEDURE sp_InsertMasterLog
@UserLogin varchar (30)
,@ActionType varchar (30)
,@ActionName varchar (50)
,@ActionID int
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON


Insert into bluebin.MasterLog ([BlueBinUserID],[ActionType],[ActionName],[ActionID],[ActionDateTime]) Values
((select BlueBinUserID from bluebin.BlueBinUser where [UserLogin] = @UserLogin),@ActionType,@ActionName,@ActionID,getdate())

END
GO
grant exec on sp_InsertMasterLog to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertQCNStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertQCNStatus
GO

--exec sp_InsertQCNStatus 'TEST'

CREATE PROCEDURE sp_InsertQCNStatus
@Status varchar (255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from qcn.QCNStatus where Status = @Status)
BEGIN
GOTO THEEND
END
insert into qcn.QCNStatus (Status,Active,LastUpdated) VALUES (@Status,1,getdate())

END
THEEND:

GO
grant exec on sp_InsertQCNStatus to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertQCNType
GO

--exec sp_InsertQCNType 'TEST'

CREATE PROCEDURE sp_InsertQCNType
@Name varchar (255)



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from qcn.QCNType where Name = @Name)
BEGIN
GOTO THEEND
END
insert into qcn.QCNType (Name,Active,LastUpdated) VALUES (@Name,1,getdate())

END
THEEND:

GO
grant exec on sp_InsertQCNType to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectBlueBinResource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectBlueBinResource
GO


CREATE PROCEDURE sp_SelectBlueBinResource
@Name varchar (30)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
[BlueBinResourceID], 
[Login], 
[FirstName], 
[LastName], 
[MiddleName], 
[Email], 
[Title],
[Phone],
[Cell],
case when Active = 1 then 'Yes' Else 'No' end as ActiveName,
Active,
LastUpdated

FROM [bluebin].[BlueBinResource] 

WHERE [LastName] like '%' + @Name + '%' 
	OR [FirstName] like '%' + @Name + '%' 
	
ORDER BY [LastName]
END

GO
grant exec on sp_SelectBlueBinResource to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectConfig
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_SelectConfig

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	ConfigID,
	ConfigType,
	ConfigName,
	ConfigValue,
	case 
		when Active = 1 then 'Yes' 
		Else 'No' 
		end as ActiveName,
	Active,
	LastUpdated 
	
	FROM bluebin.[Config]
	order by ConfigType,ConfigName

END
GO
grant exec on sp_SelectConfig to appusers
GO



--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaAuditNode') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaAuditNode
GO

CREATE PROCEDURE sp_SelectGembaAuditNode
@LocationName varchar(50)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
    select 
	q.Date,
    q.[GembaAuditNodeID],
	dl.[LocationName],
	u.LastName + ', ' + u.FirstName as Auditer,
    u.UserLogin as AuditerLogin,
    q.PS_TotalScore as [Pull Score],
    q.RS_TotalScore as [Replenishment Score],
    q.NIS_TotalScore as [Node Integrity Score],
	q.SS_TotalScore as [Stage Score],
    q.TotalScore as [Total Score],
    q.AdditionalComments as AdditionalCommentsText,
    case when q.AdditionalComments ='' then 'No' else 'Yes' end [Addtl Comments],
    q.LastUpdated
from [gemba].[GembaAuditNode] q
inner join [bluebin].[DimLocation] dl on q.LocationID = dl.LocationID and dl.BlueBinFlag = 1
inner join [bluebin].[BlueBinUser] u on q.AuditerUserID = u.BlueBinUserID
    Where q.Active = 1 and dl.LocationName LIKE '%' + @LocationName + '%' order by q.Date desc

END
GO
grant exec on sp_SelectGembaAuditNode to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaAuditNodeEdit') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaAuditNodeEdit
GO

--exec sp_SelectGembaAuditNodeEdit 'TEST'

CREATE PROCEDURE sp_SelectGembaAuditNodeEdit
@GembaAuditNodeID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
select
		a.[GembaAuditNodeID]
		,convert(varchar,a.[Date],101) as [Date]
		,a.[LocationID]
		,b1.UserLogin as Auditer
		,a.[AdditionalComments]
		,a.[PS_EmptyBins]
		,a.[PS_BackBins]
		,a.[PS_StockOuts]
		,a.[PS_ReturnVolume]
		,a.[PS_NonBBT]
		,a.[PS_OrangeCones]
		,a.[PS_Comments]
		,a.[RS_BinsFilled]
		,a.[RS_EmptiesCollected]
		,a.[RS_BinServices]
		,a.[RS_NodeSwept]
		,a.[RS_NodeCorrections]
		,b2.LastName + ', ' + b2.FirstName + ' (' + b2.Login + ')' as RS_ShadowedUser
		,a.[RS_Comments]

		,a.[SS_Supplied]
		,a.[SS_KanbansPP]
		,a.[SS_StockoutsPT]
		,a.[SS_StockoutsMatch]
		,a.[SS_HuddleBoardMatch]
		,a.[SS_Comments]

		,a.[NIS_Labels]
		,a.[NIS_CardHolders]
		,a.[NIS_BinsRacks]
		,a.[NIS_GeneralAppearance]
		,a.[NIS_Signage]
		,a.[NIS_Comments]
		,a.[PS_TotalScore]
		,a.[RS_TotalScore]
		,a.[SS_TotalScore]
		,a.[NIS_TotalScore]
		,a.[TotalScore]
		,convert(varchar,a.[LastUpdated],101) as [LastUpdated]
		from gemba.GembaAuditNode a 
				inner join bluebin.BlueBinUser b1 on a.[AuditerUserID] = b1.BlueBinUserID
				left join bluebin.BlueBinResource b2 on a.[RS_ShadowedUserID] = b2.BlueBinResourceID where a.GembaAuditNodeID = @GembaAuditNodeID
END
GO
grant exec on sp_SelectGembaAuditNodeEdit to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaAuditStage
GO


--exec sp_SelectGembaAuditStage
CREATE PROCEDURE sp_SelectGembaAuditStage

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
      a.[GembaAuditStageID]
      ,a.[Date]
      ,b.LastName + ', ' + b.FirstName as Auditer
      ,b.UserLogin as AuditerLogin
      ,a.[OldestBin]
      ,case when a.[KanbansFilled] = 1 then 'Yes' else 'No' end [KanbansFilled]
      ,case when a.[ReqsSubmitted] = 3 then 'Need' when a.[ReqsSubmitted] = 0 then 'No' else 'Yes' end [ReqsSubmitted]
      ,case when a.[BinsInOrder] = 3 then 'Need' when a.[BinsInOrder] = 0 then 'No'  else 'Yes' end [BinsInOrder]
      ,case when a.[AreaNeatTidy] = 3 then 'Need' when a.[AreaNeatTidy] = 0 then 'No'  else 'Yes' end [AreaNeatTidy]
      ,case when a.[CartsClean] = 3 then 'Need' when a.[CartsClean] = 0 then 'No'  else 'Yes' end [CartsClean]
      ,a.[AdditionalComments] as AdditionalCommentsStageText 
      ,case when a.[AdditionalComments] = '' then 'None' else 'Yes' end [AdditionalCommentsStage]
	  ,a.Concerns as ConcernsText
     ,case when a.[Concerns] = '' then 'None' else 'Yes' end [Concerns],
      a.LastUpdated
  FROM [gemba].[GembaAuditStage] a
  inner join bluebin.BlueBinUser b on a.AuditerUserID = b.BlueBinUserID WHERE a.Active = 1 order by a.[Date] desc

END
GO
grant exec on sp_SelectGembaAuditStage to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaAuditStageEdit') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaAuditStageEdit
GO

--exec sp_SelectGembaAuditStageEdit 'TEST'

CREATE PROCEDURE sp_SelectGembaAuditStageEdit
@GembaAuditStageID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

select 
    a.GembaAuditStageID
    , convert(varchar,a.[Date],101) as [Date]
    ,b.UserLogin as Auditer
    ,a.[KanbansFilled]
    ,a.[KanbansFilledText]
    ,a.[LeftBehind]
    ,a.[FollowUpDistrib]
    ,a.[FollowUpDistribText]
    ,a.[Concerns]
    ,a.[DirectOrderBins]
    ,convert(varchar,a.[OldestBin],101) as OldestBin
    ,a.[CheckOpenOrders]
    ,a.[CheckOpenOrdersText]
    ,a.[HowManyLate]
    ,a.[FollowUpBuyers]
    ,a.[FollowUpBuyersText]
    ,a.[UpdatedStatusTag]
    ,a.[UpdatedStatusTagText]
    ,a.[ReqsSubmitted]
    ,a.[ReqsSubmittedText]
    ,a.[BinsInOrder]
    ,a.[BinsInOrderText]
    ,a.[AreaNeatTidy]
    ,a.[AreaNeatTidyText]
    ,a.[CartsClean]
    ,a.[CartsCleanText]
    ,a.[AdditionalComments]
    , convert(varchar,a.[LastUpdated],101) as [LastUpdated]
from gemba.GembaAuditStage a 
	inner join bluebin.BlueBinUser b on a.[AuditerUserID] = b.BlueBinUserID
where 
	a.GembaAuditStageID=@GembaAuditStageID
END
GO
grant exec on sp_SelectGembaAuditStageEdit to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaShadow') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaShadow
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_SelectGembaShadow

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
		LastName + ', ' + FirstName + ' (' + Login + ')' as FullName 
	
	FROM [bluebin].[BlueBinResource] 
	
	WHERE 
		Title like '%Tech%' 
			or Title like '%Strider%'

END
GO
grant exec on sp_SelectGembaShadow to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectLocation') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectLocation
GO

--exec SelectLocation 

CREATE PROCEDURE sp_SelectLocation

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT LocationID,LocationName FROM [bluebin].[DimLocation] where BlueBinFlag = 1
END
GO
grant exec on sp_SelectLocation to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectLogoImage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectLogoImage
GO


CREATE PROCEDURE sp_SelectLogoImage

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'CustomerImage'

END

GO
grant exec on sp_SelectLogoImage to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNFormEdit') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNFormEdit
GO

--exec sp_SelectQCNFormEdit ''
CREATE PROCEDURE sp_SelectQCNFormEdit
@QCNID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
	[QCNID]
	,[LocationID]
	,rtrim(a.ItemID) as ItemID
	,b1.LastName + ', ' + b1.FirstName + ' (' + b1.Login + ')' as [RequesterUser]
	,b2.LastName + ', ' + b2.FirstName + ' (' + b2.Login + ')' as [AssignedUser]
	,qt.Name as QCNType
	,[Details]
	,[Updates]
	,convert(varchar,a.[DateEntered],101) as [DateEntered]
	,convert(varchar,a.[DateCompleted],101) as [DateCompleted]
	,qs.Status as QCNStatus
	,convert(varchar,a.[LastUpdated],101) as [LastUpdated]
		FROM [qcn].[QCN] a 
			inner join bluebin.BlueBinResource b1 on a.[RequesterUserID] = b1.BlueBinResourceID
			left join bluebin.BlueBinResource b2 on a.[AssignedUserID] = b2.BlueBinResourceID
			left join qcn.QCNStatus qs on a.[QCNStatusID] = qs.[QCNStatusID]
			left join qcn.QCNType qt on a.[QCNTypeID] = qt.[QCNTypeID]
		where a.QCNID=@QCNID

END
GO
grant exec on sp_SelectQCNFormEdit to appusers
GO

--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNStatus') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNStatus
GO

--exec sp_SelectQCNStatus 

CREATE PROCEDURE sp_SelectQCNStatus

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	QCNStatusID,
	[Status],
	case 
		when Active = 1 then 'Yes' 
		Else 'No' 
		end as ActiveName,
		Active,
		LastUpdated 
		
	FROM qcn.[QCNStatus]

END
GO
grant exec on sp_SelectQCNStatus to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNType
GO

--exec sp_SelectQCNType 

CREATE PROCEDURE sp_SelectQCNType

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	QCNTypeID,
	Name,
	case 
		when Active = 1 then 'Yes' 
		Else 'No' 
		end as ActiveName,
	Active,
	LastUpdated 
	
	FROM qcn.[QCNType]

END
GO
grant exec on sp_SelectQCNType to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_UpdateGembaScores') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_UpdateGembaScores
GO

--exec sp_UpdateGembaScores

CREATE PROCEDURE sp_UpdateGembaScores


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update gemba.GembaAuditNode set PS_TotalScore = (PS_EmptyBins+PS_BackBins+PS_StockOuts+PS_ReturnVolume+PS_NonBBT)
Update gemba.GembaAuditNode set RS_TotalScore = (RS_BinsFilled+RS_BinServices+RS_NodeSwept+RS_NodeCorrections+RS_EmptiesCollected)
Update gemba.GembaAuditNode set SS_TotalScore = ISNULL((SS_Supplied+SS_KanbansPP+SS_StockoutsPT+SS_StockoutsMatch+SS_HuddleBoardMatch),0)
Update gemba.GembaAuditNode set NIS_TotalScore = (NIS_Labels+NIS_CardHolders+NIS_BinsRacks+NIS_GeneralAppearance+NIS_Signage)
Update gemba.GembaAuditNode set TotalScore = (NIS_TotalScore+PS_TotalScore+RS_TotalScore+SS_TotalScore)
				

END
GO
grant exec on sp_UpdateGembaScores to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_UpdateImages') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_UpdateImages
GO

--exec sp_UpdateImages 'gbutler@bluebin.com','151116'
CREATE PROCEDURE sp_UpdateImages
@GembaAuditNodeID int,
@UserLogin varchar(100),
@ImageSourceIDPH int 


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from bluebin.[Image] where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH)))))
	BEGIN
	update [bluebin].[Image] set ImageSourceID = @GembaAuditNodeID where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
	END

END

GO
grant exec on sp_UpdateImages to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertUser
GO

--exec sp_InsertUser 'gbutler2@bluebin.com','G','But','','BlueBelt',''  


CREATE PROCEDURE sp_InsertUser
@UserLogin varchar(30),
@FirstName varchar(30), 
@LastName varchar(30), 
@MiddleName varchar(30), 
@RoleName  varchar(30),
@Email varchar(50)
	
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
declare @newpwdHash varbinary(max), @RoleID int, @NewBlueBinUserID int, @message varchar(255), @fakelogin varchar(50),@RandomPassword varchar(20),@DefaultExpiration int
select @RoleID = RoleID from bluebin.BlueBinRoles where RoleName = @RoleName
select @DefaultExpiration = ConfigValue from bluebin.Config where ConfigName = 'PasswordExpires' and Active = 1


declare @table table (p varchar(50))
insert @table exec sp_GeneratePassword 8 
set @RandomPassword = (Select p from @table)
set @newpwdHash = convert(varbinary(max),rtrim(@RandomPassword))

if not exists (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin)
	BEGIN
	insert into bluebin.BlueBinUser (UserLogin,FirstName,LastName,MiddleName,RoleID,MustChangePassword,PasswordExpires,[Password],Email,Active,LastUpdated,LastLoginDate)
	VALUES
	(@UserLogin,@FirstName,@LastName,@MiddleName,@RoleID,1,@DefaultExpiration,(HASHBYTES('SHA1', @newpwdHash)),@Email,1,getdate(),getdate())
	;
	SET @NewBlueBinUserID = SCOPE_IDENTITY()
	set @message = 'New User Created - '+ @UserLogin
	select @fakelogin = UserLogin from bluebin.BlueBinUser where BlueBinUserID = 1
		exec sp_InsertMasterLog @UserLogin,'Users',@message,@NewBlueBinUserID      
	;
	Select p from @table
	END
	ELSE
	BEGIN
	Select 'exists'
	END
	
	if not exists (select BlueBinResourceID from bluebin.BlueBinResource where FirstName = @FirstName and LastName = @LastName)--select * from bluebin.BlueBinResource
	BEGIN
	exec sp_InsertBlueBinResource @FirstName,@LastName,@MiddleName,@UserLogin,@Email,'','',@RoleName
	END
END
GO
grant exec on sp_InsertUser to appusers
GO




--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditUser
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_EditUser
@BlueBinUserID int,
@UserLogin varchar(30),
@FirstName varchar(30), 
@LastName varchar(30), 
@MiddleName varchar(30), 
@Active int,
@Email varchar(50), 
@MustChangePassword int,
@PasswordExpires int,
@Password varchar(50),
@RoleName  varchar(30)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
declare @newpwdHash varbinary(max),@message varchar(255), @fakelogin varchar(50)
set @newpwdHash = convert(varbinary(max),rtrim(@Password))

IF (@Password = '' or @Password is null)
	BEGIN
	update bluebin.BlueBinUser set 
        FirstName = @FirstName, 
        LastName = @LastName, 
        MiddleName = @MiddleName, 
        Active = @Active,
        Email = @Email, 
        LastUpdated = getdate(), 
        MustChangePassword = @MustChangePassword,
        PasswordExpires = @PasswordExpires,
        RoleID = (select RoleID from bluebin.BlueBinRoles where RoleName = @RoleName)
		Where BlueBinUserID = @BlueBinUserID
	END
	ELSE
	BEGIN
		update bluebin.BlueBinUser set 
        FirstName = @FirstName, 
        LastName = @LastName, 
        MiddleName = @MiddleName, 
        Active = @Active,
        Email = @Email, 
        LastUpdated = getdate(), 
        MustChangePassword = @MustChangePassword,
        PasswordExpires = @PasswordExpires,
		[Password] = (HASHBYTES('SHA1', @newpwdHash)),
        RoleID = (select RoleID from bluebin.BlueBinRoles where RoleName = @RoleName)
		Where BlueBinUserID = @BlueBinUserID
	END

	;
	set @message = 'User Updated - '+ @UserLogin
	select @fakelogin = UserLogin from bluebin.BlueBinUser where BlueBinUserID = 1
	exec sp_InsertMasterLog @fakelogin,'Users',@message,@BlueBinUserID
END
GO
grant exec on sp_EditUser to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectUsers') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectUsers
GO

--exec sp_EditConfig 'TEST'

CREATE PROCEDURE sp_SelectUsers
@Name varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	[BlueBinUserID]
      ,[UserLogin]
      ,[FirstName]
      ,[LastName]
      ,[MiddleName]
      ,	case 
		when Active = 1 then 'Yes' 
		Else 'No' 
		end as ActiveName
	  ,[Active]
      ,[LastUpdated]
      ,bbur.RoleID
	  ,bbur.RoleName
      ,[LastLoginDate]
      ,[MustChangePassword]
	  ,	case 
		when [MustChangePassword] = 1 then 'Yes' 
		Else 'No' 
		end as [MustChangePasswordName]
      ,[PasswordExpires]
      ,'' as [Password]
      ,[Email]
  FROM [bluebin].[BlueBinUser] bbu
  inner join bluebin.BlueBinRoles bbur on bbu.RoleID = bbur.RoleID
  where UserLogin <> ''
  and
  ([LastName] like '%' + @Name + '%' 
	OR [FirstName] like '%' + @Name + '%' )
  order by LastName

END
GO
grant exec on sp_SelectUsers to appusers
GO


--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectRoles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectRoles
GO


CREATE PROCEDURE sp_SelectRoles



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select RoleID,RoleName from bluebin.BlueBinRoles
order by RoleName

END
GO
grant exec on sp_SelectRoles to appusers
GO



--*****************************************************
--**************************SPROC**********************
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertRoles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertRoles
GO


CREATE PROCEDURE sp_InsertRoles
@RoleName varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
insert into bluebin.BlueBinRoles select @RoleName

END
GO
grant exec on sp_InsertRoles to appusers
GO



--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditRoles') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditRoles
GO


CREATE PROCEDURE sp_EditRoles
@RoleID int,
@RoleName varchar(50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

update bluebin.BlueBinRoles set RoleName = @RoleName where RoleID = @RoleID
END
GO
grant exec on sp_EditRoles to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from sysobjects where id = object_id(N'sp_GeneratePassword') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_GeneratePassword
GO
CREATE PROCEDURE sp_GeneratePassword
(
    @Length int
)

AS

declare @ch varchar (8000),@ch2 varchar (8000),@ch3 varchar (8000),@ch4 varchar (8000), @ps  varchar (10)

select @ps = '', @ch =
replicate('ABCDEFGHJKLMNPQURSUVWXYZ',8), @ch2 =replicate('0123456789',9), @ch3 =
replicate('abcdefghjkmnpqursuvwxyz',8), @ch4 =replicate('~!@#$%^&()_',6)

while len(@ps)<@length 
	begin 
set @ps=@ps+substring(@ch,convert(int,rand()*len(@ch)-1),1)
+substring(@ch3,convert(int,rand()*len(@ch2)-1),1)
+substring(@ch2,convert(int,rand()*len(@ch3)-1),1)
+substring(@ch4,convert(int,rand()*len(@ch4)-1),1) 
	end

select [Password] = left(@ps,@length)

GO
grant exec on sp_GeneratePassword to appusers
GO

--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_ForgotPasswordBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ForgotPasswordBlueBinUser
GO
CREATE PROCEDURE sp_ForgotPasswordBlueBinUser
      @UserLogin NVARCHAR(30)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @BlueBinUserID INT, @LastUpdated DATETIME,@RandomPassword varchar(20), @newpwdHash varbinary(max)
	  
     
      SELECT @BlueBinUserID = BlueBinUserID
      FROM [bluebin].[BlueBinUser] WHERE UserLogin = @UserLogin --(HASHBYTES('SHA1', @oldpwdHash))--@Password
     
      IF @BlueBinUserID IS NOT NULL  
      BEGIN
            DECLARE @UserTable TABLE (BlueBinUserID int, UserLogin varchar(50), pwd varchar(10),created datetime)
			declare @table table (p varchar(50))

			insert @table exec sp_GeneratePassword 8 
			set @RandomPassword = (Select p from @table)
			insert @UserTable (BlueBinUserID,UserLogin,pwd,created) VALUES (@BlueBinUserID,@UserLogin,@RandomPassword,getdate())
			set @newpwdHash = convert(varbinary(max),rtrim(@RandomPassword))

						UPDATE [bluebin].[BlueBinUser]
						SET MustChangePassword = 1,LastUpdated = getdate(), [Password] = (HASHBYTES('SHA1', @newpwdHash))
						WHERE BlueBinUserID = @BlueBinUserID

			Select pwd from @UserTable
			--Select @newpwdHash
			--select (HASHBYTES('SHA1', @newpwdHash))
	--
	END
END
	
GO
grant exec on sp_ForgotPasswordBlueBinUser to appusers
GO




--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_ValidateBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ValidateBlueBinUser
GO

--exec sp_ValidateBlueBinUser 'gbutler@bluebin.com','12345'
--grant exec on sp_ValidateBlueBinUser to appusers

CREATE PROCEDURE [dbo].[sp_ValidateBlueBinUser]
      @UserLogin NVARCHAR(30),
      @Password varchar(max)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @BlueBinUserID INT, @LastLoginDate DATETIME, @pwdHash varbinary(max), @MustChangePassword int
	  set @pwdHash = convert(varbinary(max),rtrim(@Password))
     
      SELECT 
	  @BlueBinUserID = BlueBinUserID, 
	  @LastLoginDate = LastLoginDate, 
	  @MustChangePassword = 
		case when LastUpdated  + PasswordExpires < getdate() then 1 else MustChangePassword end  --Password Expiration Date or if flag set
      FROM [bluebin].[BlueBinUser] WHERE UserLogin = @UserLogin AND [Password] = (HASHBYTES('SHA1', @pwdHash))--@Password
     
      IF @UserLogin IS NOT NULL  
      BEGIN
            IF EXISTS(SELECT BlueBinUserID FROM [bluebin].[BlueBinUser] WHERE BlueBinUserID = @BlueBinUserID)
            BEGIN
				IF EXISTS(SELECT BlueBinUserID FROM [bluebin].[BlueBinUser] WHERE BlueBinUserID = @BlueBinUserID and Active = 1)
					BEGIN
					  IF EXISTS(SELECT BlueBinUserID FROM [bluebin].[BlueBinUser] WHERE BlueBinUserID = @BlueBinUserID and Active = 1 and MustChangePassword = 0)
						BEGIN
						UPDATE [bluebin].[BlueBinUser]
						SET LastLoginDate = GETDATE()
						WHERE BlueBinUserID = @BlueBinUserID
						SELECT @BlueBinUserID [BlueBinUserID] -- User Valid
						END
						ELSE
						BEGIN
						SELECT -3 -- Must Change Password
						END
					END
					ELSE
					BEGIN
						SELECT -2 -- User not active.
					END
			END
			ELSE
			BEGIN
				SELECT -1 -- User invalid.
			END
	END
--select * from bluebin.BlueBinUser where [Password] = HASHBYTES('SHA1', @Password)
END
GO
grant exec on sp_ValidateBlueBinUser to appusers
GO






--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_ChangePasswordBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_ChangePasswordBlueBinUser
GO

CREATE PROCEDURE [dbo].[sp_ChangePasswordBlueBinUser]
      @UserLogin NVARCHAR(30),
      @OldPassword varchar(max),
	  @NewPassword varchar(max),
	  @ConfirmNewPassword varchar(max)
AS
BEGIN
      SET NOCOUNT ON;
      DECLARE @BlueBinUserID INT, @LastLoginDate DATETIME, @newpwdHash varbinary(max), @oldpwdHash varbinary(max)
	  set @oldpwdHash = convert(varbinary(max),rtrim(@OldPassword))
	  set @newpwdHash = convert(varbinary(max),rtrim(@NewPassword))
     
      SELECT @BlueBinUserID = BlueBinUserID, @LastLoginDate = LastLoginDate
      FROM [bluebin].[BlueBinUser] WHERE UserLogin = @UserLogin AND [Password] = (HASHBYTES('SHA1', @oldpwdHash))--@Password
     
      IF @BlueBinUserID IS NOT NULL  
      BEGIN
            IF @NewPassword = @ConfirmNewPassword
            BEGIN
				IF @OldPassword <> @NewPassword
					BEGIN
					  IF (@NewPassword like '%[0-9]%')
						BEGIN
						UPDATE [bluebin].[BlueBinUser]
						SET LastLoginDate = GETDATE(), MustChangePassword = 0,LastUpdated = getdate(), [Password] = (HASHBYTES('SHA1', @newpwdHash))
						WHERE BlueBinUserID = @BlueBinUserID

						SELECT @BlueBinUserID [BlueBinUserID] -- User Valid
						END
						ELSE
						BEGIN
						SELECT -3 -- Must use at least one number in Password
						END
					END
					ELSE
					BEGIN
						SELECT -2 -- Must use a different password than previous.
					END
			END
			ELSE
			BEGIN
				SELECT -1 -- Passwords don't match.
			END
	END
	ELSE
	BEGIN
	 SELECT -4 -- Old Password does not match with our database records.
	END

END
GO
grant exec on sp_ChangePasswordBlueBinUser to appusers
GO


--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditGembaAuditNode') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditGembaAuditNode
GO

--exec sp_EditGembaAuditNode 'TEST'

CREATE PROCEDURE sp_EditGembaAuditNode
@GembaAuditNodeID int,
@Location char(5),
@AdditionalComments varchar(max),
@PS_EmptyBins int,
@PS_BackBins int,
@PS_StockOuts int,
@PS_ReturnVolume int,
@PS_NonBBT int,
@PS_OrangeCones int,
@PS_Comments varchar(max),
@RS_BinsFilled int,
@RS_EmptiesCollected int,
@RS_BinServices int,
@RS_NodeSwept int,
@RS_NodeCorrections int,
@RS_ShadowedUser varchar(255),
@RS_Comments varchar(max),
@SS_Supplied int,
@SS_KanbansPP int,
@SS_StockoutsPT int,
@SS_StockoutsMatch int,
@SS_HuddleBoardMatch int,
@SS_Comments varchar(max),
@NIS_Labels int,
@NIS_CardHolders int,
@NIS_BinsRacks int,
@NIS_GeneralAppearance int,
@NIS_Signage int,
@NIS_Comments varchar(max),
@PS_TotalScore int,
@RS_TotalScore int,
@SS_TotalScore int,
@NIS_TotalScore int,
@TotalScore int
			,@Auditer varchar(255),@ImageSourceIDPH int


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Update [gemba].[GembaAuditNode] SET

           [LocationID] = @Location
           ,[AdditionalComments] = @AdditionalComments
           ,[PS_EmptyBins] = @PS_EmptyBins
           ,[PS_BackBins] = @PS_BackBins
           ,[PS_StockOuts] = @PS_StockOuts
           ,[PS_ReturnVolume] = @PS_ReturnVolume
           ,[PS_NonBBT] = @PS_NonBBT
		   ,[PS_OrangeCones] = @PS_OrangeCones
           ,[PS_Comments] = @PS_Comments
           ,[RS_BinsFilled] = @RS_BinsFilled
		   ,[RS_EmptiesCollected] = @RS_EmptiesCollected
           ,[RS_BinServices] = @RS_BinServices
           ,[RS_NodeSwept] = @RS_NodeSwept
           ,[RS_NodeCorrections] = @RS_NodeCorrections
           ,[RS_ShadowedUserID] = (select BlueBinResourceID from bluebin.BlueBinResource where LastName + ', ' + FirstName + ' (' + Login + ')' = @RS_ShadowedUser)
           ,[RS_Comments] = @RS_Comments
           ,[SS_Supplied] = @SS_Supplied
		   ,[SS_KanbansPP] = @SS_KanbansPP
		   ,[SS_StockoutsPT] = @SS_StockoutsPT
		   ,[SS_StockoutsMatch] = @SS_StockoutsMatch
		   ,[SS_HuddleBoardMatch] = @SS_HuddleBoardMatch
		   ,[SS_Comments] = @SS_Comments
		   ,[NIS_Labels] = @NIS_Labels
           ,[NIS_CardHolders] = @NIS_CardHolders
           ,[NIS_BinsRacks] = @NIS_BinsRacks
           ,[NIS_GeneralAppearance] = @NIS_GeneralAppearance
           ,[NIS_Signage] = @NIS_Signage
           ,[NIS_Comments] = @NIS_Comments
           ,[PS_TotalScore] = @PS_TotalScore
           ,[RS_TotalScore] = @RS_TotalScore
		   ,[SS_TotalScore] = @SS_TotalScore
           ,[NIS_TotalScore] = @NIS_TotalScore
           ,[TotalScore] = @TotalScore
           ,[LastUpdated] = getdate()
WHERE [GembaAuditNodeID] = @GembaAuditNodeID
;--Insert New entry for Gemba into MasterLog
exec sp_InsertMasterLog @Auditer,'Gemba','Update Gemba Node Audit',@GembaAuditNodeID
;--Update the Images uploaded from the PlaceHolderID to the real entryID
exec sp_UpdateImages @GembaAuditNodeID,@Auditer,@ImageSourceIDPH
;--Update the master Log for images from the PlaceHolderID to the real entryID
update bluebin.MasterLog 
set ActionID = @GembaAuditNodeID 
where ActionType = 'Gemba' and 
		BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer) and 
			ActionID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer))+convert(varchar,@ImageSourceIDPH))))
--if exists(select * from bluebin.[Image] where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
--	BEGIN
--	update [bluebin].[Image] set ImageSourceID = @GembaAuditNodeID where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
--	END
END
GO
grant exec on sp_EditGembaAuditNode to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertGembaAuditNode') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertGembaAuditNode
GO

--exec sp_InsertGembaAuditNode 'TEST'

CREATE PROCEDURE sp_InsertGembaAuditNode
@Location char(5),
@Auditer varchar(255),
@AdditionalComments varchar(max),
@PS_EmptyBins int,
@PS_BackBins int,
@PS_StockOuts int,
@PS_ReturnVolume int,
@PS_NonBBT int,
@PS_OrangeCones int,
@PS_Comments varchar(max),
@RS_BinsFilled int,
@RS_EmptiesCollected int,
@RS_BinServices int,
@RS_NodeSwept int,
@RS_NodeCorrections int,
@RS_ShadowedUser varchar(255),
@RS_Comments varchar(max),
@SS_Supplied int,
@SS_KanbansPP int,
@SS_StockoutsPT int,
@SS_StockoutsMatch int,
@SS_HuddleBoardMatch int,
@SS_Comments varchar(max),
@NIS_Labels int,
@NIS_CardHolders int,
@NIS_BinsRacks int,
@NIS_GeneralAppearance int,
@NIS_Signage int,
@NIS_Comments varchar(max),
@PS_TotalScore int,
@RS_TotalScore int,
@SS_TotalScore int,
@NIS_TotalScore int,
@TotalScore int
			,@ImageSourceIDPH int



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
declare @GembaAuditNodeID int

Insert into [gemba].[GembaAuditNode]
(
	Date,
	LocationID,
	AuditerUserID,
	AdditionalComments,
	PS_EmptyBins,
	PS_BackBins,
	PS_StockOuts,
	PS_ReturnVolume,
	PS_NonBBT,
	PS_OrangeCones,
	PS_Comments,
	RS_BinsFilled,
	RS_EmptiesCollected,
	RS_BinServices,
	RS_NodeSwept,
	RS_NodeCorrections,
	RS_ShadowedUserID,
	RS_Comments,
	SS_Supplied,
	SS_KanbansPP,
	SS_StockoutsPT,
	SS_StockoutsMatch,
	SS_HuddleBoardMatch,
	SS_Comments,
	NIS_Labels,
	NIS_CardHolders,
	NIS_BinsRacks,
	NIS_GeneralAppearance,
	NIS_Signage,
	NIS_Comments,
	PS_TotalScore,
	RS_TotalScore,
	SS_TotalScore,
	NIS_TotalScore,
	TotalScore,
	Active,
	LastUpdated)
VALUES 
(
getdate(),  --Date
@Location,
(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer),
@AdditionalComments,
@PS_EmptyBins,
@PS_BackBins,
@PS_StockOuts,
@PS_ReturnVolume,
@PS_NonBBT,
@PS_OrangeCones,
@PS_Comments,
@RS_BinsFilled,
@RS_EmptiesCollected,
@RS_BinServices,
@RS_NodeSwept,
@RS_NodeCorrections,
(select BlueBinResourceID from bluebin.BlueBinResource where LastName + ', ' + FirstName + ' (' + Login + ')' = @RS_ShadowedUser ),
@RS_Comments,
@SS_Supplied,
@SS_KanbansPP,
@SS_StockoutsPT,
@SS_StockoutsMatch,
@SS_HuddleBoardMatch,
@SS_Comments,
@NIS_Labels,
@NIS_CardHolders,
@NIS_BinsRacks,
@NIS_GeneralAppearance,
@NIS_Signage,
@NIS_Comments,
@PS_TotalScore,
@RS_TotalScore,
@SS_TotalScore,
@NIS_TotalScore,
@TotalScore,
1, --Active
getdate() --Last Updated
)
;--Insert New entry for Gemba into MasterLog with  Scope Identity of the newly created ID
	SET @GembaAuditNodeID = SCOPE_IDENTITY()
	exec sp_InsertMasterLog @Auditer,'Gemba','New Gemba Node Audit',@GembaAuditNodeID
;--Update the Images uploaded from the PlaceHolderID to the real entryID
exec sp_UpdateImages @GembaAuditNodeID,@Auditer,@ImageSourceIDPH
;--Update the master Log for images from the PlaceHolderID to the real entryID
update bluebin.MasterLog 
set ActionID = @GembaAuditNodeID 
where ActionType = 'Gemba' and 
		BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer) and 
			ActionID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer))+convert(varchar,@ImageSourceIDPH))))
--if exists(select * from bluebin.[Image] where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
--	BEGIN
--	update [bluebin].[Image] set ImageSourceID = @GembaAuditNodeID where ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
--	END

END
GO
grant exec on sp_InsertGembaAuditNode to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertGembaAuditStage
GO

--exec sp_InsertGembaAuditStage 'TEST'

CREATE PROCEDURE sp_InsertGembaAuditStage
	@Auditer varchar(255),
	@KanbansFilled int,
	@KanbansFilledText varchar(max),
	@LeftBehind int,
	@FollowUpDistrib int,
	@FollowUpDistribText varchar(max),
	@Concerns varchar(max),
	@DirectOrderBins int,
	@OldestBin datetime,
	@CheckedOpenOrders int,
	@CheckedOpenOrdersText varchar(max),
	@HowManyLate int,
	@FollowUpBuyers int,
	@FollowUpBuyersText varchar(max),
	@UpdatedStatusTag int,
	@UpdatedStatusTagText varchar(max),
	@ReqsSubmitted int,
	@ReqsSubmittedText varchar(max),
	@BinsInOrder int,
	@BinsInOrderText varchar(max),
	@AreaNeatTidy int,
	@AreaNeatTidyText varchar(max),
	@CartsClean int,
	@CartsCleanText varchar(max),
	@AdditionalCommentsText varchar(max)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

declare @GembaAuditStageID int

insert into [gemba].[GembaAuditStage] (
    [Date],
	[AuditerUserID],
	[KanbansFilled],
	[KanbansFilledText],
	[LeftBehind],
	[FollowUpDistrib],
	[FollowUpDistribText],
	[Concerns],
	[DirectOrderBins],
	[OldestBin],
	[CheckOpenOrders],
	[CheckOpenOrdersText],
	[HowManyLate],
	[FollowUpBuyers],
	[FollowUpBuyersText],
	[UpdatedStatusTag],
	[UpdatedStatusTagText],
	[ReqsSubmitted],
	[ReqsSubmittedText],
	[BinsInOrder],
	[BinsInOrderText],
	[AreaNeatTidy],
	[AreaNeatTidyText],
	[CartsClean],
	[CartsCleanText],
	[AdditionalComments],
	[Active],
	[LastUpdated]
)
VALUES (
getdate(), --Date
(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Auditer),
@KanbansFilled,
@KanbansFilledText,
@LeftBehind,
@FollowUpDistrib,
@FollowUpDistribText,
@Concerns,
@DirectOrderBins,
@OldestBin,
@CheckedOpenOrders,
@CheckedOpenOrdersText,
@HowManyLate,
@FollowUpBuyers,
@FollowUpBuyersText,
@UpdatedStatusTag,
@UpdatedStatusTagText,
@ReqsSubmitted,
@ReqsSubmittedText,
@BinsInOrder,
@BinsInOrderText,
@AreaNeatTidy,
@AreaNeatTidyText,
@CartsClean,
@CartsCleanText,
@AdditionalCommentsText,
1, --Active
getdate())	--Last Updated

	SET @GembaAuditStageID = SCOPE_IDENTITY()
	exec sp_InsertMasterLog @Auditer,'Gemba','New Gemba Stage Audit',@GembaAuditStageID


END
GO
grant exec on sp_InsertGembaAuditStage to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertQCN
GO

--exec sp_InsertQCN 

CREATE PROCEDURE sp_InsertQCN
@LocationID varchar(5),
@ItemID varchar(32),
@Requester varchar(255),
@Assigned varchar(255),
@QCNType varchar(255),
@Details varchar(max),
@Updates varchar(max),
@QCNStatus varchar(255),
@UserLogin varchar (30)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

Declare @QCNID int

insert into [qcn].[QCN] 
([LocationID],
	[ItemID],
		[RequesterUserID],
			[AssignedUserID],
				[QCNTypeID],
					[Details],
						[Updates],
							[DateEntered],
								[DateCompleted],
									[QCNStatusID],
										[Active],
											[LastUpdated])

select 
@LocationID,
case when @ItemID = '' then NULL else @ItemID end,
(select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Requester),
case when @Assigned = '' then NULL else (select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Assigned) end,
(select [QCNTypeID] from [qcn].[QCNType] where [Name] = @QCNType),
@Details,
@Updates,
getdate(),
Case when @QCNStatus in ('Rejected','Completed') then getdate() else NULL end,
(select [QCNStatusID] from [qcn].[QCNStatus] where [Status] = @QCNStatus),
1, --Active
getdate() --LastUpdated


SET @QCNID = SCOPE_IDENTITY()
	exec sp_InsertMasterLog @UserLogin,'QCN','Submit QCN Form',@QCNID

END

GO
grant exec on sp_InsertQCN to appusers
GO

--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectVersion') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectVersion
GO


CREATE PROCEDURE sp_SelectVersion

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'Version'

END

GO
grant exec on sp_SelectVersion to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectTableauURL') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectTableauURL
GO


CREATE PROCEDURE sp_SelectTableauURL

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'TableauURL'

END

GO
grant exec on sp_SelectTableauURL to appusers
GO

--*****************************************************
--**************************SPROC**********************


if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNLocation') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNLocation
GO

--exec sp_SelectQCN ''
CREATE PROCEDURE sp_SelectQCNLocation

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select distinct a.LocationID,rTrim(a.ItemID) as ItemID,b.ItemClinicalDescription,rTrim(a.ItemID)+ ' - ' + b.ItemClinicalDescription as ExtendedDescription from [bluebin].[DimBin] a 
                                inner join [bluebin].[DimItem] b on rtrim(a.ItemID) = rtrim(b.ItemID)  where b.ItemClinicalDescription is not null 
								UNION select distinct LocationID,'' as ItemID,'' as ItemClinicalDescription, ''  as ExtendedDescription from [bluebin].[DimBin]
                                       order by rTrim(a.ItemID)+ ' - ' + b.ItemClinicalDescription asc

END
GO
grant exec on sp_SelectQCNLocation to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertImage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertImage
GO

--exec sp_SelectQCN ''
CREATE PROCEDURE sp_InsertImage
@ImageName varchar(100),
@ImageType varchar(10),
@ImageSource varchar(100),
@UserLogin varchar(100),
@ImageSourceID int,
@Image varbinary(max)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
insert into bluebin.[Image] 
(ImageName,ImageType,ImageSource,ImageSourceID,[Image],[Active],[DateCreated],[LastUpdated])        
VALUES 
(@ImageName,@ImageType,@ImageSource,(select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceID)))),@Image,1,getdate(),getdate())

;
declare @ImageSourcePH int = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceID))))
declare @Text varchar(60) = 'Insert Image - '+@ImageName

exec sp_InsertMasterLog @UserLogin,'Gemba',@Text,@ImageSourcePH

END
GO
grant exec on sp_InsertImage to appusers
GO



--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectImages') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectImages
GO

--exec sp_SelectImages '','gbutler@bluebin.com','151116'
CREATE PROCEDURE sp_SelectImages
@GembaAuditNodeID int,
@UserLogin varchar(100),
@ImageSourceIDPH int 



--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Select ImageID,ImageName,ImageType,ImageSource,ImageSourceID,Active,DateCreated 
from bluebin.[Image]    
where 
(ImageSourceID = @GembaAuditNodeID and ImageSource like 'GembaAuditNode%') 
or 
(ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH)))))
order by DateCreated desc


END
GO
grant exec on sp_SelectImages to appusers
GO


--*****************************************************
--**************************SPROC**********************

if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteImages') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteImages
GO

--exec sp_DeleteImages 'gbutler@bluebin.com','151116'
CREATE PROCEDURE sp_DeleteImages
@UserLogin varchar(100),
@ImageSourceIDPH int 


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
Delete 
from bluebin.[Image]
where 
ImageSourceID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))
;
Delete from bluebin.MasterLog 
where ActionType = 'Gemba' and 
		BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin) and 
			ActionID = (select convert(int,(convert(varchar,(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @UserLogin))+convert(varchar,@ImageSourceIDPH))))

END
GO
grant exec on sp_DeleteImages to appusers
GO


--*****************************************************
--**************************SPROC**********************

/*
Script to create default BlueBin Users with or without generic random passwords.
If Generic Passwords is set to 'Yes' then all users have the Password Pa55w0rd! otherwise it will be a random password
select * from bluebin.BlueBinUser
select * from bluebin.BlueBinResource
delete from bluebin.BlueBinUser
delete from bluebin.BlueBinResource
exec sp_InsertBlueBinUser 'Yes'
*/

if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertBlueBinUser') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertBlueBinUser
GO

CREATE PROCEDURE [dbo].[sp_InsertBlueBinUser]
      @UseGeneric varchar(3)

AS
BEGIN

DECLARE @UserTable TABLE (iid int identity (1,1) PRIMARY KEY,BlueBinUserID_id int, UserLogin varchar(255),LastName varchar(15),FirstName varchar(15),Email varchar(50),RoleName varchar (20), [Password] varchar(50),Created int);
DECLARE @length int = 8, @p varchar(50)
declare @iid int,@UserLogin varchar(255),@LastName varchar(15),@FirstName varchar(15),@Email varchar(50), @Password varbinary(max), @RoleID int, @RoleName varchar(20)





/*Users to Create.  List all users here*/
--**********************************************
insert @UserTable (BlueBinUserID_id, UserLogin,LastName,FirstName,Email, RoleName,[Password],Created) VALUES

(0,'gbutler@bluebin.com','Butler','Gerry','gbutler@bluebin.com','BlueBinPersonnel','',0),
(0,'dhagan@bluebin.com','Hagan','Derek','dhagan@bluebin.com','BlueBinPersonnel','',0),
(0,'snevins@bluebin.com','Nevins','Sabrina','snevins@bluebin.com','BlueBinPersonnel','',0),
(0,'chodge@bluebin.com','Hodge','Charles','chodge@bluebin.com','BlueBinPersonnel','',0),
(0,'rswan@bluebin.com','Swan','Robb','rswan@bluebin.com','BlueBinPersonnel','',0),
(0,'cpetschke@bluebin.com','Petschke','Carl','cpetschke@bluebin.com','BlueBinPersonnel','',0)


/*Create generic passwords*/
--**********************************************
select @iid = MIN(iid) from @usertable
while @iid < (select MAX(iid)+ 1 from @usertable)
begin
	declare @table table (p varchar(50))
	insert @table exec sp_GeneratePassword @length 
	update @UserTable set [Password] = 
		case	
			when @UseGeneric = 'Yes' then 'Pa55w0rd!'
			when @UseGeneric = 'No' then (select p from @table) 
			else 'Error!'
		end
		where iid = @iid
	delete from @table
	set @iid = @iid +1
END


/*Create Users and send out an email*/
--**********************************************
select @iid = MIN(iid) from @UserTable
while @iid < (select MAX(iid)+ 1 from @UserTable)
begin
	if not exists (select * from bluebin.BlueBinUser where UserLogin in (select UserLogin from @UserTable where iid = @iid))
	BEGIN	
	select @Password =  convert(varbinary(max),rtrim([Password])) from @UserTable where iid = @iid
	select @RoleID =  RoleID from bluebin.BlueBinRoles where RoleName = (select RoleName from @UserTable where iid = @iid)
		
	Insert Into bluebin.BlueBinUser (UserLogin,FirstName,LastName,MiddleName,Active,LastUpdated,RoleID,LastLoginDate,MustChangePassword,PasswordExpires,[Password],Email)
	Select UserLogin,FirstName,LastName,'',1,getdate(),@RoleID,getdate()-1,1,'90',HASHBYTES('SHA1',@Password),Email from @UserTable where iid = @iid
	update @UserTable set Created = 1 where iid = @iid
--exec sp_sacc_epoint_set_pwd @@IDENTITY,@PWD,@hosp

/*Email with info*/
--**********************************************
/*
			if @email_yn = 'Yes'
			Begin
			select @subject = (select 'New Production Site Login')
			set @message = 'New Production site now available for ' + @newsite1 + ' at ' + @newsite2 + '. You have 5 days to reset your password before being locked out. Your credentials are below.' ;
			set @message = @message + CHAR (13);
			set @message = @message + CHAR (13);
			set @message = @message +  'UID: ' + @user_login ;
			set @message = @message + CHAR (13);
			set @message = @message +  'PWD: ' + @PWD + '  (you will be prompted to change)';
			set @message = @message + CHAR (13);
			set @message = @message + CHAR (13);
			set @message = @message + 'If you have any problems, please contact the TPA ('+@TPA+') on this project.'


			exec sp_sendmail  
			 @varProfile='Support'
			, @varTo = @email
			, @varSubject = @subject
			, @varMessage = @message
			end
--**********************************************
*/
	END

	set @FirstName = (select FirstName from @UserTable where iid = @iid)
	set @LastName = (select LastName from @UserTable where iid = @iid)
	set @UserLogin = (select UserLogin from @UserTable where iid = @iid)
	set @Email = (select Email from @UserTable where iid = @iid)
	set @RoleName = (select RoleName from @UserTable where iid = @iid)

	if not exists (select BlueBinResourceID from bluebin.BlueBinResource where FirstName = @FirstName and LastName = @LastName)--select * from bluebin.BlueBinResource
	BEGIN
		exec sp_InsertBlueBinResource 
		@FirstName,
		@LastName,
		'',
		@UserLogin,
		@Email,'','',
		@RoleName
	END

	set @iid = @iid +1
	
END

Select UserLogin,FirstName,LastName,RoleName,[Password],Email from @UserTable order by LastName
END
GO




Print 'Sproc Add/Updates Complete'
--*************************************************************************************************************************************************
--Grant Exec
--*************************************************************************************************************************************************



Print 'Grant Exec Complete'
--*************************************************************************************************************************************************
--Key and Constraint Updates
--*************************************************************************************************************************************************


Print 'Keys and Constraints Complete'
--*************************************************************************************************************************************************
--General CleanUp
--*************************************************************************************************************************************************


if not exists (select * from bluebin.Config where ConfigName = 'TableauURL')
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES ('TableauURL','/bluebinanalytics/views/Demo/','Tableau',1,getdate())
END
GO

if exists (select * from bluebin.Config where ConfigName = 'Tableau')
BEGIN
delete from bluebin.Config where ConfigName = 'Tableau'
END
GO

if not exists (select * from bluebin.Config where ConfigName = 'LOCATION' and ConfigValue = 'STORE')
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES ('LOCATION','STORE','Tableau',1,getdate())
END
GO

if not exists (select * from bluebin.Config where ConfigName = 'PasswordExpires')
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES ('PasswordExpires','90','DMS',1,getdate())
END
GO
if not exists (select * from bluebin.Config where ConfigName = 'SiteAppURL')
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES ('SiteAppURL','bluebinoperations_demo','DMS',1,getdate())
END
GO

Print 'General Cleanup Complete'
--*************************************************************************************************************************************************
--Job Updates
--*************************************************************************************************************************************************



Print 'Job Updates Complete'


--*************************************************************************************************************************************************
--Version Update
--*************************************************************************************************************************************************

declare @version varchar(50) = '2.0.20160101' --Update Version Number here


if not exists (select * from bluebin.Config where ConfigName = 'Version')
BEGIN
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES ('Version',@version,'DMS',1,getdate())
END
ELSE
Update bluebin.Config set ConfigValue = @version where ConfigName = 'Version'

Print 'Version Updated to ' + @version
GO
