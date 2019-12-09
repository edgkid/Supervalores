class ViewResolution < ActiveRecord::Migration[5.2]
  def up
    self.connection.execute %Q( CREATE OR REPLACE VIEW view_resolution AS
      SELECT 
        cli.id t_cliente_id
      , res.id t_resolucion_id
      , cli.razon_social as cliente_razon_social
			, cli.codigo as cliente_codigo
			, cli.identificacion as cliente_identificacion
			, res.resolucion
			, res.descripcion as resolucion_descripcion
			, res.created_at as resolucion_created_at
			, res.updated_at as resolucion_updated_at
			, est.id as t_estatus_id
			, est.descripcion as estatus_descripcion
      FROM t_resolucions res
      JOIN view_client cli ON res.t_cliente_id = cli.id 
			JOIN t_estatuses est ON res.t_estatus_id = est.id   
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS view_client;"
  end
end
