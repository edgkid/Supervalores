require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
# scheduler = Rufus::Scheduler.singleton

# TConfFacAutomatica.all.each do |configuracion|
#   scheduler.in (configuracion.fecha_inicio - Date.today).to_i.to_s + 's' do
#     puts (configuracion.fecha_inicio - Date.today).to_i
#     scheduler.every '2s' do
#       puts configuracion.nombre_ciclo_facturacion
#     end
#   end
# end
