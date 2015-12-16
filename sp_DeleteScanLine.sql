
if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteScanLine') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteScanLine
GO

--exec sp_DeleteScanLine

CREATE PROCEDURE sp_DeleteScanLine
@ScanLineID int
--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

Delete from scan.ScanLine where ScanLineID = @ScanLineID


END
GO
grant exec on sp_DeleteScanLine to public
GO
