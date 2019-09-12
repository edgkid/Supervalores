puts 'Semillas de Módulos'

app_modules = TModulo::MODULOS
app_modules.each do |app_module|
  TModulo.find_or_create_by!(nombre: app_module)
end

puts 'Fin de Módulos'
