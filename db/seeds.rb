# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

email = 'admin@cxc.com'
pass = '2019AdminCxC'

user = User.find_by(email: email)
if user == nil
  user = User.new
  user.nombre = "CXC"
  user.apellido = "Administrador"
  user.email = email
  user.password = pass
  user.password_confirmation = pass
  user.role = "SuperAdmin"
  user.estado = true
  user.save!
end

TRol.create(direccion_url: nil, li_class: nil, i_class: nil, u_class: nil, nombre: "SuperAdmin", descripcion:"Rol de usuario con acceso a todos los módulos del sistema", peso:1, estatus: 1, icon_class:nil)
TRol.create(direccion_url: nil, li_class: nil, i_class: nil, u_class: nil, nombre: "AdminCxC", descripcion:"Rol de usuario con acceso a todos los módulos del sistema. No gestiona usuarios", peso:1, estatus: 1, icon_class:nil)
#Ejecutar SQL
#INSERT INTO t_users_rols VALUES (1,1);
