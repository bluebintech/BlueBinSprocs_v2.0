if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditQCN
GO

--exec sp_EditQCN 

CREATE PROCEDURE sp_EditQCN
@QCNID int,
@LocationID varchar(5),
@ItemID varchar(32),
@Requester varchar(255),
@Assigned varchar(255),
@QCNType varchar(255),
@Details varchar(max),
@Updates varchar(max),
@QCNStatus varchar(255)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	
update [qcn].[QCN] set
[LocationID] = @LocationID,
[ItemID] = @ItemID,
[RequesterUserID] = (select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Requester),
[AssignedUserID] = (select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Assigned),
[QCNTypeID] = (select [QCNTypeID] from [qcn].[QCNType] where [Name] = @QCNType),
[Details] = @Details,
[Updates] = @Updates,
[DateCompleted] = Case when @QCNStatus in ('Rejected','Completed') and DateCompleted is null then getdate() 
                        when @QCNStatus in ('Rejected','Completed') and DateCompleted is not null then DateCompleted
                            else NULL end,
[QCNStatusID] = (select [QCNStatusID] from [qcn].[QCNStatus] where [Status] = @QCNStatus),
[LastUpdated] = getdate() 
WHERE QCNID = @QCNID



END

GO
grant exec on sp_EditQCN to appusers
GO
