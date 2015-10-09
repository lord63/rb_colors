require 'set'

module Colorsys
    def self.rgb_to_hsv(r, g, b)
        max_color = [r, g, b].max
        min_color = [r, g, b].min
        v = max_color
        return [0.0, 0.0, v] if max_color == min_color
        s = (max_color - min_color) / max_color
        rc = (max_color - r) / (max_color - min_color)
        gc = (max_color - g) / (max_color - min_color)
        bc = (max_color - b) / (max_color - min_color)
        if r == max_color
            h = bc - gc
        elsif g == max_color
            h = 2.0 + rc - bc
        else
            h = 4.0 + gc - rc
        end
        h = (h / 6.0) % 1.0
        return [h, s, v]
    end

    def self.hsv_to_rgb(h, s, v)
        return [v, v, v] if s == 0.0
        i = (h * 6.0).to_i
        f = (h * 6.0) - i
        p = v * (1.0 - s)
        q = v * (1.0 - s*f)
        t = v * (1.0 - s*(1.0 - f))
        i = i % 6
        case i
        when 0
            [v, t, p]
        when 1
            [q, v, p]
        when 2
            [p, v, t]
        when 3
            [p, q, v]
        when 4
            [t, p, v]
        when 5
            [v, p, q]
        end
    end
end


module Colors
    class Color
        def hex
            HexColor.new("%02x%02x%02x" % @color)
        end

        def rgb
            raise NoMethodError
        end

        def hsv
            raise NoMethodError
        end

        def to_s
            values = instance_variables.map {|var| instance_variable_get var}
            properties = instance_variables.zip(values).map do |variable, value|
                "#{variable}: #{value}" unless variable.to_s == "@color"
            end
            "<%s %s>" % [self.class, properties.compact.join(', ')]
        end
    end

    class HSVColor < Color
        attr_reader :hue, :saturation, :value

        def initialize(h=0, s=0, v=0)
            raise ArgumentError, "Saturation has to be less than 1" if s >1
            raise ArgumentError, "Value has to be less than 1" if v > 1
            h = h - h.to_i if h >= 1   # Pardon???
            @hue, @saturation, @value = @color = [h, s, v]
        end

        def rgb
            RGBColor.new(*(Colorsys.hsv_to_rgb(*@color).map {|c| c * 255}))
        end

        def hsv
            self
        end
    end

    class RGBColor < Color
        attr_reader :red, :green, :blue

        def initialize(r=0, g=0, b=0)
            @red, @green, @blue = @color = [r, g, b]
            @color.each { |c| raise ArgumentError, "Color values must be between 0 and 255." if c < 0 || c > 255 }
        end

        def rgb
            self
        end

        def hsv
            HSVColor.new(*(Colorsys.rgb_to_hsv(*(@color.map {|c| c / 255.0}))))
        end
    end


    class HexColor < RGBColor
        def initialize(hex='000000')
            raise ArgumentError, "Hex color must be 6 digits." unless hex.size == 6
            raise ArgumentError, "Not a valid hex number." unless hex.chars.map(&:downcase).to_set.subset? "0123456789abcdef".chars.to_set
            @color = hex.chars.each_slice(2).map(&:join)
        end

        def rgb
            RGBColor.new(*(@color.map {|c| c.to_i(16)}))
        end

        def hsv
            RGBColor.new(*(@color.map {|c| c.to_i(16)})).hsv
        end

        def hex
            self
        end

        def to_s
            '%s%s%s' % @color
        end
    end
end
