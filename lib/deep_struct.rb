require "deep_struct/version"

# Mixin module for converter.
module DeepStruct
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
        subset.each { |subkey, subvalue| levels.push([subkey, subset]) if subvalue.is_a?(Hash) }
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
