
if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectScanLines') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectScanLines
GO

--exec sp_SelectScanLines 1

CREATE PROCEDURE sp_SelectScanLines
@ScanBatchID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
select 
sb.ScanBatchID,
db.BinKey,
db.BinSequence,
sb.LocationID,
dl.LocationName as LocationName,
sl.ItemID,
di.ItemDescription,
sl.Qty,
sl.Line,
sb.ScanDateTime as [DateScanned],
case when sb.Extracted = 0 then 'No' Else 'Yes' end as Extracted

from scan.ScanLine sl
inner join scan.ScanBatch sb on sl.ScanBatchID = sb.ScanBatchID
inner join bluebin.DimBin db on sb.LocationID = db.LocationID and sl.ItemID = db.ItemID
inner join bluebin.DimItem di on sl.ItemID = di.ItemID
inner join bluebin.DimLocation dl on sb.LocationID = dl.LocationID
where sl.ScanBatchID = @ScanBatchID and sl.Active = 1
order by sl.Line



END
GO
grant exec on sp_SelectScanLines to public
GO
