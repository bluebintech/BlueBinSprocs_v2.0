
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertScanLine') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertScanLine
GO

/* 
exec sp_InsertScanLine 1,'0001217','20',1
exec sp_InsertScanLine 1,'0001218','5',2
exec sp_InsertScanLine 1,'0002205','100',3
*/

CREATE PROCEDURE sp_InsertScanLine
@ScanBatchID int,
@Item varchar(30),
@Qty int,
@Line int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

if exists (select * from bluebin.DimItem where ItemID = @Item) 
BEGIN
insert into scan.ScanLine (ScanBatchID,Line,ItemID,Qty,Active,ScanDateTime,Extracted)
	select 
	@ScanBatchID,
	@Line,
	@Item,
	@Qty,
	1,--Active Default to Yes
	getdate(),
	0 --Extracted default to No
END
	ELSE
	BEGIN
	SELECT -1 -- Must Change Password
	delete from scan.ScanLine where ScanBatchID = @ScanBatchID
	delete from scan.ScanBatch where ScanBatchID = @ScanBatchID
	END

END
GO
grant exec on sp_InsertScanLine to public
GO
