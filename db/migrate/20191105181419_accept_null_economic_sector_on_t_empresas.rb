class AcceptNullEconomicSectorOnTEmpresas < ActiveRecord::Migration[5.2]
  def change
    change_column_null :t_empresas, :t_empresa_sector_economico_id, true
  end
end
