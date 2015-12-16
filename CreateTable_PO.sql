USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[PO]    Script Date: 10/2/2015 8:36:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[PO](
	[POID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[PO] [varchar](10) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[Total] [money] NOT NULL,
	[OrderDate] [date] NOT NULL

)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PO]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO

ALTER TABLE [dbo].[PO]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])
GO


