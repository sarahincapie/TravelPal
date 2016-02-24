class MoneyexchangesController < ApplicationController
  before_action :set_moneyexchange, only: [:show, :edit, :update, :destroy]

  # GET /moneyexchanges
  # GET /moneyexchanges.json
  def index
    @moneyexchanges = Moneyexchange.all
  end

  # GET /moneyexchanges/1
  # GET /moneyexchanges/1.json
  def show
  end

  # GET /moneyexchanges/new
  def new
    @moneyexchange = Moneyexchange.new
  end

  # GET /moneyexchanges/1/edit
  def edit
  end

  # POST /moneyexchanges
  # POST /moneyexchanges.json
  def create
    @moneyexchange = Moneyexchange.new(moneyexchange_params)

    respond_to do |format|
      if @moneyexchange.save
        format.html { redirect_to @moneyexchange, notice: 'Moneyexchange was successfully created.' }
        format.json { render :show, status: :created, location: @moneyexchange }
      else
        format.html { render :new }
        format.json { render json: @moneyexchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moneyexchanges/1
  # PATCH/PUT /moneyexchanges/1.json
  def update
    respond_to do |format|
      if @moneyexchange.update(moneyexchange_params)
        format.html { redirect_to @moneyexchange, notice: 'Moneyexchange was successfully updated.' }
        format.json { render :show, status: :ok, location: @moneyexchange }
      else
        format.html { render :edit }
        format.json { render json: @moneyexchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moneyexchanges/1
  # DELETE /moneyexchanges/1.json
  def destroy
    @moneyexchange.destroy
    respond_to do |format|
      format.html { redirect_to moneyexchanges_url, notice: 'Moneyexchange was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moneyexchange
      @moneyexchange = Moneyexchange.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moneyexchange_params
      params.require(:moneyexchange).permit(:money)
    end
end
