if exists (select * from dbo.sysobjects where id = object_id(N'tb_GembaDashboard') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_GembaDashboard
GO

--exec tb_GembaDashboard 
CREATE PROCEDURE tb_GembaDashboard

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

select 
	g.[GembaAuditNodeID],
	dl.[LocationID],
	g.LocationID as AuditLocationID,
        dl.[LocationName],
			dl.BlueBinFlag,
	u.LastName + ', ' + u.FirstName  as Auditer,
    u.[UserLogin] as Login,
	bbr.RoleName,
	g.PS_TotalScore,
	g.RS_TotalScore,
	g.SS_TotalScore,
	g.NIS_TotalScore,
	g.TotalScore,
	case when TotalScore < 90 then 1 else 0 end as ScoreUnder,
	(select count(*) from bluebin.DimLocation where BlueBinFlag = 1) as LocationCount,
    g.[Date],
	g2.[MaxDate] as LastAuditDate,
	case 
		when g.[Date] is null then 365
		else convert(int,(getdate() - g2.[MaxDate])) end as LastAudit,
    g.[LastUpdated]
from  [bluebin].[DimLocation] dl
		left join [gemba].[GembaAuditNode] g on dl.LocationID = g.LocationID
		left join (select Max([Date]) as MaxDate,LocationID from [gemba].[GembaAuditNode] group by LocationID) g2 on dl.LocationID = g2.LocationID and g.[Date] = g2.MaxDate
        --left join [bluebin].[DimLocation] dl on g.LocationID = dl.LocationID and dl.BlueBinFlag = 1
		left join [bluebin].[BlueBinUser] u on g.AuditerUserID = u.BlueBinUserID
		left join bluebin.BlueBinRoles bbr on u.RoleID = bbr.RoleID

WHERE dl.BlueBinFlag = 1 
            order by dl.LocationID,[Date] asc

END
GO
grant exec on tb_GembaDashboard to public
GO

