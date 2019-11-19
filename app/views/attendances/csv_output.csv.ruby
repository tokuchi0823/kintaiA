require 'csv'
require 'date'

CSV.generate do |csv|
  csv_column_names = %w(日付 出社 退社)
  csv << csv_column_names
  @attendances.each do |attendance|
    csv_column_values = [
      attendance.worked_on,
      if attendance.started_at.present?
       attendance.started_at.strftime("%R")
      end,
      if attendance.finished_at.present?
       attendance.finished_at.strftime("%R")
      end,
    ]
    csv << csv_column_values
  end
end