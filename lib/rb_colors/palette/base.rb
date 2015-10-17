module RbColors
  class ColorPalette
    # Get all the color constants in a color palette.
    def self.colors
      @colors.keys
    end

    def self.const_missing(name)
      # Use a cache to make sure that we always get the same object for a color.
      return @cached_color[name] if @cached_color.key? name
      @cached_color[name] = RGBColor.new(*@colors[name]) if @colors.key? name
    end
  end
end
