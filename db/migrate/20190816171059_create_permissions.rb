class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :role
      t.string :subject_class
      t.string :action

      t.timestamps

      t.belongs_to :user, foreign_key: true, null: false
    end
  end
end
