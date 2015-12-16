USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[ClientInvoiceLine]    Script Date: 10/2/2015 8:35:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ClientInvoiceLine](
	[ClientInvoiceID] [int] NOT NULL,
	[ClientInvoiceLine] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal] [money] NOT NULL,

)

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[ClientInvoiceLine]  WITH CHECK ADD FOREIGN KEY([ClientInvoiceID])
REFERENCES [dbo].[ClientInvoice] ([ClientInvoiceID])
GO

ALTER TABLE [dbo].[ClientInvoiceLine]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO


