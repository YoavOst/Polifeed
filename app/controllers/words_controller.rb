class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    if params[:word_id]
      @words = Word.where("id = ?", params[:word_id])
    elsif params[:clique_id]
      @words = Clique.find(params[:clique_id]).words.order(:text => :desc)
    elsif params[:results]
      @words = Search.find(params[:results]).statuses.collect{ |s| s.words }.compact.order(:text => :desc)
    elsif params[:q_tokens]
      @words = Word.tokens(params[:q_tokens])  
    elsif params[:letter]
      @words = Word.first_char(params[:letter])
    elsif params[:status]
      @words = Status.find(params[:status]).words
    else
      @words = Word.order(:text).limit(100)
    end
        
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @words }
      format.csv { send_data @words }
      if (params[:clique_id])
        format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{Clique.find(params[:clique_id]).name}.xls\"" }
      else
        format.xls
      end
    end        
  end

  # GET /words/1
  # GET /words/1.json
  def show
    respond_to do |format|
      format.html { redirect_to @word }  
      format.js
    end
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def most_common
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:text)
    end
end
