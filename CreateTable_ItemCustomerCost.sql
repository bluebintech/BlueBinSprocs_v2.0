USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[ItemCustomerCost]    Script Date: 10/2/2015 8:36:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ItemCustomerCost](
	[ItemCustomerCostID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[ItemID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CustomUnitCost] [money] NOT NULL,
	[IsDefault] [int] NOT NULL
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ItemCustomerCost]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO

ALTER TABLE [dbo].[ItemCustomerCost]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO