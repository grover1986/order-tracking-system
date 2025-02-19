-- Trigger para SKU automático
DROP TRIGGER IF EXISTS set_sku ON products;
CREATE TRIGGER set_sku
    BEFORE INSERT ON products
    FOR EACH ROW
    EXECUTE FUNCTION generate_sku();


-- Trigger para Order Number automático
DROP TRIGGER IF EXISTS set_order_number ON orders;
CREATE TRIGGER set_order_number
    BEFORE INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION generate_order_number();