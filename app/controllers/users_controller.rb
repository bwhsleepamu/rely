class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_system_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    unless current_user.system_admin? or params[:format] == 'json'
      redirect_to root_path, alert: "You do not have sufficient privileges to access that page."
      return
    end

    user_scope = User.current
    @search_terms = (params[:search] || params[:q]).to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| user_scope = user_scope.search(search_term) }

    @order = User.column_names.collect{|column_name| "users.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "users.current_sign_in_at DESC"
    user_scope = user_scope.order(@order)

    @users = user_scope.page(params[:page]).per( 20 )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: params[:q].to_s.split(',').collect{|u| (u.strip.downcase == 'me') ? {name: current_user.name, id: current_user.name} : {name: u.strip.titleize, id: u.strip.titleize}} + @users.collect{|u| {name: u.name, id: u.name}}}
    end

  end

  def show
    @user = User.current.find_by_id(params[:id])
    redirect_to users_path unless @user
  end

  #def new
  #  @user = User.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @user }
  #  end
  #end

  def edit
    @user = User.current.find_by_id(params[:id])
    redirect_to users_path unless @user
  end

  # # This is in registrations_controller.rb
  # def create
  # end


  def update
    @user = User.current.find_by_id(params[:id])
    system_admin = params[:user][:system_admin]
    status = params[:user][:status]
    
    #params[:user].except!(:system_admin, :status)
    if @user and @user.update_attributes(user_params)
      @user.update_attribute :system_admin, system_admin unless system_admin.blank?
      @user.update_attribute :status, status unless status.blank?
      redirect_to @user, notice: 'User was successfully updated.'
    elsif @user
      render action: "edit"
    else
      redirect_to users_path
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy if @user
    redirect_to users_path
  end

  private


  def user_params
    params[:user] ||= {}

    params.require(:user).permit(:first_name, :last_name, :email)
  end

end