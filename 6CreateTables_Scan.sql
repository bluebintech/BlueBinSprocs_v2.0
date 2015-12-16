


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/****** Object:  Table [scan].[ScanBatch]     ******/

if not exists (select * from sys.tables where name = 'ScanBatch')
BEGIN
CREATE TABLE [scan].[ScanBatch](
	[ScanBatchID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[LocationID] char(7) NOT NULL,
	[BlueBinUserID] int NOT NULL,
	[Active] int NOT NULL,
	[ScanDateTime] datetime not null
)
END
GO


/****** Object:  Table [scan].[ScanLine]     ******/
if not exists (select * from sys.tables where name = 'ScanLine')
BEGIN
CREATE TABLE [scan].[ScanLine](
	[ScanLineID] INT NOT NULL IDENTITY(1,1)  PRIMARY KEY,
	[ScanBatchID] int NOT NULL,
	[Line] int NOT NULL,
	[ItemID] char (32) NOT NULL,
	[Qty] int NOT NULL,
	[Active] int NOT NULL,
    [ScanDateTime] datetime NOT NULL
)

ALTER TABLE [scan].[ScanLine] WITH CHECK ADD FOREIGN KEY([ScanBatchID])
REFERENCES [scan].[ScanBatch] ([ScanBatchID])

END
GO





