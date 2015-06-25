require_relative '../../db/db_adapter'

class WaterSample
  TRIHALOMETHANES =
    [:chloroform, :bromoform, :bromodichloromethane, :dibromichloromethane]

  attr_accessor(:id, :site, *TRIHALOMETHANES)

  def self.find(sample_id)
    results =
      db.client.query("SELECT * FROM water_samples WHERE id = #{sample_id}")
    new(results.first)
  end

  def initialize(attributes)
    self.id = attributes['id'],
    self.site = attributes['site'],
    self.chloroform = attributes['chloroform'],
    self.bromoform = attributes['bromoform'],
    self.bromodichloromethane = attributes['bromodichloromethane'],
    self.dibromichloromethane = attributes['dibromichloromethane']
  end

  def factor(factor_weights_id)
    factor_weights = self.class.db.client.query(
      "SELECT * FROM factor_weights WHERE id = #{factor_weights_id}"
    ).first

    trihalomethanes.inject(0) do |accumulator, element|
      accumulator += send(element) * factor_weights["#{element.to_s}_weight"]
    end
  end

  def self.db
    @db ||= DbAdapter.instance
  end

  private

  def trihalomethanes
    TRIHALOMETHANES
  end
end
