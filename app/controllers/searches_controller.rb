class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /searches/1
  # GET /searches/1.json
  def show
  end

  # GET /searches/new
  def new
    @search = Search.new  
  end

  # POST /searches/new
  # POST /searches.json/new
  def create
    @search = Search.new(search_params)    
    respond_to do |format|
      if @search.save
        format.html { redirect_to :controller => 'statuses', :action => 'index', :results => @search.id }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:name, :party_id, :politician_id, :start_date, :end_date, :word_id, :clique_id, :phrase_id, :word_text, :phrase_text, :is_exact)
    end
end
