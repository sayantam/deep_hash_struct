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
    levels = expand_levels(output)
    collapse_levels(levels)
    klass = Struct.new(*output.keys, keyword_init: true)
    klass.new(output)
  end

  def expand_levels(output)
    levels = output.keys.map { |key| [key, output] }
    levels.each do |key, context|
      if context[key].is_a?(Hash)
        # overwrite the shared reference with input by a new reference
        context[key] = context[key].clone
        subset = context[key]
        subset.each do |subkey, subvalue|
          levels.push([subkey, subset]) if subvalue.is_a?(Hash)
          subset[subkey] = deep_struct_enumerable(subset[subkey]) if subvalue.is_a?(Array)
        end
      elsif context[key].is_a?(Array)
        context[key] = deep_struct_enumerable(context[key])
      end
    end
    levels
  end
  private :expand_levels

  # @param [Enumerable] enumerable
  def deep_struct_enumerable(enumerable)
    enumerable.map { |v| v.is_a?(Hash) ? deep_struct(v) : v }
  end
  private :deep_struct_enumerable

  def collapse_levels(levels)
    levels.reverse_each do |k, context|
      if context[k].is_a?(Hash)
        klass = Struct.new(*context[k].keys, keyword_init: true)
        context[k] = klass.new(context[k])
      end
    end
  end
  private :collapse_levels
end
