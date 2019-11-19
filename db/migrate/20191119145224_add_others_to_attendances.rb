class AddOthersToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :one_month_superior_id, :string
    add_column :attendances, :one_month_status, :integer
  end
end
