# SingleNestedHashToParam by Ireneusz Skrobis 2010
class Hash

  def flatten(superkey)
    flattened_hash = {}
    self.each do |key, value|
      flattened_hash["#{superkey}[#{key}]".to_sym] = value
    end
    flattened_hash
  end

  def parameterize
    self.each do |k, value|
      if value.is_a?(Hash)
        value.flatten(k).each { |fk, fv| yield fk, fv }
      else
        yield k, value
      end
    end
  end

  def options_as_params
    options_as_params_hsh = {}
    self.parameterize do |param_key, param_value|
      options_as_params_hsh[param_key] = param_value.to_param
    end
    options_as_params_hsh
  end

  def single_nested_hash_to_param
    "?"+self.options_as_params.map{|p| p * "="} * "&"
  end

end