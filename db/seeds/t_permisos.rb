puts 'Semillas de Permisos CRUD'

permissions = TPermiso::PERMISOS
permissions.each do |permission|
  TPermiso.find_or_create_by!(nombre: permission)
end

puts 'Fin de Permisos'


puts 'Semillas de Permisos Personalizados'

special_permissions = TPermiso::PERMISOS_ESPECIALES
special_permissions.each do |permission|
  TPermiso.find_or_create_by!(nombre: permission)
end

puts 'Fin de Permisos Personalizados'