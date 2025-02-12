-- Crear base de datos
CREATE DATABASE order_tracking_sytem;

-- Conectar a la base de datos
\c order_tracking_sytem;

-- Crear enum para el canal de entrega
CREATE TYPE delivery_channel AS ENUM ('Delivery', 'PickupInPoint');

-- Crear enum para estados de Delivery
CREATE TYPE delivery_status AS ENUM (
    'registrado',
    'confirmado',
    'en_camino',
    'entregado',
    'cancelado'
);

-- Crear enum para estados de PickupInPoint
CREATE TYPE pickup_status AS ENUM (
    'registrado',
    'confirmado',
    'listo_para_recoger',
    'entregado',
    'cancelado'
);

-- Tabla de grupos de pedidos
CREATE TABLE order_groups (
    id SERIAL PRIMARY KEY,
    group_number VARCHAR(16) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de vendedores
CREATE TABLE sellers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de destinatarios
CREATE TABLE recipients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de productos
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    seller_id INTEGER REFERENCES sellers(id),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    sku VARCHAR(50) UNIQUE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de pedidos
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    group_id INTEGER REFERENCES order_groups(id),
    seller_id INTEGER REFERENCES sellers(id),
    recipient_id INTEGER REFERENCES recipients(id),
    delivery_channel delivery_channel NOT NULL,
    current_status VARCHAR(20) NOT NULL,
    estimated_delivery_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de estados de pedidos
CREATE TABLE order_status_history (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    status VARCHAR(20) NOT NULL,
    status_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de detalles de pedidos (productos en cada pedido)
CREATE TABLE order_details (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_orders_group_id ON orders(group_id);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_order_status_history_order_id ON order_status_history(order_id);
CREATE INDEX idx_order_details_order_id ON order_details(order_id);

-- Función para actualizar el estado de un pedido
CREATE OR REPLACE FUNCTION update_order_status(
    p_order_id INTEGER,
    p_new_status VARCHAR(20)
) RETURNS VOID AS $$
BEGIN
    -- Desactivar el estado actual
    UPDATE order_status_history
    SET is_active = false
    WHERE order_id = p_order_id AND is_active = true;
    
    -- Insertar el nuevo estado
    INSERT INTO order_status_history (order_id, status)
    VALUES (p_order_id, p_new_status);
    
    -- Actualizar el estado actual en la tabla de pedidos
    UPDATE orders
    SET current_status = p_new_status
    WHERE id = p_order_id;
END;
$$ LANGUAGE plpgsql;

-- Función para consultar pedidos por número de grupo
CREATE OR REPLACE FUNCTION get_orders_by_group(
    p_group_number VARCHAR(16)
) RETURNS TABLE (
    order_number VARCHAR(20),
    delivery_channel delivery_channel,
    current_status VARCHAR(20),
    estimated_delivery_date TIMESTAMP,
    recipient_name VARCHAR(100),
    seller_name VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.order_number,
        o.delivery_channel,
        o.current_status,
        o.estimated_delivery_date,
        r.name as recipient_name,
        s.name as seller_name
    FROM orders o
    JOIN order_groups og ON o.group_id = og.id
    JOIN recipients r ON o.recipient_id = r.id
    JOIN sellers s ON o.seller_id = s.id
    WHERE og.group_number = p_group_number;
END;
$$ LANGUAGE plpgsql;