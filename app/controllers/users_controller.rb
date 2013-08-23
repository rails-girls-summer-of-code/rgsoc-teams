class UsersController < ApplicationController
  before_filter :normalize_params, only: :index
  before_filter :set_user, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:index, :show]

  def index
    @users = User.ordered(params[:sort]).with_assigned_roles.group('users.id')
    @users = @users.with_role(params[:role]) if params[:role].present? && params[:role] != 'all'
  end

  def show
  end

  def new
    @user.attendances.build
  end

  def edit
    @user.attendances.build unless @user.attendances.any?
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: :show, status: :created, location: @user }
      else
        format.html { render action: :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


  private

    def set_user
      @user = User.find(params[:id])
    end

    def conferences
      @conferences ||= Conference.order(:name)
    end
    helper_method :conferences

    def user_params
      params.require(:user).permit(
        :github_handle, :twitter_handle, :irc_handle,
        :name, :email, :homepage, :location, :bio,
        :tshirt_size, :banking_info, :postal_address, :timezone,
        attendances_attributes: [:id, :conference_id, :_destroy]
      )
    end

    def normalize_params
      params[:role] = 'all' if params[:role].blank?
    end
end
