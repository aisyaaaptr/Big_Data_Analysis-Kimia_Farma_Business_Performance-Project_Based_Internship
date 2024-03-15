CREATE TABLE dataset_kimia_farma_rakamin.kf_analisis1 AS
SELECT
x.transaction_id,
x.date, 
x.branch_id, 
x.branch_name, 
x.kota, x.provinsi, 
x.rating_cabang, 
x.customer_name, 
x.product_id, 
x.product_name, 
x.actual_price, 
x.discount_percentage,
x.persentase_gross_laba,
x.nett_sales,
(x.persentase_gross_laba-(x.actual_price-x.nett_sales)) nett_profit, 
x.rating_transaksi
FROM ( 
  SELECT
    ft.transaction_id,
    ft.date,
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating as rating_cabang,
    ft.customer_name,
    ft.product_id,
    pd.product_name,
    ft.price as actual_price,
    ft.discount_percentage,
      CASE
        WHEN pd.price <= 50000 THEN 0.1
        WHEN pd.price > 50000  AND pd.price <=100000 THEN 0.15
        WHEN pd.price > 10000 AND pd.price<= 300000 THEN 0.20
        WHEN pd.price > 300000 AND pd.price<= 500000 THEN 0.25
        WHEN pd.price > 500000 then 0.30
     END AS persentase_gross_laba,
        (pd.price-(pd.price*ft.discount_percentage))nett_sales,
    ft.rating as rating_transaksi
  FROM
    dataset_kimia_farma_rakamin.kf_final_transaction as ft
  LEFT JOIN
     dataset_kimia_farma_rakamin.kf_kantor_cabang as kc ON ft.branch_id = kc.branch_id
  LEFT JOIN
    dataset_kimia_farma_rakamin.kf_product as pd ON ft.product_id = pd.product_id
     ) x
