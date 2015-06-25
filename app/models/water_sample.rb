require_relative '../../db/db_adapter'

class WaterSample
  TRIHALOMETHANES =
    %i(chloroform bromoform bromodichloromethane dibromichloromethane)
  ATTRIBUTES = %i(id site) + TRIHALOMETHANES

  attr_accessor(*ATTRIBUTES)

  def self.find(sample_id)
    results =
      db.client.query("SELECT * FROM water_samples WHERE id = #{sample_id}")
    new(results.first)
  end

  def initialize(attrs)
    attributes.each { |e| send("#{e}=", attrs[e.to_s]) }
  end

  def factor(factor_weights_id)
    factor_weights = find_factor_weights(factor_weights_id)

    trihalomethanes.inject(0) do |memo, element|
      memo + send(element) * factor_weights["#{element.to_s}_weight"]
    end
  end

  def to_hash(include_factors = false)
    attributes_hash = attributes.each_with_object({}) {|e, h| h[e] = send(e) }
    return attributes_hash unless include_factors

    factors_hash = all_factor_weights.each_with_object({}) do |element, hash|
      hash["factor_#{element['id']}".to_sym] = factor(element['id'])
    end

    attributes_hash.merge(factors_hash)
  end

  private

  def self.db
    @db ||= DbAdapter.instance
  end

  def trihalomethanes
    TRIHALOMETHANES
  end

  def attributes
    ATTRIBUTES
  end

  def all_factor_weights
    self.class.db.client.query("SELECT * FROM factor_weights")
  end

  def find_factor_weights(factor_weights_id)
    self.class.db.client.query(
      "SELECT * FROM factor_weights WHERE id = #{factor_weights_id}"
    ).first
  end
end
