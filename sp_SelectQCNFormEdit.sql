if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNFormEdit') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNFormEdit
GO

--exec sp_SelectQCNFormEdit '6'
CREATE PROCEDURE sp_SelectQCNFormEdit
@QCNID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
	[QCNID]
	,[LocationID]
	,rtrim(a.ItemID) as ItemID
	,b1.LastName + ', ' + b1.FirstName + ' (' + b1.Login + ')' as [RequesterUser]
	,b2.LastName + ', ' + b2.FirstName + ' (' + b2.Login + ')' as [AssignedUser]
	,qt.Name as QCNType
	,[Details]
	,[Updates]
	,convert(varchar,a.[DateEntered],101) as [DateEntered]
	,convert(varchar,a.[DateCompleted],101) as [DateCompleted]
	,qs.Status as QCNStatus
	,convert(varchar,a.[LastUpdated],101) as [LastUpdated]
		FROM [qcn].[QCN] a 
			inner join bluebin.BlueBinResource b1 on a.[RequesterUserID] = b1.BlueBinResourceID
			left join bluebin.BlueBinResource b2 on a.[AssignedUserID] = b2.BlueBinResourceID
			left join qcn.QCNStatus qs on a.[QCNStatusID] = qs.[QCNStatusID]
			left join qcn.QCNType qt on a.[QCNTypeID] = qt.[QCNTypeID]
		where a.QCNID=@QCNID

END
GO
grant exec on sp_SelectQCNFormEdit to appusers
GO

