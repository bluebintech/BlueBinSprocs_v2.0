if exists (select * from dbo.sysobjects where id = object_id(N'tb_CostVariance') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_CostVariance
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_CostVariance

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON



SELECT f.ITEM,
       f.DESCRIPTION,
       Min(e.PO_DATE)   AS EFF_DATE,
       Max(e.PO_DATE)   AS EXP_DATE,
       Sum(c.QUANTITY)  AS QUANTITY,
       c.ENT_BUY_UOM    AS UOM,
       (d.MATCH_UNIT_CST/c.EBUY_UOM_MULT) AS UNIT_COST,
       h.ISS_ACCOUNT
INTO   #PriceHist
FROM   POLINE c
       INNER JOIN MAINVDTL d
               ON c.COMPANY = d.COMPANY
                  AND c.PO_NUMBER = d.PO_NUMBER
                  AND c.LINE_NBR = d.LINE_NBR
                  AND c.PO_CODE = d.PO_CODE
       INNER JOIN PURCHORDER e
               ON c.PO_NUMBER = e.PO_NUMBER
       INNER JOIN ITEMMAST f
               ON c.ITEM = f.ITEM
       LEFT JOIN (SELECT *
                  FROM   ITEMLOC
                  WHERE  LOCATION = 'STORE') g
              ON c.ITEM = g.ITEM
       LEFT JOIN ICCATEGORY h
              ON g.COMPANY = h.COMPANY
                 AND g.LOCATION = h.LOCATION
                 AND g.GL_CATEGORY = h.GL_CATEGORY
WHERE  c.ITEM_TYPE IN ( 'I', 'N' )
       AND CXL_QTY = 0
       AND Year(PO_DATE) >= Year(Getdate()) - 1
GROUP  BY f.ITEM,
          f.DESCRIPTION,
          c.ENT_BUY_UOM,
		  c.EBUY_UOM_MULT,
          d.MATCH_UNIT_CST,
          h.ISS_ACCOUNT

SELECT Row_number()
         OVER(
           PARTITION BY ITEM, UOM
           ORDER BY QUANTITY DESC) AS PriceSeq,
       ITEM,
       DESCRIPTION,
       EFF_DATE,
	   EXP_DATE,
       QUANTITY,
       UOM,
       UNIT_COST,
	   ISS_ACCOUNT
INTO   #PriceSeq
FROM   #PriceHist

SELECT *
INTO   #ModePrice
FROM   #PriceSeq
WHERE  PriceSeq = 1

SELECT c.PO_NUMBER,
       c.LINE_NBR,
       c.ITEM,
       c.DESCRIPTION,
       c.ITEM_TYPE,
       e.PO_DATE,
       c.QUANTITY,
       c.ENT_BUY_UOM,
       (c.ENT_UNIT_CST/c.EBUY_UOM_MULT)	as ENT_UNIT_CST,
       (d.MATCH_UNIT_CST/c.EBUY_UOM_MULT) as MATCH_UNIT_CST
INTO   #POHistory
FROM   POLINE c
       INNER JOIN MAINVDTL d
               ON c.COMPANY = d.COMPANY
                  AND c.PO_NUMBER = d.PO_NUMBER
                  AND c.LINE_NBR = d.LINE_NBR
                  AND c.PO_CODE = d.PO_CODE
       INNER JOIN PURCHORDER e
               ON c.PO_NUMBER = e.PO_NUMBER
       INNER JOIN ITEMMAST f
               ON c.ITEM = f.ITEM
WHERE  c.ITEM_TYPE IN ( 'I', 'N' )
       AND CXL_QTY = 0
       AND Year(PO_DATE) >= Year(Getdate()) - 1

SELECT a.*,
       b.UNIT_COST                                AS ModePrice,
       a.QUANTITY * ( a.UNIT_COST - b.UNIT_COST ) AS Variance
FROM   #PriceSeq a
       INNER JOIN #ModePrice b
               ON a.ITEM = b.ITEM
                  AND a.UOM = b.UOM
       LEFT JOIN #POHistory c
              ON a.ITEM = c.ITEM
                 AND a.UOM = c.ENT_BUY_UOM
                 AND a.UNIT_COST = c.MATCH_UNIT_CST
                 AND a.EFF_DATE <= c.PO_DATE
                 AND a.EXP_DATE >= c.PO_DATE 
ORDER by 2, 1
END
GO
grant exec on tb_CostVariance to public
GO
--DROP TABLE #PriceHist
--DROP TABLE #PriceSeq
--DROP TABLE #ModePrice
--DROP TABLE #POHistory