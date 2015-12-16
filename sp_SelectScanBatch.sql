
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectScanBatch') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectScanBatch
GO

--exec sp_SelectScanBatch

CREATE PROCEDURE sp_SelectScanBatch

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
select 
sb.ScanBatchID,
sb.LocationID,
dl.LocationName as LocationName,
max(sl.Line) as BinsScanned,
sb.ScanDateTime as [DateScanned]

from scan.ScanBatch sb
inner join bluebin.DimLocation dl on sb.LocationID = dl.LocationID
inner join scan.ScanLine sl on sb.ScanBatchID = sl.ScanBatchID
group by 
sb.ScanBatchID,
sb.LocationID,
dl.LocationName,
sb.ScanDateTime

END
GO
grant exec on sp_SelectScanBatch to public
GO
