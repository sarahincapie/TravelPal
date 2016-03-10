class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :details]
  before_action :authenticate_user!, except: [:index, :show]

    def details
      @expenses = current_user.expenses.current_trip_expenses(params[:id])
    end
  
  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @expenses = current_user.expenses.current_trip_expenses(params[:id])
    @donut_data = current_user.donut_data(current_user.expenses.current_trip_expenses(params[:id]))
    @bar_data = current_user.bar_data(current_user.expenses.current_trip_expenses(params[:id]))
    @pink_data = current_user.pink_data(current_user.expenses.current_trip_expenses(params[:id]))
    @spent = current_user.spent(current_user.expenses.current_trip_expenses(params[:id]))
    @geojson = []
    
    @expenses.each do |m|
      if m.latitude 
        @geojson << {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [m.longitude, m.latitude]
          },
          properties: {
            id: m.id,
            :'marker-color' => '#00607d',
            :'marker-symbol' => 'circle',
            :'marker-size' => 'medium'
          }
        }

      end 
    end 
  end

  # GET /trips/new
  def new
    # @trip = Trip.new
    @trip = current_user.trips.build
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    # @trip = Trip.new(trip_params)
    @trip = current_user.trips.build(trip_params)

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trip_params
      params.require(:trip).permit(:name, :user_id, :daily_budget)
    end
end
