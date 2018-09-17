# 1.ReadyToPick
SELECT DISTINCT
  CS.SHIPMENT_NO     AS shipmentID,
  CS.CUSTOMER_NAME   AS orderID,
  BT.NAME            AS boxType,
  ITD.SKU_NO         AS SKUNO,
  ITD.ITEM_NO        AS SKUID,
  POP.AMOUNT         AS quality,
  CS.DELIVERY_DATE   AS planDepartTime,
  SL.NAME            AS stockPosition1,
  ''                 AS stockPosition2,
  'Ready to Pick'    AS workFlowStatus,
  PP.NAME            AS ppName,
  PO.PICKINGORDER_NO AS batchNo
FROM OB_PICKINGORDERPOSITION POP
  LEFT JOIN OB_PICKINGORDER PO ON POP.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POP.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
  LEFT JOIN OB_PICKINGCATEGORY PC ON CS.PICKINGCATEGORY_ID = PC.ID
  LEFT JOIN OB_PROCESSPATH PP ON PC.PROCESSPATH_ID = PP.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON POP.ITEMDATA_ID = ITD.ID
  LEFT JOIN INV_STOCKUNIT ST ON POP.PICKFROMSTOCKUNIT_ID = ST.ID
  LEFT JOIN INV_UNITLOAD UL ON ST.UNITLOAD_ID = UL.ID
  LEFT JOIN MD_STORAGELOCATION SL ON UL.STORAGELOCATION_ID = SL.ID
WHERE POP.STATE = '200'
      AND POP.CUSTOMERSHIPMENTPOSITION_ID
          IN (SELECT CSP.ID
              FROM OB_CUSTOMERSHIPMENTPOSITION CSP
                LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
              WHERE CS.DELIVERY_DATE = :exsdTime);

# 2.PickingNotYetPicked
SELECT DISTINCT
  CS.SHIPMENT_NO                   AS shipmentID,
  CS.CUSTOMER_NAME                 AS orderID,
  BT.NAME                          AS boxType,
  ITD.SKU_NO                       AS SKUNO,
  ITD.ITEM_NO                      AS SKUID,
  (POP.AMOUNT - POP.AMOUNT_PICKED) AS quality,
  CS.DELIVERY_DATE                 AS planDepartTime,
  POP.PICKFROMLOCATION_NAME        AS stockPosition1,
  ''                               AS stockPosition2,
  'Picking Not Yet Picked'         AS workFlowStatus,
  PP.NAME                          AS ppName,
  PO.PICKINGORDER_NO               AS batchNo
FROM OB_PICKINGORDERPOSITION POP
  LEFT JOIN OB_PICKINGORDER PO ON POP.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POP.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON POP.ITEMDATA_ID = ITD.ID
WHERE PO.STATE < 600
      AND POP.CUSTOMERSHIPMENTPOSITION_ID
          IN (SELECT CSP.ID
              FROM OB_CUSTOMERSHIPMENTPOSITION CSP
                LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
              WHERE CS.DELIVERY_DATE = :exsdTime)
      AND POP.PICKINGORDER_ID IS NOT NULL
      AND (POP.AMOUNT - POP.AMOUNT_PICKED) > 0;

# 3.PickingPicked
SELECT
  CS.SHIPMENT_NO                   AS shipmentID,
  CS.CUSTOMER_NAME                 AS orderID,
  BT.NAME                          AS boxType,
  ITD.SKU_NO                       AS SKUNO,
  ITD.ITEM_NO                      AS SKUID,
  coalesce((POP.AMOUNT_PICKED), 0) AS quality,
  CS.DELIVERY_DATE                 AS planDepartTime,
  S.NAME                           AS stockPosition1,
  ''                               AS stockPosition2,
  'PickingPicked'                  AS workFlowStatus,
  PP.NAME                          AS ppName,
  PO.PICKINGORDER_NO               AS batchNo
FROM
  OB_CUSTOMERSHIPMENT CS
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON CS.ID = CSP.SHIPMENT_ID
  LEFT JOIN OB_PICKINGORDERPOSITION POP ON CSP.ID = POP.CUSTOMERSHIPMENTPOSITION_ID
  LEFT JOIN OB_PICKINGUNITLOAD PUL ON POP.PICKTOUNITLOAD_ID = PUL.ID

  LEFT JOIN OB_PICKINGORDER PO ON POP.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON POP.ITEMDATA_ID = ITD.ID
  LEFT JOIN INV_UNITLOAD UN ON PUL.UNITLOAD_ID = UN.ID
  LEFT JOIN MD_STORAGELOCATION S ON UN.STORAGELOCATION_ID = S.ID
