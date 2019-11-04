class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_zangyo_info, :update_zangyo_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy,:edit_zangyo_info, :update_zangyo_info]
  #before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info, :index, :edit, :update]
  before_action :set_one_month, only: :show 
  before_action :admin_correct_user, only: :show
 
  def index
    @users = User.paginate(page: params[:page], per_page: 20).search(params[:search])
    if params[:name].present?
      @users = @users.get_by_name params[:name]
    end
  end
   
  def new
    @user = User.new
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
   if @user.update_attributes(user_params)
    flash[:success] = "ユーザー情報を更新しました。"
    redirect_to users_url
   else
    render :edit
   end
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
   if @user.update_attributes(basic_info_params)
    flash[:success] = "基本情報を更新しました。"
    redirect_to @user   
   else
    render 'edit_basic_info'
   end
  end
  
  def on_duty
   @users = User.all.includes(:attendances)
  end
 
  def insert
    registered_count = insert_users
    flash[:success] = "#{registered_count}件登録しました"
    redirect_to users_path
  end
  

  
   private
  
   def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation, :employee_number, :uid, :designated_work_start_time, :designated_work_end_time, :basic_time,)
   end
   
   def basic_info_params
    params.require(:user).permit(:basic_time, :work_time)
   end
   
    def insert_users
      # 登録処理前のレコード数
      current_user_count = ::User.count
      users = []
      # windowsで作られたファイルに対応するので、encoding: "SJIS"を付けている
      CSV.foreach(params[:users_file].path, headers: true, encoding: "SJIS") do |row|
        users << ::User.new({ name: row["name"], email: row["email"], department: row["affiliation"], employee_number: row["employee_number"], uid: row["uid"], basic_time: row["basic_work_time"], designated_work_start_time: row["designated_work_start_time"], designated_work_end_time: row["designated_work_end_time"], superior: row["superior"], admin: row["admin"], password: row["password"]})
      end
      # importメソッドでバルクインサートできる
      ::User.import(users)
      # 何レコード登録できたかを返す
      ::User.count - current_user_count
    end
   
end