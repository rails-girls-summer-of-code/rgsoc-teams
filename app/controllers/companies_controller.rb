class CompaniesController < ApplicationController
  before_filter :set_company,  only: [:edit, :update, :destroy]

  load_and_authorize_resource except: [:index]

  def index
    #TODO: offer possibility to sort by slots and coaches.
    @companies = Company.order(:name)
  end

  def new
    #TODO: redirect with message if current_user already has a company.
  end

  def edit
  end

  def create
    @company = Company.new(company_params)
    @company.owner = current_user

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: 'Company was successfully created.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @company.update_attributes(company_params)
        format.html { redirect_to companies_url, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end


  private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(
        :name, :website, :student_slots, :coaches_number,
        # roles_attributes: [:id, :name, :_destroy],
        sources_attributes: [:id, :_destroy]
      )
    end

end
