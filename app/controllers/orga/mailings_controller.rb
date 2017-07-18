class Orga::MailingsController < Orga::BaseController
  before_action :normalize_params, only: [:create, :update]
  before_action :find_mailing, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, :mailing
    @mailings = mailings
  end

  def show
    authorize! :read, :mailing
  end

  def new
    @mailing = Mailing.new
  end

  def create
    @mailing = Mailing.new(mailing_params)
    if @mailing.save
      redirect_to orga_mailing_path(@mailing), notice: 'Mailing was successfully created.'
    else
      render action: :new
    end
  end

  def update
    if @mailing.update(mailing_params)
      redirect_to orga_mailing_path(@mailing), notice: 'Mailing was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @mailing.destroy!
    redirect_to orga_mailings_path, notice: "The mailing has been deleted"
  end

  private

  def find_mailing
    @mailing = Mailing.find(params[:id])
  end

  def mailings
    Mailing.order('id DESC').page(params[:page])
  end

  def normalize_params
    params[:mailing][:to] = params[:mailing][:to].select(&:present?)
  end

  def mailing_params
    if params[:mailing]
      self.params.require(:mailing)
        .permit(:group, :from, :cc, :bcc, :subject, :body, to: [], seasons: [])
    else
      { from: ENV['EMAIL_FROM'], to: 'teams', seasons: [Season.current.name] }
    end
  end

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Mailings', :mailings]
  end
end
