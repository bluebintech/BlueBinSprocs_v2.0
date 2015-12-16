USE [BlueBinHardware]
GO

/****** Object:  Table [dbo].[Vendor]    Script Date: 10/2/2015 8:36:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Vendor](
	[VendorID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[VendorName] [varchar](55) NOT NULL,
	[Address] [varchar](500) NULL,
	[City] [varchar](25) NULL,
	[State] [char](2) NULL,
	[Zipcode] [char](5) NULL,
	[Notes] [varchar](500) NULL
)
GO

SET ANSI_PADDING OFF
GO
