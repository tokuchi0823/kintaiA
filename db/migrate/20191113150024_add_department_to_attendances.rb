class AddDepartmentToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :first_start_time, :datetime
    add_column :attendances, :first_end_time, :datetime
    add_column :attendances, :second_start_time, :datetime
    add_column :attendances, :second_end_time, :datetime
    add_column :attendances, :change_status, :integer, default: 0
    add_column :attendances, :change_superior_id, :string
  end
end
