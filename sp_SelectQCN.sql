if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCN
GO

--exec sp_SelectQCN '',1
CREATE PROCEDURE sp_SelectQCN
@LocationName varchar(50)
,@Completed int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
declare @Completed int = 0
declare @QCNStatus int = 0
declare @QCNStatus2 int = 0
if @Completed = 0
begin
select @QCNStatus = QCNStatusID from qcn.QCNStatus where Status = 'Completed'
select @QCNStatus2 = QCNStatusID from qcn.QCNStatus where Status = 'Rejected'
end

select 
	q.[QCNID],
	q.[LocationID],
        dl.[LocationName],
	u.LastName + ', ' + u.FirstName  as RequesterUserName,
        u.[Login] as RequesterLogin,
    u.[Title] as RequesterTitleName,
    case when v.Login = 'None' then '' else v.LastName + ', ' + v.FirstName end as AssignedUserName,
        v.[Login] as AssignedLogin,
    v.[Title] as AssignedTitleName,
	qt.Name as QCNType,
q.[ItemID],
di.[ItemClinicalDescription],
db.[BinQty] as Par,
db.[BinUOM] as UOM,
di.[ItemManufacturer],
di.[ItemManufacturerNumber],
	q.[Details] as [DetailsText],
            case when q.[Details] ='' then 'No' else 'Yes' end Details,
	q.[Updates] as [UpdatesText],
            case when q.[Updates] ='' then 'No' else 'Yes' end Updates,
	case when qs.Status in ('Rejected','Completed') then convert(int,(q.[DateCompleted] - q.[DateEntered]))
		else convert(int,(getdate() - q.[DateEntered])) end as DaysOpen,
            q.[DateEntered],
	q.[DateCompleted],
	qs.Status,
    case when db.BinCurrentStatus is null then 'N/A' else db.BinCurrentStatus end as BinStatus,
    q.[LastUpdated]
from [qcn].[QCN] q
left join [bluebin].[DimBin] db on q.LocationID = db.LocationID and rtrim(q.ItemID) = rtrim(db.ItemID)
left join [bluebin].[DimItem] di on rtrim(q.ItemID) = rtrim(di.ItemID)
        inner join [bluebin].[DimLocation] dl on q.LocationID = dl.LocationID and dl.BlueBinFlag = 1
inner join [bluebin].[BlueBinResource] u on q.RequesterUserID = u.BlueBinResourceID
left join [bluebin].[BlueBinResource] v on q.AssignedUserID = v.BlueBinResourceID
inner join [qcn].[QCNType] qt on q.QCNTypeID = qt.QCNTypeID
inner join [qcn].[QCNStatus] qs on q.QCNStatusID = qs.QCNStatusID

WHERE q.Active = 1  
and q.QCNStatusID not in (@QCNStatus,@QCNStatus2)
            order by q.[DateEntered] asc--,convert(int,(getdate() - q.[DateEntered])) desc

END
GO
grant exec on sp_SelectQCN to appusers
GO

select * from qcn.QCN