WHERE

  CS.DELIVERY_DATE = :exsdTime AND POP.AMOUNT_PICKED > 0
  AND (CSP.STATE <= '600' OR (CSP.STATE = '605' AND PUL.STATE = '600'));

# 4.Rebatched
SELECT
  CS.SHIPMENT_NO                   AS shipmentID,
  CS.CUSTOMER_NAME                 AS orderID,
  BT.NAME                          AS boxType,
  ITD.SKU_NO                       AS SKUNO,
  ITD.ITEM_NO                      AS SKUID,
  coalesce((POP.AMOUNT_PICKED), 0) AS quality,
  CS.DELIVERY_DATE                 AS planDepartTime,
  SL.NAME                          AS stockPosition1,
  RSL.NAME                         AS stockPosition2,
  'Rebatched'                      AS workFlowStatus,
  PP.NAME                          AS ppName,
  PO.PICKINGORDER_NO               AS batchNo
FROM OB_PICKINGORDERPOSITION POP
  LEFT JOIN OB_PICKINGORDER PO ON POP.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID
  LEFT JOIN OB_PICKINGUNITLOAD PUL ON POP.PICKTOUNITLOAD_ID = PUL.ID
  LEFT JOIN INV_UNITLOAD UL ON PUL.UNITLOAD_ID = UL.ID
  LEFT JOIN MD_STORAGELOCATION SL ON UL.STORAGELOCATION_ID = SL.ID
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POP.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON POP.ITEMDATA_ID = ITD.ID
  LEFT JOIN OB_REBATCHREQUESTPOSITION RQP ON UL.ID = RQP.SOURCE_ID
  LEFT JOIN OB_REBATCHSLOT RSL ON RQP.REBATCHSLOT_ID = RSL.ID
WHERE POP.CUSTOMERSHIPMENTPOSITION_ID
      IN (SELECT CSP.ID
          FROM OB_CUSTOMERSHIPMENTPOSITION CSP
            LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
          WHERE CS.DELIVERY_DATE = :exsdTime
                AND (CS.STATE = '610' OR CS.STATE = '605'))
      AND PUL.STATE = '610';

# 5.RebinBuffer
SELECT
  CS.SHIPMENT_NO               AS shipmentID,
  CS.CUSTOMER_NAME             AS orderID,
  BT.NAME                      AS boxType,
  ITD.SKU_NO                   AS SKUNO,
  ITD.ITEM_NO                  AS SKUID,
  coalesce(SUM(RBP.AMOUNT), 0) AS quality,
  CS.DELIVERY_DATE             AS planDepartTime,
  RBP.REBINFROMCONTAINER_NAME  AS stockPosition1,
  ''                           AS stockPosition2,
  'Rebin Buffer'               AS workFlowStatus,
  PP.NAME                      AS ppName,
  PO.PICKINGORDER_NO           AS batchNo
FROM OB_REBINREQUESTPOSITION RBP
  LEFT JOIN OB_REBINREQUEST RQ ON RBP.REBINREQUEST_ID = RQ.ID
  LEFT JOIN OB_PICKINGORDER PO ON RQ.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON RBP.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON RBP.ITEMDATA_ID = ITD.ID
  LEFT JOIN OB_REBINWALL RW ON RBP.REBINWALL_ID = RW.ID
WHERE RBP.AMOUNT_REBINED = 0
      AND RBP.CUSTOMERSHIPMENTPOSITION_ID
          IN (SELECT CSP.ID
              FROM OB_CUSTOMERSHIPMENTPOSITION CSP
                LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
              WHERE CSP.STATE = '620'
                    AND CS.DELIVERY_DATE = :exsdTime)
      AND CSP.ID NOT IN
          (SELECT RBP.CUSTOMERSHIPMENTPOSITION_ID
           FROM OB_REBINREQUESTPOSITION RBP
           WHERE RBP.STATE = 'LOSE')
GROUP BY CS.SHIPMENT_NO, CS.CUSTOMER_NAME, BT.NAME, ITD.SKU_NO, ITD.ITEM_NO, CS.DELIVERY_DATE,
  RBP.REBINFROMCONTAINER_NAME, '', 'Rebin Buffer', PP.NAME, PO.PICKINGORDER_NO;

