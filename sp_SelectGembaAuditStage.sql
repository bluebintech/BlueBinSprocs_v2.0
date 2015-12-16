if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectGembaAuditStage') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectGembaAuditStage
GO


--exec sp_SelectGembaAuditStage
CREATE PROCEDURE sp_SelectGembaAuditStage

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
      a.[GembaAuditStageID]
      ,a.[Date]
      ,b.LastName + ', ' + b.FirstName as Auditer
      ,b.UserLogin as AuditerLogin
      ,a.[OldestBin]
      ,case when a.[KanbansFilled] = 1 then 'Yes' else 'No' end [KanbansFilled]
      ,case when a.[ReqsSubmitted] = 3 then 'Need' when a.[ReqsSubmitted] = 0 then 'No' else 'Yes' end [ReqsSubmitted]
      ,case when a.[BinsInOrder] = 3 then 'Need' when a.[BinsInOrder] = 0 then 'No'  else 'Yes' end [BinsInOrder]
      ,case when a.[AreaNeatTidy] = 3 then 'Need' when a.[AreaNeatTidy] = 0 then 'No'  else 'Yes' end [AreaNeatTidy]
      ,case when a.[CartsClean] = 3 then 'Need' when a.[CartsClean] = 0 then 'No'  else 'Yes' end [CartsClean]
      ,a.[AdditionalComments] as AdditionalCommentsStageText 
      ,case when a.[AdditionalComments] = '' then 'None' else 'Yes' end [AdditionalCommentsStage]
	  ,a.Concerns as ConcernsText
     ,case when a.[Concerns] = '' then 'None' else 'Yes' end [Concerns],
      a.LastUpdated
  FROM [gemba].[GembaAuditStage] a
  inner join bluebin.BlueBinUser b on a.AuditerUserID = b.BlueBinUserID WHERE a.Active = 1 order by a.[Date] desc

END
GO
grant exec on sp_SelectGembaAuditStage to appusers
GO
