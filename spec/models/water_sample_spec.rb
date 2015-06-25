require 'pry-byebug'
require_relative '../../app/models/water_sample'
require_relative '../../db/db_adapter'

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

  describe '#factor' do
    it 'multiplies Trihalomethanes with their factors and returns the sum' do
      factor_weights_id = 2
      sample2 = WaterSample.find(2)

      factor_weights = DbAdapter.instance.client.query(
        "SELECT * FROM factor_weights WHERE id = #{factor_weights_id}"
      ).first

      adjusted_chloroform =
        sample2.chloroform *
        factor_weights['chloroform_weight']

      adjusted_bromoform =
        sample2.bromoform *
        factor_weights['bromoform_weight']

      adjusted_bromodichloromethane =
        sample2.bromodichloromethane *
        factor_weights['bromodichloromethane_weight']

      adjusted_dibromichloromethane =
        sample2.dibromichloromethane *
        factor_weights['dibromichloromethane_weight']

      expected_result =
        adjusted_chloroform +
        adjusted_bromoform +
        adjusted_bromodichloromethane +
        adjusted_dibromichloromethane

      result = sample2.factor(factor_weights_id)
      expect(result).to eq(expected_result)
    end
  end
end
