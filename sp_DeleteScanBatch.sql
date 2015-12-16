
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteScanBatch
GO

--exec sp_DeleteScanBatch

CREATE PROCEDURE sp_DeleteScanBatch
@ScanBatchID int
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

Update scan.ScanBatch set Active = 0 where ScanBatchID = @ScanBatchID
Update scan.ScanLine set Active = 0 where ScanBatchID = @ScanBatchID


END
GO
grant exec on sp_DeleteScanBatch to public
GO
