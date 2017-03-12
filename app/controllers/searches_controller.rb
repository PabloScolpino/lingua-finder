class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_search, only: [:show, :destroy]
  before_action :set_searches, only: [:index, :create]

  def index
    @search = Search.new
  end

  def show
    @results =  @search.results.group(:word).count
  end

  def create
    @search = @user.searches.create(search_params)

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

  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(current_user.id)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = @user.searches.find(params[:id])
    end

    def set_searches
      @searches = @user.searches
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:query, :country_code)
    end
end
