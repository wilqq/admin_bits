module AdminBits::ActiveRecordFilter
  def default_active_record_filters
    attribute_names = resource.attribute_names

    attribute_names.each do |attribute|
      method_name = "#{attribute}_filter"
      column_type = resource.column_types[attribute].type

      if column_type == :integer || column_type == :float || column_type == :decimal
        binding.pry
        define_numeric_filter(attribute, method_name)
      end
    end

    attribute_names.map { |a| "#{attribute}_filter".to_sym }
  end

  private

  def define_numeric_filter(attribute, method_name)
    self.class.send :define_method, method_name do |resource|
      method_params = current_numeric_method_params(method_name)
      resource.where("#{attribute} #{method_params[:sign]} ?", method_params[:value])
      binding.pry
    end
  end

  def current_numeric_method_params(method_name)
    params = filter_params[method_name]
    if params.keys.first == 'greather_than'
      sign = '>'
    elsif params.keys.first == 'less_than'
      sign = '<'
    elsif params.keys.first == 'equal'
      sign = '='
    end

    { sign: sign, value: params.values.first }
  end
end


# params['filters'] = {'price_filter' => {'greather_than' => 30}}
