USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[Item]    Script Date: 10/2/2015 8:36:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Item](
	[ItemID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[ItemNumber] [varchar](30) NOT NULL,
	[ItemDescription] [varchar](50) NOT NULL,
	[VendorID] [int] NOT NULL,
	[VendorItemNumber] [varchar](35) NOT NULL,
	[UOM] [char](2) NOT NULL,
	[OrderUOM] [char](2) NOT NULL,
	[OrderUOMqty] [int] NOT NULL,
	[BBunitCost] [money] NOT NULL
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Item]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])
GO
