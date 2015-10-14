module RbColors
  class Primary
    class << self
      def method_missing(name, *args)
        colors = {
          black: [0, 0, 0],
          white: [255, 255, 255],
          red: [255, 0, 0],
          green: [0, 255, 0],
          blue: [0, 0, 255]
        }
        RGBColor.new(*colors[name]) if colors.keys.include? name
      end
    end
  end
end