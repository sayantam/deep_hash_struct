require "deep_hash_struct/version"

# Mixin module for converter.
module DeepHashStruct
  # Converts a Hash to a Struct. If the Hash has nested Hash objects, they are converted
  # to Struct as well.
  #   output = deep_struct({x: 1, y: {z: 2}})
  #   output.x #=> 1
  #   output.y.z #=> 2
  #
  # @param [Hash] input
  # @return [Struct]
  def deep_struct(input)
    output = input.clone
    levels = output.keys.map { |key| [key, output] }
    levels.each do |key, context|
      if context[key].is_a?(Hash)
        # overwrite the shared reference with input by a new reference
        context[key] = context[key].clone
        subset = context[key]
        subset.each do |subkey, subvalue|
          levels.push([subkey, subset]) if subvalue.is_a?(Hash)
          subset[subkey] = subset[subkey].map { |v| v.is_a?(Hash) ? deep_struct(v) : v } if subvalue.is_a?(Array)
        end
      elsif context[key].is_a?(Array)
        context[key] = context[key].map { |v|  v.is_a?(Hash) ? deep_struct(v) : v }
      end
    end

    levels.reverse_each do |k, context|
      if context[k].is_a?(Hash)
        klass = Struct.new(*context[k].keys, keyword_init: true)
        context[k] = klass.new(context[k])
      end
    end

    klass = Struct.new(*output.keys, keyword_init: true)
    klass.new(output)
  end
end
