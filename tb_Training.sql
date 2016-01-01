IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'tb_Training')
                    AND type IN ( N'P', N'PC' ) ) 

DROP PROCEDURE  tb_Training
GO

CREATE PROCEDURE tb_Training

AS

SELECT 
bbr.LastName + ', ' + bbr.FirstName as Name
	  ,bbt.[Form3000] as [3000]
      ,bbt.[Form3001] as [3001]
      ,bbt.[Form3002] as [3002]
      ,bbt.[Form3003] as [3003]
      ,bbt.[Form3004] as [3004]
      ,bbt.[Form3005] as [3005]
      ,bbt.[Form3006] as [3006]
      ,bbt.[Form3007] as [3007]
      ,bbt.[Form3008] as [3008]
      ,bbt.[Form3009] as [3009]
      ,bbt.[Form3010] as [3010]
      ,left(bbt.[LastUpdated],11) as LastUpdated
FROM   bluebin.BlueBinTraining bbt
inner join bluebin.BlueBinResource bbr on bbt.BlueBinResourceID = bbr.BlueBinResourceID

ORDER BY 
bbr.LastName + ', ' + bbr.FirstName

GO

grant exec on tb_Training to public
GO