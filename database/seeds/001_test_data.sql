-- Insertar vendedores de prueba
INSERT INTO sellers (name, email, phone, address) VALUES
    ('Tienda Tech', 'tech@example.com', '999888777', 'Av. Tecnología 123'),
    ('Moda Express', 'moda@example.com', '999777666', 'Jr. Moda 456');

-- Insertar productos de prueba
INSERT INTO products (seller_id, name, description, sku, price, stock, image_url) VALUES
    (1, 'Apple iPhone 13 (128 GB) - Azul', 'iPhone 13. El sistema de dos cámaras más avanzado en un iPhone. El superrápido chip A15 Bionic. Un gran
salto en duración de batería. Un diseño resistente. Y una pantalla Super Retina XDR más brillante.', 'TECH-001', 1427.99, 10, 'http://http2.mlstatic.com/D_656548-MLA46114829749_052021-O.jpg'),
    (2, 'Chomba 100% Algodón Pique Hombre Importada', 'La chomba 100% algodón pique para hombre de la marca Audaz es la elección perfecta para quienes buscan comodidad y estilo en su vestimenta diaria. Confeccionada en un tejido de piqué suave y transpirable, esta prenda se adapta a diversas ocasiones, desde un día casual en la oficina hasta un encuentro con amigos.', 'TECH-002', 13.99, 15, 'http://http2.mlstatic.com/D_972199-MLA79414405033_092024-O.jpg');

-- Insertar destinatarios de prueba
INSERT INTO recipients (name, email, phone, address) VALUES
    ('Juan Pérez', 'juan@gmail.com', '987654321', 'Av. Principal 123'),
	 
    ('María García', 'maria@gmail.com', '987654322', 'Jr. Secundario 456');

-- Insertar grupos de pedidos
INSERT INTO order_groups (group_number) VALUES
    ('1234567890123456'),
    ('2234567890123456');

-- Insertar pedidos de prueba
INSERT INTO orders (
    order_number, 
    group_id, 
    seller_id, 
    recipient_id, 
    delivery_channel, 
    current_status, 
    estimated_delivery_date
) VALUES
    ('2024-0001', 1, 1, 1, 'Delivery', 'registrado', CURRENT_TIMESTAMP + INTERVAL '2 days'),
    ('2024-0002', 1, 2, 2, 'PickupInPoint', 'confirmado', CURRENT_TIMESTAMP + INTERVAL '1 day');

-- Insertar detalles de pedidos
INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 1427.99),
    (2, 2, 1, 13.99);

-- Insertar estados iniciales de los pedidos
INSERT INTO order_status_history (order_id, status, is_active) VALUES
    (1, 'registrado', true),
    (2, 'confirmado', true);