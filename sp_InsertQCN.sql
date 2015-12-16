if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertQCN') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertQCN
GO

--exec sp_InsertQCN 

CREATE PROCEDURE sp_InsertQCN
@LocationID varchar(5),
@ItemID varchar(32),
@Requester varchar(255),
@Assigned varchar(255),
@QCNType varchar(255),
@Details varchar(max),
@Updates varchar(max),
@QCNStatus varchar(255),
@UserLogin varchar (30)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

Declare @QCNID int

insert into [qcn].[QCN] 
([LocationID],
	[ItemID],
		[RequesterUserID],
			[AssignedUserID],
				[QCNTypeID],
					[Details],
						[Updates],
							[DateEntered],
								[DateCompleted],
									[QCNStatusID],
										[Active],
											[LastUpdated])

select 
@LocationID,
case when @ItemID = '' then NULL else @ItemID end,
(select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Requester),
case when @Assigned = '' then NULL else (select [BlueBinResourceID] from [bluebin].[BlueBinResource] where LastName + ', ' + FirstName + ' (' + Login + ')' = @Assigned) end,
(select [QCNTypeID] from [qcn].[QCNType] where [Name] = @QCNType),
@Details,
@Updates,
getdate(),
Case when @QCNStatus in('Rejected','Completed') then getdate() else NULL end,
(select [QCNStatusID] from [qcn].[QCNStatus] where [Status] = @QCNStatus),
1, --Active
getdate() --LastUpdated


SET @QCNID = SCOPE_IDENTITY()
	exec sp_InsertMasterLog @UserLogin,'QCN','Submit QCN Form',@QCNID

END

GO
grant exec on sp_InsertQCN to appusers
GO