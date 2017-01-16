class Hash
  def fetch_deep(path)
    self.fetch_deep_recursion(path.split("."))
  end

  def fetch_deep_recursion(path_array)
    key =  change_key_type(path_array[0])
    return nil if key == nil
    return self[key] if path_array.length == 1

    self[key] = array_to_hash(self[key]) if self[key].is_a?(Array)

    self[key].fetch_deep_recursion(path_array[1..path_array.length])
  end

  def change_key_type(key)
    if self[key.to_sym]
      key = key.to_sym
    elsif self[key]
      key
    end
  end

  def array_to_hash(array)
    hash = []

    array.map do |element|
      hash << [array.index(element).to_s, element]
    end

    hash.to_h
  end

  def reshape(result_format)
    keys = []
    result_format.map do |key, value|
      keys << [
        key,
        value.is_a?(Hash) ? reshape(value) : fetch_deep(value)
      ]
    end

    keys.to_h
  end
end

class Array
  def reshape(shape)
    format_result = []
    self.each do |element|
      target = {}
      shape.keys.each { |key| target[key] = element.fetch_deep(shape[key]) }
      format_result << target
    end
    format_result
  end
end
