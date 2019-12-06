# == Schema Information
#
# Table name: view_client
#
#  id             :bigint
#  codigo         :string
#  created_at     :datetime
#  updated_at     :datetime
#  identificacion :string
#  razon_social   :string
#  telefono       :string
#  email          :string
#  es_prospecto   :text
#  estatus        :string
#  tipo_persona   :string
#

class ViewClient < ApplicationRecord
  self.table_name = 'view_client'
  
  protected

  # The report_state_popularities relation is a SQL view,
  # so there is no need to try to edit its records ever.
  # Doing otherwise, will result in an exception being thrown
  # by the database connection.
  def readonly?
    true
  end

end
