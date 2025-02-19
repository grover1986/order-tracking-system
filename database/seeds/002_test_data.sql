-- Probar trigger de SKU
INSERT INTO products (seller_id, name, description, price, stock, image_url) 
VALUES (1, 'Licuadora Profesional Jugo Fruta 2 L 1600w Daewo Color Negro', 'Disfruta de deliciosos jugos y batidos con la Licuadora Profesional Daewoo DIBL-210E. Con su potente motor de 1600W, esta licuadora te permite preparar tus bebidas favoritas de manera rápida y eficiente.', 146, 15, 'http://http2.mlstatic.com/D_617016-MLA74180198285_012024-O.jpg');

-- Ver el SKU generado
SELECT sku, name FROM products ORDER BY id DESC LIMIT 1;

-- Probar trigger de order_number
INSERT INTO orders (group_id, seller_id, recipient_id, delivery_channel, current_status) 
VALUES (1, 1, 1, 'Delivery', 'registrado');

-- Verificar
SELECT order_number, delivery_channel, estimated_delivery_date 
FROM orders 
ORDER BY id DESC LIMIT 1;