require 'pry-byebug'
require_relative '../../app/models/water_sample'

RSpec.describe WaterSample do
  describe '::find' do
    it 'creates an instance with results fetched from the database' do
      sample2 = WaterSample.find(2)
      expect(sample2.site).to eq("North Hollywood Pump Station (well blend)")
      expect(sample2.chloroform).to eq(0.00291)
      expect(sample2.bromoform).to eq(0.00487)
      expect(sample2.bromodichloromethane).to eq(0.00547)
      expect(sample2.dibromichloromethane).to eq(0.0109)
    end
  end
end
