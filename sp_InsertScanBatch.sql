
if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertScanBatch
GO

/*
declare @Location char(5),@Scanner varchar(255) = 'gbutler@bluebin.com'
select @Location = LocationID from bluebin.DimLocation where LocationName = 'DN NICU 1'
exec sp_InsertScanBatch @Location,@Scanner
*/

CREATE PROCEDURE sp_InsertScanBatch
@Location char(5),
@Scanner varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

insert into scan.ScanBatch (LocationID,BlueBinUserID,Active,ScanDateTime,Extracted)
select 
@Location,
(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Scanner),
1, --Default Active to Yes
getdate(),
0 --Default Extracted to No

Declare @ScanBatchID int  = SCOPE_IDENTITY()

exec sp_InsertMasterLog @Scanner,'Scan','New Scan Batch Entered',@ScanBatchID

Select @ScanBatchID

END
GO
grant exec on sp_InsertScanBatch to public
GO
