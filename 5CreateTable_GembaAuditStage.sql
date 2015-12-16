
/****** Object:  Table [gemba].[GembaAuditStage]    Script Date: 10/2/2015 8:34:27 AM ******/

--DROP TABLE [gemba].[GembaAuditStage]
--select * from  [gemba].[GembaAuditStage]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
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

SET ANSI_PADDING OFF
GO


