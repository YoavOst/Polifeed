class PoliticiansController < ApplicationController
  before_action :set_politician, only: [:show, :edit, :update, :destroy, :get_new_statuses, :get_avatar_picture]

  # GET /politicians
  # GET /politicians.json
  def index
    @politicians = Politician.joins(:party).order("parties.knesset_seats_20 desc, politicians.location_20 asc")
    @fb_url = Politician.fb_initiate(request.host, request.port, politicians_path)
  end

  # GET /politicians/1
  # GET /politicians/1.json
  def show
  end

  # GET /politicians/new
  def new
    @politician = Politician.new
  end

  # GET /politicians/1/edit
  def edit
  end

  # POST /politicians
  # POST /politicians.json
  def create
    @politician = Politician.new(politician_params)

    respond_to do |format|
      if @politician.save
        format.html { redirect_to @politician, notice: 'Politician was successfully created.' }
        format.json { render :show, status: :created, location: @politician }
      else
        format.html { render :new }
        format.json { render json: @politician.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /politicians/1
  # PATCH/PUT /politicians/1.json
  def update
    respond_to do |format|
      if @politician.update(politician_params)
        format.html { redirect_to @politician, notice: 'Politician was successfully updated.' }
        format.json { render :show, status: :ok, location: @politician }
      else
        format.html { render :edit }
        format.json { render json: @politician.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /politicians/1
  # DELETE /politicians/1.json
  def destroy
    @politician.destroy
    respond_to do |format|
      format.html { redirect_to politicians_url, notice: 'Politician was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /politicians/1/get_new_statuses
  def get_new_statuses
    @politician.get_new_statuses if !(:fb_page.nil? || :fb_page.empty?)
    redirect_to politicians_path
  end
  
  # GET /politicians/get_new_statuses_for_all
  def get_new_statuses_for_all
    Politician.all.each do |po|
      po.get_new_statuses if !(po.fb_page.nil? || po.fb_page.empty?)
    end  
    redirect_to politicians_path
  end
  
  # POST /politicians/1/get_avatar_picture
  def get_avatar_picture
    @politician.set_avatar_from_fb if !(:fb_page.nil? || :fb_page.empty?)
    redirect_to politicians_path
  end

  # GET /politicians/get_avatar_picture_for_all
  def get_avatar_picture_for_all  
    Politician.all.each do |po|
      po.set_avatar_from_fb if !(po.fb_page.nil? || po.fb_page.empty?)
    end  
    redirect_to politicians_path
  end
  
  private
      
    # Use callbacks to share common setup or constraints between actions.
    def set_politician
      @politician = Politician.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def politician_params
      params.require(:politician).permit(:full_name, :fb_page, :last_refresh_time, :party_id, :location_20, :avatar)
    end
end
