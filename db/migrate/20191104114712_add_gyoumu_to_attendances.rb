class AddGyoumuToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :gyoumu, :string
  end
end
