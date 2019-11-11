class InformeDeIngresosPresupuestoView < ApplicationRecord
  self.table_name = 'informe_de_ingresos_presupuesto_view'

  protected
    def readonly?
      true
    end
end
