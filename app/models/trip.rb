class Trip < ActiveRecord::Base
	
  belongs_to :user
  has_many :expenses, dependent: :destroy

  def self.to_json
    @expenses = Expense.current_trip_expenses(params[:id])
    @geojson = []
    
    @expenses.each do |m|
      @geojson << {
        type: 'Feature',
        geometry: {
          type: 'Point',
          coordinates: [m.latitude, m.longitude]
        },
        properties: {
          id: m.id,
          name: m.title,
          number: m.number,
          description: m.description,
          :'marker-color' => '#00607d',
          :'marker-symbol' => 'circle',
          :'marker-size' => 'medium'
        }
      }
    end
  end
end
