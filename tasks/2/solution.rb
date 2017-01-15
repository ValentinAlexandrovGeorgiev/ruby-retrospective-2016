class Hash
  def fetch_deep(hash_path)
    hash_params = hash_path.split('.')
    this = self

    hash_params.each do |param|
      param = /\A\d+\z/.match(param) ? param.to_i : param.to_sym
      this = this[param]
    end

    this
  end

  def set_hash_value(result_format, key, keys, value)
    keys.map!(&:to_sym)
    key = keys.pop
    keys.inject(result_format, :fetch)[key] = self.fetch_deep(value)
  end

  def recursive_traverse(hash, result_format, keys)

    hash.each do |key, value|
      keys.push(key)
      if value.is_a?(Hash) || value.is_a?(Array)
        recursive_traverse(value, result_format, keys)
      else
        self.set_hash_value(result_format, key, keys, value)
      end
    end

  end

  def reshape(result_format)

    keys = []
    returned_hash = result_format.clone

    self.recursive_traverse(returned_hash, returned_hash, keys)

    returned_hash
  end
end

class Array
  def reshape(shape)
    format_result = []
    self.each { |item| format_result.push(item.reshape(shape)) }
    format_result
  end
end


