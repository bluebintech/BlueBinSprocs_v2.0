USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[Customers]    Script Date: 10/2/2015 8:36:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Customers](
	[CustomerID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[CustomerName] [varchar](55) NOT NULL,
	[ShippingAddress] [varchar](500) NOT NULL,
	[City] [varchar](25) NOT NULL,
	[State] [char](2) NOT NULL,
	[Zipcode] [char](5) NOT NULL,
	[Notes] [varchar](500) NULL
)
GO

SET ANSI_PADDING OFF
GO


