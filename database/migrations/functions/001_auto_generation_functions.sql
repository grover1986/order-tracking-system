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


-- Función para generar Order Number
CREATE OR REPLACE FUNCTION generate_order_number() 
RETURNS TRIGGER AS $$
BEGIN
    -- Genera un número de orden con formato: YYYY-XXXXXX
    -- donde YYYY es el año actual y XXXXXX es un número secuencial
    NEW.order_number := CONCAT(
        EXTRACT(YEAR FROM CURRENT_DATE),
        '-',
        LPAD(CAST(nextval('orders_id_seq') AS TEXT), 6, '0')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;