-- Función para generar SKU
CREATE OR REPLACE FUNCTION generate_sku() 
RETURNS TRIGGER AS $$
BEGIN
    -- Toma las primeras 4 letras del nombre del producto (convertidas a mayúsculas)
    -- y agrega un número secuencial de 4 dígitos
    NEW.sku := CONCAT(
        UPPER(SUBSTRING(REGEXP_REPLACE(NEW.name, '[^a-zA-Z]', '', 'g') FROM 1 FOR 4)),
        '-',
        LPAD(CAST(nextval('products_id_seq') AS TEXT), 4, '0')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Función actualizada para generar Order Number y manejar fecha estimada
CREATE OR REPLACE FUNCTION generate_order_number() 
RETURNS TRIGGER AS $$
BEGIN
    -- Genera el order_number
    NEW.order_number := CONCAT(
        EXTRACT(YEAR FROM CURRENT_DATE),
        '-',
        LPAD(CAST(nextval('orders_id_seq') AS TEXT), 6, '0')
    );
    
    -- Establece la fecha estimada solo si es Delivery
    IF NEW.delivery_channel = 'Delivery' THEN
        NEW.estimated_delivery_date := CURRENT_TIMESTAMP + INTERVAL '2 days';
    ELSE
        NEW.estimated_delivery_date := NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;