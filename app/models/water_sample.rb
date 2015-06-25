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
end
