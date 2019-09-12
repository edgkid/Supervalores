puts 'Semillas de Permisos'

permissions = TPermiso::PERMISOS
permissions.each do |permission|
  TPermiso.find_or_create_by!(nombre: permission)
end

puts 'Fin de Permisos'
