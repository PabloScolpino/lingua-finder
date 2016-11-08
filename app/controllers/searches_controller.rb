class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :destroy]
  before_action :set_searches, only: [:index, :create]

  # GET /searches
  # GET /searches.json
  def index
    @search = Search.new
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @results =  @search.results.group(:word).count
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)

    respond_to do |format|
      if @search.save
        format.html { redirect_to index, notice: 'Busqueda creada exitosamente.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :index }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    def set_searches
      @searches = Search.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:query, :country_code)
    end
end
