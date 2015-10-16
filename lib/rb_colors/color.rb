module RbColors
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
      [h, s, v]
    end

    def self.hsv_to_rgb(h, s, v)
      return [v, v, v] if s == 0.0
      i = (h * 6.0).to_i
      f = (h * 6.0) - i
      p = v * (1.0 - s)
      q = v * (1.0 - s * f)
      t = v * (1.0 - s * (1.0 - f))
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

  class Color
    def hex
      HexColor.new('%02x%02x%02x' % rgb.to_a)
    end

    def rgb
      raise NotImplementedError
    end

    def hsv
      raise NotImplementedError
    end

    def screen(other)
      self_rgb = rgb.to_a
      other_rgb = other.rgb.to_a
      new_color = self_rgb.zip(other_rgb).map do |i, j|
        255 - ((255 - i) * (255 - j) / 255.0)
      end
      RGBColor.new(*new_color)
    end

    def difference(other)
      self_rgb = rgb.to_a
      other_rgb = other.rgb.to_a
      RGBColor.new(*self_rgb.zip(other_rgb).map { |i, j| (i - j).abs })
    end

    def overlay(other)
      screen(self * other)
    end

    def invert
      difference(RGBColor.new(255, 255, 255))
    end

    def +(other)
      self_rgb = rgb.to_a
      other_rgb = other.rgb.to_a
      RGBColor.new(*self_rgb.zip(other_rgb).map { |i, j| [255, i + j].min })
    end

    def -(other)
      self_rgb = rgb.to_a
      other_rgb = other.rgb.to_a
      RGBColor.new(*self_rgb.zip(other_rgb).map { |i, j| [0, i - j].max })
    end

    def *(other)
      self_rgb = rgb.to_a
      other_rgb = other.rgb.to_a
      RGBColor.new(*self_rgb.zip(other_rgb).map { |i, j| i * j / 255.0 })
    end

    def /(other)
      self_rgb = rgb.to_a
      other_rgb = other.rgb.to_a
      raise ZeroDivisionError, "0 in #{other}" if other_rgb.include? 0
      RGBColor.new(*self_rgb.zip(other_rgb).map { |i, j| i / j.to_f })
    end

    def to_s
      values = instance_variables.map { |var| instance_variable_get var }
      properties = instance_variables.zip(values).map do |variable, value|
        "#{variable}: #{value}"
      end
      "<#{self.class} #{properties.join(', ')}>"
    end

    def to_a
      instance_variables.map { |var| instance_variable_get var }
    end

    def ==(other)
      rgb.to_a == other.rgb.to_a
    end
  end

  class HSVColor < Color
    attr_reader :hue, :saturation, :value

    def initialize(h = 0, s = 0, v = 0)
      raise ArgumentError, 'Saturation has to be less than 1' if s > 1
      raise ArgumentError, 'Value has to be less than 1' if v > 1
      h -= h.to_i if h >= 1 # Pardon???
      @hue = h
      @saturation = s
      @value = v
    end

    def rgb
      RGBColor.new(*(Colorsys.hsv_to_rgb(*to_a).map { |c| c * 255 }))
    end

    def hsv
      self
    end
  end

  class RGBColor < Color
    attr_reader :red, :green, :blue

    def initialize(r = 0, g = 0, b = 0)
      @red = r
      @green = g
      @blue = b
      to_a.each do |c|
        if c < 0 || c > 255
          raise ArgumentError, 'Color values must be between 0 and 255.'
        end
      end
    end

    def rgb
      self
    end

    def hsv
      HSVColor.new(*(Colorsys.rgb_to_hsv(*(to_a.map { |c| c / 255.0 }))))
    end
  end

  class HexColor < RGBColor
    def initialize(hex = '000000')
      raise ArgumentError, 'Hex color must be 6 digits.' unless hex.size == 6
      raise ArgumentError, 'Not a valid hex number.' unless /\h{6}/ =~ hex
      @red, @green, @blue = hex.scan(/../)
    end

    def rgb
      RGBColor.new(*(to_a.map { |c| c.to_i(16) }))
    end

    def hsv
      RGBColor.new(*(to_a.map { |c| c.to_i(16) })).hsv
    end

    def hex
      self
    end

    def to_str
      '%s%s%s' % to_a
    end
  end

  class ColorWheel
    def initialize(start = 0)
      @phase = start > 1 ? start - 1 : start
    end

    def next
      shift = Random.rand * 0.1 + 0.1
      @phase += shift
      @phase = @phase > 1 ? @phase - 1 : @phase
      HSVColor.new(@phase, 1, 0.8)
    end
  end

  class RandomColor
    def self.rand
      HSVColor.new(*3.times.map { Random.rand })
    end
  end
end
