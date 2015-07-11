class CliquesController < ApplicationController
  before_action :set_clique, only: [:show, :edit, :update, :destroy]

  # GET /cliques
  # GET /cliques.json
  def index
    if params[:clique_id]
      @cliques = Clique.where("id = ?", params[:clique_id])
    else
      @cliques = Clique.all
    end
    
    render :layout => "modal"
  end

  # GET /cliques/1
  # GET /cliques/1.json
  def show
  end

  # GET /cliques/new
  def new
    @clique = Clique.new
  end

  # GET /cliques/1/edit
  def edit
  end

  # POST /cliques
  # POST /cliques.json
  def create
    @clique = Clique.new(clique_params)

    respond_to do |format|
      if @clique.save
        format.html { redirect_to cliques_url }
        format.json { render :show, status: :created, location: @clique }
        format.js
      else
        format.html { render :new }
        format.json { render json: @clique.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cliques/1
  # PATCH/PUT /cliques/1.json
  def update
    respond_to do |format|
      if @clique.update(clique_params)
        @notice = 'הקבוצה עודכנה בהצלחה'
        format.html { redirect_to @clique, notice: @notice }
        format.json { render :show, status: :ok, location: @clique }
        format.js   { } 
      else
        format.html { render :edit }
        format.json { render json: @clique.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cliques/1
  # DELETE /cliques/1.json
  def destroy
    @clique.destroy
    respond_to do |format|
      format.html { redirect_to cliques_url, notice: 'Clique was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clique
      @clique = Clique.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clique_params
      params.require(:clique).permit(:name, :word_tokens)
    end
end
