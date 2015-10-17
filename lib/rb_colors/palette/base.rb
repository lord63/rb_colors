module RbColors
  class ColorPalette
    def self.colors
      @colors.keys
    end

    def self.const_missing(name)
      return @cached_color[name] if @cached_color.key? name
      @cached_color[name] = RGBColor.new(*@colors[name]) if @colors.key? name
    end
  end
end
