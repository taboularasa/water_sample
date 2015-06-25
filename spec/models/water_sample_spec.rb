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

  describe '#to_hash' do
    it 'returns an attributes hash' do
      sample2 = WaterSample.find(2)
      expected_hash = {
        id: 2,
        site: "North Hollywood Pump Station (well blend)",
        chloroform: 0.00291,
        bromoform: 0.00487,
        bromodichloromethane: 0.00547,
        dibromichloromethane: 0.0109
      }
      expect(sample2.to_hash).to eq(expected_hash)
    end

    context 'when include_factors is true' do
      it 'merges all factor results into the attributes hash' do
        sample2 = WaterSample.find(2)
        expected_hash = {
          id: 2,
          site: "North Hollywood Pump Station (well blend)",
          chloroform: 0.00291,
          bromoform: 0.00487,
          bromodichloromethane: 0.00547,
          dibromichloromethane: 0.0109,
          factor_1: 0.024007,
          factor_2: 0.02415,
          factor_3: 0.021627,
          factor_4: 0.02887
        }
        expect(sample2.to_hash(true)).to eq(expected_hash)
      end
    end
  end
end
