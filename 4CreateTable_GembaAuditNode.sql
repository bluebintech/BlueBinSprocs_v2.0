
/****** Object:  Table [gemba].[GembaAuditNode]    Script Date: 10/2/2015 8:34:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


SET ANSI_PADDING ON
GO
--DROP TABLE [gemba].[GembaAuditNode]
--select * from  [gemba].[GembaAuditNode]
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

SET ANSI_PADDING OFF
GO






