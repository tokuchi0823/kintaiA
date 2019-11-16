module AttendancesHelper
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
  
  
   def attendances_change_superior?
    attendances = true
    attendances_params.each do |id, item|
      if item[:change_superior_id].blank? 
        attendances = false
        break
      end
    end
    return attendances
  end
  
  
end
