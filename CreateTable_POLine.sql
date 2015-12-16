USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[POLine]    Script Date: 10/2/2015 8:36:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[POLine](
	[POID] [int] NOT NULL,
	[POLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[Subtotal] [money] NOT NULL
 )

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[POLine]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO

ALTER TABLE [dbo].[POLine]  WITH CHECK ADD FOREIGN KEY([POID])
REFERENCES [dbo].[PO] ([POID])
GO


