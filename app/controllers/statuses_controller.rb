class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy, :process_words, :find_word_abs, :find_word_sen]

  # GET /statuses
  # GET /statuses.json
  def index
    if params[:politician_id]
      @statuses = Politician.find(params[:politician_id]).statuses.order(:publish_time => :desc).page(params[:page])
    elsif params[:tag]
      @statuses = Tag.find_by_text(params[:tag]).statuses.order(:publish_time => :desc).page(params[:page])
    elsif params[:results]
      @statuses = Search.find(params[:results]).statuses.order(:publish_time => :desc).page(params[:page])
    else 
      @statuses = Status.all.page(params[:page]).order(:publish_time => :desc)
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @statuses = Status.where("id = ?", params[:id]).page(params[:page])
    render "index"
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(status_params)

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to :back, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # POST /statuses/1/process_status_words
  def process_words
    @status.process_words
    redirect_to :back  
  end
  
  # POST /statuses/1/find_word_abs
  def find_word_abs
    @word = @status.find_word_abs(params[:abs_position])

    respond_to do |format|
      if @word then
        format.js { render "find_word", :locals => {:word => @word.text, :notice => "נמצאה מילה" } }
      else
        format.js { render "find_word", :locals => {:word => nil, :notice => "לא נמצאה מילה" } }
      end
    end
  end
  
  # POST /statuses/1/find_word_sen
  def find_word_sen
    @word = @status.find_word_sen(params[:sen_num], params[:sen_position])
    respond_to do |format|
      if @word then
        format.js { render "find_word", :locals => {:word => @word.text, :notice => "נמצאה מילה" } }
      else
        format.js { render "find_word", :locals => {:word => nil, :notice => "לא נמצאה מילה" } }
      end
    end
  end

  # POST /statuses/1/find_matching_phrase
  def find_matching_phrase
    @text = params["marked_phrase_#{params[:id]}"]
    @search = Search.create(:phrase_text => @text)
    @statuses = @search.statuses.order(:publish_time => :desc).page(params[:page]) 
    render "index"
  end
  
  # GET /statuses/process_unprocessed
  def process_unprocessed
    Status.unprocessed.each do |st|
      st.process_words
    end
    redirect_to statuses_path
  end
  
  def most_words
    @results = Status.most_words(params[:number])    
    
    respond_to do|format|
      format.json { @results }
    end    
  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:fb_status_id, :politician_id, :publish_time, :fb_get_time, :is_processed, :tokens, :words, :sentences, :tag_tokens)
    end
end
