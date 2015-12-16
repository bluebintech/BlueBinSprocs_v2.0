USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[ClientInvoice]    Script Date: 10/2/2015 8:34:27 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ClientInvoice](
	[ClientInvoiceID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[ClientInvoice] [varchar](10) NOT NULL,
	[POID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Subtotal] [money] NOT NULL,
	[Tax] [money] NOT NULL,
	[Shipping] [money] NOT NULL,
	[Total] [money] NOT NULL
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ClientInvoice]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO

ALTER TABLE [dbo].[ClientInvoice]  WITH CHECK ADD FOREIGN KEY([POID])
REFERENCES [dbo].[PO] ([POID])
GO


