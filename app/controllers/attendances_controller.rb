class AttendancesController < ApplicationController
  include AttendancesHelper
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  #before_action :set_user_attendance,only: [:edit_zangyo_info]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month]#, :edit_zangyo_info]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
         @attendance.update_attributes(first_start_time: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
         @attendance.update_attributes(first_end_time: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
   ActiveRecord::Base.transaction do # トランザクションを開始します。
    if attendances_invalid? 
     attendances_params.each do |id, item|
      attendance = Attendance.find(id)
      if !item[:change_superior_id].blank?
      attendance.update_attributes!(item)
      end
     end
      flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date])
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
    end
   end
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
   flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
   redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def edit_zangyo_info
    @attendance = Attendance.find(params[:id])
  end
  
  def update_zangyo_info
    @attendance = Attendance.find(params[:id])
    #@attendance.update_columns(params[:end_plan])
    @user = User.find(@attendance.user_id)
    @attendance.update_attributes(attendances_params_z)
    flash[:info] = "残業申請を送信しました"
    redirect_to @user
  end
  
  def approval_zangyo_info
    #@attendances = Attendance.find(params[:id])
    @attendances = Attendance.where(superior_id: params[:name]).where(:status => 2..3 ).order(:user_id)
    #@user = User.find_by
  end
  
  def update_approval_zangyo_info
    #@attendance = Attendance.find(params[:id])
     ActiveRecord::Base.transaction do # トランザクションを開始します。
       attendances_params_zz.each do |id, item|
        attendance = Attendance.find(id)
        if item[:check] == "1"
         attendance.update_attributes!(item)
        end
       end
      #@attendance.update_attributes(attendances_params_z)
      #@attendance = Attendance.find(params[:id])
      @user = User.find(current_user.id)
      flash[:info] = "残業申請を更新しました"
      redirect_to @user
     end
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to @user
  end
  
   private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :second_start_time, :change_superior_id, :change_status])[:attendances]
    end
    
    def attendances_params_z
      params.require(:attendance).permit(:end_plan, :superior_id, :gyoumu, :next_day_flag, :status)
    end
    
    def attendances_params_zz
      params.require(:attendance).permit(attendances: [:end_plan, :superior_id, :gyoumu, :next_day_flag, :status, :check])[:attendances]
    end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
       flash[:danger] = "編集権限がありません。"
       redirect_to(root_url)
      end
    end
end
