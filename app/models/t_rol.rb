# == Schema Information
#
# Table name: t_rols
#
#  id          :bigint           not null, primary key
#  nombre      :string
#  descripcion :text
#  estatus     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TRol < ApplicationRecord
  has_many :t_rol_usuarios, dependent: :destroy
  has_many :users, through: :t_rol_usuarios
  has_many :t_modulo_rols, dependent: :destroy
  has_many :t_modulos, through: :t_modulo_rols
  accepts_nested_attributes_for :t_modulo_rols
end
