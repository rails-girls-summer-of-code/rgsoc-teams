class UsersController < ApplicationController
  before_action :normalize_params, only: :index
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource except: [:index, :show]

  def index
    @filters = {
      all:        'All',
      pair:       'Looking for a pair',
      coaching:   'Helping as a Coach',
      mentoring:  'Helping as a Mentor',
      organizing: 'Helping as an Organizer'
    }
    @users = User.ordered(params[:sort],params[:direction])
        .group('users.id').with_all_associations_joined
    @users = @users.with_assigned_roles if Time.now.utc > (current_season.starts_at || Date.new)
    @users = @users.with_role(params[:role]) if params[:role].present? && params[:role] != 'all'
    @users = @users.with_interest(params[:interest]) if params[:interest].present? && params[:interest] != 'all'
    @users = Kaminari.paginate_array(@users.search(params[:search])).page(params[:page])
  end

  def show
  end

  def new
    @user.attendances.build
  end

  def edit
    if current_user.admin?
      @user.attendances.build unless @user.attendances.any?
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to params[:redirect_to] || @user, notice: 'User was successfully created.' }
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
        format.html { redirect_to params[:redirect_to] || @user, notice: 'User was successfully updated.' }
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
      @conferences ||= Conference.in_current_season.order(:name)
    end
    helper_method :conferences

    def teams
      all_teams = Team.all.order(:name)
      selected_teams = Team.in_current_season.selected.order(:name)
      current_season.active? ? selected_teams : all_teams
    end
    helper_method :teams

    def user_params
      params.require(:user).permit(
        :github_handle, :twitter_handle, :irc_handle,
        :name, :email, :homepage, :location, :bio,
        :tshirt_size, :postal_address, :timezone,
        :country,
        :hide_email,
        :is_company, :company_name, :company_info,
        :application_about, :application_motivation, :application_gender_identification, :application_age,
        :application_coding_level, :application_community_engagement, :application_learning_period, :application_language_learning_period,
        :application_learning_history, :application_skills, :application_code_samples,
        :application_location, :application_minimum_money, :application_money, :application_goals, :application_code_background,
        interested_in: [],
        attendances_attributes: [:id, :conference_id, :_destroy],
        roles_attributes: [:id, :name, :team_id]
      )
    end

    def normalize_params
      params[:role] = 'all' if params[:role].blank?
    end
end
