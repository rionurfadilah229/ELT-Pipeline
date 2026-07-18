SELECT
    ti.item_id,
    ti.transaction_date,

    -- Data Customer
    c.customer_id,
    c.name AS customer_name,
    c.email AS customer_email,
    c.city AS customer_city,

    -- Data Produk
    p.product_id,
    p.product_name,
    p.price,
    p.stock,

    -- Data Transaksi
    ti.quantity,
    (ti.quantity * p.price) AS total_price
FROM
    {{ref('transaction_items')}} ti
JOIN
    {{ref('customers')}} c ON ti.customer_id = c.customer_id
JOIN
    {{ref('products')}} p ON ti.product_id = p.product_id
ORDER BY
    ti.transaction_date, ti.item_id