# 6.Rebined
SELECT DISTINCT
  CS.SHIPMENT_NO                        AS shipmentID,
  CS.CUSTOMER_NAME                      AS orderID,
  BT.NAME                               AS boxType,
  ITD.SKU_NO                            AS SKUNO,
  ITD.ITEM_NO                           AS SKUID,
  coalesce(sum(RBP.AMOUNT), 0)          AS quality,
  CS.DELIVERY_DATE                      AS planDepartTime,
  concat(RW.NAME, RBP.REBINTOCELL_NAME) AS stockPosition1,
  ''                                    AS stockPosition2,
  'Rebined'                             AS workFlowStatus,
  PP.NAME                               AS ppName,
  PO.PICKINGORDER_NO                    AS batchNo
FROM OB_REBINREQUESTPOSITION RBP
  LEFT JOIN OB_REBINREQUEST RQ ON RBP.REBINREQUEST_ID = RQ.ID
  LEFT JOIN OB_PICKINGORDER PO ON RQ.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON RBP.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON RBP.ITEMDATA_ID = ITD.ID
  LEFT JOIN OB_REBINWALL RW ON RBP.REBINWALL_ID = RW.ID
WHERE
  ((PO.STATE <> '700') OR (PO.STATE = '700' AND CS.STATE = '630' AND CS.ID NOT IN (SELECT CS.ID
                                                                                   FROM OB_CUSTOMERSHIPMENT CS
                                                                                   WHERE CS.STATE = '1100')))
  AND CS.DELIVERY_DATE = :exsdTime
  AND RBP.STATE <> 'RAW'
  AND RBP.STATE <> 'LOSE'
GROUP BY shipmentID, orderID, boxType, SKUNO, SKUID, planDepartTime, stockPosition1,
  workFlowStatus, PP.NAME, PO.PICKINGORDER_NO;

# 7.ScanVerify
SELECT DISTINCT
  CS.SHIPMENT_NO     AS shipmentID,
  CS.CUSTOMER_NAME   AS orderID,
  BT.NAME            AS boxType,
  ITD.SKU_NO         AS SKUNO,
  ITD.ITEM_NO        AS SKUID,
  CSP.AMOUNT         AS quality,
  CS.DELIVERY_DATE   AS planDepartTime,
  S.NAME             AS stockPosition1,
  PA.NAME            AS stockPosition2,
  'Scan Verify'      AS workFlowStatus,
  PP.NAME            AS ppName,
  PO.PICKINGORDER_NO AS batchNo
FROM OB_CUSTOMERSHIPMENT CS
  LEFT JOIN OB_PACKINGREQUEST PR ON CS.ID = PR.CUSTOMERSHIPMENT_ID
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON CS.ID = CSP.SHIPMENT_ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON CSP.ITEMDATA_ID = ITD.ID
  LEFT JOIN OB_PACKINGSTATION PA ON PR.PACKINGSTATION_ID = PA.ID

  LEFT JOIN INV_UNITLOAD_SHIPMENT INV ON CS.ID = INV.SHIPMENT_ID
  LEFT JOIN INV_UNITLOAD UN ON INV.UNITLOAD_ID = UN.ID
  LEFT JOIN MD_STORAGELOCATION S ON UN.STORAGELOCATION_ID = S.ID

  LEFT JOIN OB_PICKINGORDERPOSITION POP ON CSP.ID = POP.CUSTOMERSHIPMENTPOSITION_ID
  LEFT JOIN OB_PICKINGORDER PO ON POP.PICKINGORDER_ID = PO.ID

  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID

WHERE
  CS.DELIVERY_DATE = :exsdTime

  AND CS.STATE = 640;

# 8.Packed
SELECT DISTINCT
  A.SHIPMENT_NO   AS shipmentID,
  A.ORDER_NO      AS orderID,
  A.NAME          AS boxType,
  A.SKU_NO        AS SKUNO,
  A.ITEM_NO       AS SKUID,
  A.AMOUNT        AS quality,
  A.DELIVERY_DATE AS planDepartTime,
  A.packedCell    AS stockPosition1,
  ''              AS stockPosition2,
  'Packed'        AS workFlowStatus,
  A.ppName        AS ppName,
  A.batchNo       AS batchNo
