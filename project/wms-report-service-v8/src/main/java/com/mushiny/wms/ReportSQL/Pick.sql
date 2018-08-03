# total 拣货总数量，已拣数量，未拣数量
SELECT
  sum(POR.AMOUNT)                     AS total,
  sum(POR.AMOUNT_PICKED)              AS picked,
  sum(POR.AMOUNT - POR.AMOUNT_PICKED) AS notPicked
FROM OB_PICKINGORDERPOSITION POR;

# 各 发货时间，拣货总数量，已拣数量，未拣数量
SELECT
  CS.DELIVERY_DATE                                                   AS deliveryDate,
  coalesce(sum(POR.AMOUNT), 0)                                       AS total,
  coalesce(sum(POR.AMOUNT_PICKED), 0)                                AS picked,
  coalesce(sum(POR.AMOUNT), 0) - coalesce(sum(POR.AMOUNT_PICKED), 0) AS notPicked
# coalesce(sum(POR.AMOUNT - POR.AMOUNT_PICKED), 0) AS notPicked
FROM OB_PICKINGORDERPOSITION POR
  #   订单发货时间
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POR.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
WHERE CS.DELIVERY_DATE IS NOT NULL
      AND CS.DELIVERY_DATE LIKE '2017-07-14%'
GROUP BY deliveryDate
ORDER BY deliveryDate;

# 各 区域，拣货总数量，已拣数量，未拣数量
SELECT
  Z.NAME                                                             AS zoneName,
  coalesce(sum(POR.AMOUNT), 0)                                       AS total,
  coalesce(sum(POR.AMOUNT_PICKED), 0)                                AS picked,
  coalesce(sum(POR.AMOUNT), 0) - coalesce(sum(POR.AMOUNT_PICKED), 0) AS notPicked
FROM OB_PICKINGORDERPOSITION POR
  #  区域
  LEFT JOIN INV_STOCKUNIT ST ON POR.PICKFROMSTOCKUNIT_ID = ST.ID
  LEFT JOIN INV_UNITLOAD UL ON ST.UNITLOAD_ID = UL.ID
  LEFT JOIN MD_STORAGELOCATION STL ON UL.STORAGELOCATION_ID = STL.ID
  LEFT JOIN MD_ZONE Z ON STL.ZONE_ID = Z.ID
WHERE Z.NAME IS NOT NULL
GROUP BY zoneName
ORDER BY zoneName;

# 所有ppName 发货时间，区域，拣货总数量，已拣数量，未拣数量
SELECT
  PP.NAME                                                            AS ppName,
  CS.DELIVERY_DATE                                                   AS deliveryDate,
  Z.NAME                                                             AS zoneName,
  coalesce(sum(POR.AMOUNT), 0)                                       AS total,
  coalesce(sum(POR.AMOUNT_PICKED), 0)                                AS picked,
  coalesce(sum(POR.AMOUNT), 0) - coalesce(sum(POR.AMOUNT_PICKED), 0) AS notPicked

FROM OB_PICKINGORDERPOSITION POR
  #   PpName
  LEFT JOIN OB_PICKINGORDER PO ON POR.PICKINGORDER_ID = PO.ID
  LEFT JOIN OB_PROCESSPATH PP ON PO.PROCESSPATH_ID = PP.ID

  #   订单发货时间
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POR.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID

  #  区域
  LEFT JOIN INV_STOCKUNIT ST ON POR.PICKFROMSTOCKUNIT_ID = ST.ID
  LEFT JOIN INV_UNITLOAD UL ON ST.UNITLOAD_ID = UL.ID
  LEFT JOIN MD_STORAGELOCATION STL ON UL.STORAGELOCATION_ID = STL.ID
  LEFT JOIN MD_ZONE Z ON STL.ZONE_ID = Z.ID
WHERE
  CS.DELIVERY_DATE IS NOT NULL
  AND Z.NAME IS NOT NULL
#   PP.NAME = ''
#   AND Z.NAME = '11-A'
#   AND CS.DELIVERY_DATE = '2017-07-14 12:00:00'
GROUP BY ppName, deliveryDate, zoneName;

# 各 发货时间，拣货总数量，已拣数量，未拣数量
SELECT
  Z.NAME,
  #   CS.DELIVERY_DATE                                                   AS deliveryDate,
  coalesce(sum(POR.AMOUNT), 0)                                       AS total,
  coalesce(sum(POR.AMOUNT_PICKED), 0)                                AS picked,
  coalesce(sum(POR.AMOUNT), 0) - coalesce(sum(POR.AMOUNT_PICKED), 0) AS notPicked
FROM OB_PICKINGORDERPOSITION POR
  #   订单发货时间
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POR.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
  #  区域
  LEFT JOIN INV_STOCKUNIT ST ON POR.PICKFROMSTOCKUNIT_ID = ST.ID
  LEFT JOIN INV_UNITLOAD UL ON ST.UNITLOAD_ID = UL.ID
  LEFT JOIN MD_STORAGELOCATION STL ON UL.STORAGELOCATION_ID = STL.ID
  LEFT JOIN MD_ZONE Z ON STL.ZONE_ID = Z.ID
WHERE CS.DELIVERY_DATE IS NOT NULL
      AND Z.NAME IS NOT NULL
      AND CS.STATE != 600
      AND CS.DELIVERY_DATE LIKE '2017-08-12 12:00:00'
GROUP BY Z.NAME;
# ORDER BY deliveryDate;


SELECT
  CS.DELIVERY_DATE,
  CSP.AMOUNT,
  I.NAME
FROM OB_CUSTOMERSHIPMENTPOSITION CSP
  LEFT JOIN MD_ITEMDATA I ON CSP.ITEMDATA_ID = I.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
WHERE CS.CUSTOMER_NO IN ('071010');

# where CS.DELIVERY_DATE ='2017-07-05 15:00:00';


SELECT
  POR.STATE,
  CSP.STATE,
  CS.STATE
FROM OB_PICKINGORDERPOSITION POR
  #   订单发货时间
  LEFT JOIN OB_CUSTOMERSHIPMENTPOSITION CSP ON POR.CUSTOMERSHIPMENTPOSITION_ID = CSP.ID
  LEFT JOIN OB_CUSTOMERSHIPMENT CS ON CSP.SHIPMENT_ID = CS.ID
WHERE
  CS.DELIVERY_DATE LIKE '2017-08-12 12:00:00';



