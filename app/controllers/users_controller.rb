# frozen_string_literal: true
class UsersController < ApplicationController

  load_and_authorize_resource except: [:impersonate, :stop_impersonating]

  def show
  end

  def new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to params[:redirect_to].presence || @user, notice: 'User was successfully created.' }
        format.json { render action: :show, status: :created, location: @user }
      else
        format.html { render action: :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes(user_params.merge opt_in_params)
        notice = nil
        # We disabled the confirmation instruction sending in the omniauth
        # user creation and have to do it manually here. If the user
        # decides to change the email address in the form, devise is sending
        # an email confirm message automatically. Otherwise we will sent it
        # manually here
        if !@user.confirmed? && !@user.previous_changes["unconfirmed_email"].present?
          @user.send_confirmation_instructions
        else
          notice = 'Your profile was successfully updated.'
        end
        format.html { redirect_to params[:redirect_to].presence || @user, notice: notice }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    sign_out @user
    respond_to do |format|
      format.html { redirect_to community_url }
      format.json { head :no_content }
    end
  end

  def impersonate
    set_user
    impersonate_user(@user)
    redirect_to community_path, notice: "Now impersonating #{@user.name}. You can find the link to stop impersonation on the user menu."
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to community_path, notice: "Impersonation stopped. You're back to being #{current_user.name}!"
  end

  def resend_confirmation_instruction
    @user.send_confirmation_instructions
    redirect_back fallback_location: root_path
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
    selected_teams = Team.in_current_season.accepted.order(:name)
    current_season.active? ? selected_teams : all_teams
  end
  helper_method :teams

  def opt_in_params
    params.require(:user).permit(
      :opted_in_newsletter_at,
      :opted_in_announcements_at,
      :opted_in_marketing_announcements_at,
      :opted_in_surveys_at,
      :opted_in_sponsorships_at,
      :opted_in_applications_open_at
    ).to_h.map do |opt_in, value|
      next if opted_in?(opt_in_selected?(value), opt_in)
      [opt_in, opted_in_time(value)]
    end.to_h
  end

  def opted_in_time(value)
    opt_in_selected?(value) ? Time.now : nil
  end

  def opt_in_selected?(value)
    value != '0'
  end

  def opted_in?(selected, opt_in)
    selected && @user.send(opt_in).present?
  end

  def user_params
    params.require(:user).permit(
      :github_handle, :twitter_handle, :irc_handle,
      :name, :email, :homepage, :location, :bio,
      :tech_expertise_list, :tech_interest_list,
      :tshirt_size, :tshirt_cut, :postal_address, :timezone,
      :country,
      :hide_email,
      :is_company, :company_name, :company_info,
      :application_about, :application_motivation, :application_gender_identification, :application_age,
      :application_coding_level, :application_community_engagement, :application_language_learning_period,
      :application_learning_history, :application_skills, :application_code_samples,
      :application_location, :application_minimum_money, :application_money, :application_goals, :application_code_background,
      interested_in: [],
      roles_attributes: [:id, :name, :team_id, :_destroy]
    )
  end
end
