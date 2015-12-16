USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[VendorInvoiceLine]    Script Date: 10/2/2015 8:37:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[VendorInvoiceLine](
	[VendorInvoiceID] [int] NOT NULL,
	[VendorInvoiceLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal] [money] NOT NULL
)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[VendorInvoiceLine]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO

ALTER TABLE [dbo].[VendorInvoiceLine]  WITH CHECK ADD FOREIGN KEY([VendorInvoiceID])
REFERENCES [dbo].[VendorInvoice] ([VendorInvoiceID])
GO