FROM (SELECT
        CSP.ID,
        CS.SHIPMENT_NO,
        CO.ORDER_NO,
        BT.NAME,
        ITD.SKU_NO,
        ITD.ITEM_NO,
        CSP.AMOUNT,
        CS.DELIVERY_DATE,
        B.NAME            AS ppName,
        B.PICKINGORDER_NO AS batchNo,
        S.NAME            AS packedCell
      FROM OB_CUSTOMERSHIPMENT CS
        LEFT JOIN OB_PICKINGCATEGORY PC ON CS.PICKINGCATEGORY_ID = PC.ID
        LEFT JOIN OB_PROCESSPATH PP ON PC.PROCESSPATH_ID = PP.ID
        LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON CS.ID = CSP.SHIPMENT_ID
        LEFT JOIN INV_UNITLOAD_SHIPMENT INV ON CS.ID = INV.SHIPMENT_ID
        LEFT JOIN INV_UNITLOAD UN ON INV.UNITLOAD_ID = UN.ID
        LEFT JOIN MD_STORAGELOCATION S ON UN.STORAGELOCATION_ID = S.ID
        LEFT JOIN (SELECT DISTINCT
                     POP.CUSTOMERSHIPMENTPOSITION_ID,
                     PO.PICKINGORDER_NO,
                     PP.NAME
                   FROM OB_PICKINGORDER PO
                     LEFT JOIN OB_PICKINGORDERPOSITION POP ON PO.ID = POP.PICKINGORDER_ID
                     LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID) B
          ON CSP.ID = B.CUSTOMERSHIPMENTPOSITION_ID
        LEFT JOIN OB_CUSTOMERORDER CO ON CS.ORDER_ID = CO.ID
        LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
        LEFT JOIN MD_ITEMDATA ITD ON CSP.ITEMDATA_ID = ITD.ID
      WHERE CS.DELIVERY_DATE = :exsdTime
            AND CS.STATE = '650') A;

# 9.problem
SELECT DISTINCT
  A.SHIPMENT_NO     AS shipmentID,
  A.ORDER_NO        AS orderID,
  A.NAME            AS boxType,
  A.SKU_NO          AS SKUNO,
  A.ITEM_NO         AS SKUID,
  A.AMOUNT          AS quality,
  A.DELIVERY_DATE   AS planDepartTime,
  A.cellName        AS stockPosition1,
  A.SORT_CODE       AS stockPosition2,
  'Problem'         AS workFlowStatus,
  A.PPNAME          AS ppName,
  A.PICKINGORDER_NO AS batchNo

FROM
  (SELECT DISTINCT
     CS.ID,
     CS.SHIPMENT_NO,
     CO.ORDER_NO,
     BT.NAME,
     ITD.SKU_NO,
     ITD.ITEM_NO,
     CSP.AMOUNT,
     CS.DELIVERY_DATE,
     CS.SORT_CODE,
     B.NAME AS PPNAME,
     B.PICKINGORDER_NO,
     S.NAME AS cellName
   FROM OB_CUSTOMERSHIPMENT CS
     LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON CS.ID = CSP.SHIPMENT_ID
     LEFT JOIN INV_UNITLOAD_SHIPMENT INV ON CS.ID = INV.SHIPMENT_ID
     LEFT JOIN INV_UNITLOAD UN ON INV.UNITLOAD_ID = UN.ID
     LEFT JOIN MD_STORAGELOCATION S ON UN.STORAGELOCATION_ID = S.ID
     LEFT JOIN (SELECT DISTINCT
                  POP.CUSTOMERSHIPMENTPOSITION_ID,
                  PO.PICKINGORDER_NO,
                  PP.NAME
                FROM OB_PICKINGORDER PO
                  LEFT JOIN OB_PICKINGORDERPOSITION POP ON PO.ID = POP.PICKINGORDER_ID
                  LEFT JOIN OB_PICKINGORDER PR ON POP.PICKINGORDER_ID = PR.ID
                  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID
                WHERE PR.STATE = '700') B
       ON CSP.ID = B.CUSTOMERSHIPMENTPOSITION_ID
     LEFT JOIN OB_CUSTOMERORDER CO ON CS.ORDER_ID = CO.ID
     LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
     LEFT JOIN MD_ITEMDATA ITD ON CSP.ITEMDATA_ID = ITD.ID
     LEFT JOIN OB_REBINREQUESTPOSITION RBP ON CSP.ID = RBP.CUSTOMERSHIPMENTPOSITION_ID
     LEFT JOIN OB_REBINWALL RW ON RBP.REBINWALL_ID = RW.ID
     LEFT JOIN OBP_OBPCELL ce ON RW.ID = ce.WALL_ID
   WHERE CS.DELIVERY_DATE = :exsdTime
         AND CS.STATE = '1100') A;

