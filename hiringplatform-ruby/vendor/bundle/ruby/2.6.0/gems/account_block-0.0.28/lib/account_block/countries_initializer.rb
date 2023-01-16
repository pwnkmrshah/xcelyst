module CountriesInitializer
  extend self

  def execute
    return if initialized?

    @initialized = true

    countries.each do |id, data|
      update_data Country[id], data.merge({'alpha2' => id})
    end
  end

  private

  def initialized?
    return @initialized if defined?(@initialized)
    @initialized = false
  end

  # attributes that will be overwritten
  def countries
    {
      'HM' => {
        :country_code => 672,
      },
    }.freeze
  end

  # attributes that will be copied from the original
  def attributes
    [
      :alpha2,
      :name,
      :country_code,
      :nanp_prefix,
    ]
  end

  def update_data(country, data)
    ISO3166::Data.register attributes_for(country, data)
  end

  def attributes_for(country, data)
    attrs = {}

    attributes.each do |key|
      attrs[key] = data[key] || country.send(key)
    end

    attrs
  end
end

CountriesInitializer.execute
