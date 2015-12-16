USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[VendorInvoice]    Script Date: 10/2/2015 8:36:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[VendorInvoice](
	[VendorInvoiceID] [INT] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[VendorInvoice] [varchar](20) NOT NULL,
	[POID] [int] NOT NULL,
	[VendorID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Subtotal] [money] not null,
	[Tax] [money] NOT NULL,
	[Shipping] [money] NOT NULL,
	[Total] [money] NOT NULL,
	[ShipDate] [date] NULL,
	[ReceiveDate] [date] NULL
 )

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[VendorInvoice]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO

ALTER TABLE [dbo].[VendorInvoice]  WITH CHECK ADD FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendor] ([VendorID])
GO

ALTER TABLE [dbo].[VendorInvoice]  WITH CHECK ADD FOREIGN KEY([POID])
REFERENCES [dbo].[PO] ([POID])
GO


