json.extract! t_nota_credito, :id, :t_cliente_id, :t_recibo_id, :monto, :usada, :factura_redimida, :descripcion, :created_at, :updated_at
json.url t_nota_credito_url(t_nota_credito, format: :json)
