class AjustePersonas < ActiveRecord::Migration[5.2]
  def change    
    remove_column :t_personas, :created_at
    remove_column :t_personas, :updated_at
  end
end
