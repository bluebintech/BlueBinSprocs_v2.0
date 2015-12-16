if exists (select * from dbo.sysobjects where id = object_id(N'tb_PickLines') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_PickLines
GO

CREATE PROCEDURE tb_PickLines
AS
BEGIN
SET NOCOUNT ON


SELECT Cast(IssueDate AS DATE) AS Date,
       Count(*)                AS PickLine
FROM   bluebin.FactIssue
GROUP  BY Cast(IssueDate AS DATE)


END
GO
grant exec on tb_PickLines to public
GO
