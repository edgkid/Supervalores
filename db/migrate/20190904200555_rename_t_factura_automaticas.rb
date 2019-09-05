class RenameTFacturaAutomaticas < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :t_factura_automaticas, :t_conf_fac_automaticas

    change_table :t_factura_recargos do |t|
      t.rename :t_factura_automatica_id, :t_conf_fac_automatica_id
    end

    change_table :t_factura_servicios do |t|
      t.rename :t_factura_automatica_id, :t_conf_fac_automatica_id
    end

    change_table :t_factura_tarifas do |t|
      t.rename :t_factura_automatica_id, :t_conf_fac_automatica_id
    end
  end

  def self.down
    rename_table :t_conf_fac_automaticas, :t_factura_automaticas

    change_table :t_factura_recargos do |t|
      t.rename :t_conf_fac_automatica_id, :t_factura_automatica_id
    end

    change_table :t_factura_servicios do |t|
      t.rename :t_conf_fac_automatica_id, :t_factura_automatica_id
    end

    change_table :t_factura_tarifas do |t|
      t.rename :t_conf_fac_automatica_id, :t_factura_automatica_id
    end
  end
end