# 10.sorted
SELECT
  A.SHIPMENT_NO     AS shipmentID,
  A.ORDER_NO        AS orderID,
  A.NAME            AS boxType,
  A.SKU_NO          AS SKUNO,
  A.ITEM_NO         AS SKUID,
  A.AMOUNT          AS quality,
  A.DELIVERY_DATE   AS planDepartTime,
  A.cell            AS stockPosition1,
  A.SORT_CODE       AS stockPosition2,
  'Sorted'          AS workFlowStatus,
  A.PPNAME          AS ppName,
  A.PICKINGORDER_NO AS batchNo
FROM (SELECT
        CSP.ID,
        CS.SHIPMENT_NO,
        CO.ORDER_NO,
        BT.`NAME`,
        ITD.SKU_NO,
        ITD.ITEM_NO,
        CSP.AMOUNT,
        CS.DELIVERY_DATE,
        CS.SORT_CODE,
        B.NAME AS PPNAME,
        B.PICKINGORDER_NO,
        S.NAME AS cell
      FROM OB_CUSTOMERSHIPMENT CS
        LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON CS.ID = CSP.SHIPMENT_ID
        LEFT JOIN INV_UNITLOAD_SHIPMENT INV ON CS.ID = INV.SHIPMENT_ID
        LEFT JOIN INV_UNITLOAD UN ON INV.UNITLOAD_ID = UN.ID
        LEFT JOIN MD_STORAGELOCATION S ON UN.STORAGELOCATION_ID = S.ID
        LEFT JOIN (SELECT DISTINCT
                     POP.CUSTOMERSHIPMENTPOSITION_ID,
                     PO.PICKINGORDER_NO,
                     PP.NAME
                   FROM OB_PICKINGORDER PO
                     LEFT JOIN OB_PICKINGORDERPOSITION POP ON PO.ID = POP.PICKINGORDER_ID
                     LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID) B
          ON CSP.ID = B.CUSTOMERSHIPMENTPOSITION_ID
        LEFT JOIN OB_CUSTOMERORDER CO ON CS.ORDER_ID = CO.ID
        LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
        LEFT JOIN MD_ITEMDATA ITD ON CSP.ITEMDATA_ID = ITD.ID
      WHERE
        CS.DELIVERY_DATE = :exsdTime
        AND CS.STATE = '660') A;

# 11.loaded
SELECT
  CS.SHIPMENT_NO    AS shipmentID,
  CO.ORDER_NO       AS orderID,
  BT.`NAME`         AS boxType,
  ITD.SKU_NO        AS SKUNO,
  ITD.ITEM_NO       AS SKUID,
  CSP.AMOUNT        AS quality,
  CS.DELIVERY_DATE  AS planDepartTime,
  S.NAME            AS stockPosition1,
  CS.SORT_CODE      AS stockPosition2,
  'Loaded'          AS workFlowStatus,
  B.NAME            AS ppName,
  B.PICKINGORDER_NO AS batchNo
FROM OB_CUSTOMERSHIPMENT CS
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON CS.ID = CSP.SHIPMENT_ID
  LEFT JOIN INV_UNITLOAD_SHIPMENT INV ON CS.ID = INV.SHIPMENT_ID
  LEFT JOIN INV_UNITLOAD UN ON INV.UNITLOAD_ID = UN.ID
  LEFT JOIN MD_STORAGELOCATION S ON UN.STORAGELOCATION_ID = S.ID
  LEFT JOIN (SELECT DISTINCT
               POP.CUSTOMERSHIPMENTPOSITION_ID,
               PO.PICKINGORDER_NO,
               PP.NAME
             FROM OB_PICKINGORDER PO
               LEFT JOIN OB_PICKINGORDERPOSITION POP ON PO.ID = POP.PICKINGORDER_ID
               LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID) B
    ON CSP.ID = B.CUSTOMERSHIPMENTPOSITION_ID
  LEFT JOIN OB_CUSTOMERORDER CO ON CS.ORDER_ID = CO.ID
  LEFT JOIN OB_BOXTYPE BT ON CS.BOXTYPE_ID = BT.ID
  LEFT JOIN MD_ITEMDATA ITD ON CSP.ITEMDATA_ID = ITD.ID
WHERE
  CS.DELIVERY_DATE = :exsdTime
  AND CS.STATE = '670';









