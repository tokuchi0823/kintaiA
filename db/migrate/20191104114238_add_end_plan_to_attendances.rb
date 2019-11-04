class AddEndPlanToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :end_plan, :datetime
  end
end
