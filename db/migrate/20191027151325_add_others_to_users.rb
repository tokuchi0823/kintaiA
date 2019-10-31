class AddOthersToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :string, unique: true
    add_column :users, :uid, :string, unique: true
    add_column :users, :designated_work_start_time, :datetime, default: Time.current.change(hour: 9, min: 0, sec: 0)
    add_column :users, :designated_work_end_time, :datetime, default: Time.current.change(hour: 18, min: 0, sec: 0)
    add_column :users, :superior, :boolean, default: false
  end
end
