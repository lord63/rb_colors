require 'test_helper'

class RbColorsTest < Minitest::Test
  def setup
    @rgb_color = ::RbColors::RGBColor.new(100, 100, 100)
    @hsv_color = ::RbColors::HSVColor.new(0, 1, 1)
    @hex_color = ::RbColors::HexColor.new('646464')
  end

  def test_that_it_has_a_version_number
    refute_nil ::RbColors::VERSION
  end

  class ColorsysTest < RbColorsTest
    def test_rgb_to_hsv
      assert_equal([0.08333333333333331, 0.5, 0.4],
                   ::RbColors::Colorsys.rgb_to_hsv(0.4, 0.3, 0.2))
      assert_equal([0.5833333333333334, 0.5, 0.4],
                   ::RbColors::Colorsys.rgb_to_hsv(0.2, 0.3, 0.4))
      assert_equal([0.5, 0.5, 0.4],
                   ::RbColors::Colorsys.rgb_to_hsv(0.2, 0.4, 0.4))
    end

    def test_hsv_to_rgb
      assert_equal([0.36, 0.4, 0.2],
                   ::RbColors::Colorsys.hsv_to_rgb(0.2, 0.5, 0.4))
      assert_equal([0.2, 0.4, 0.2800000000000001],
                   ::RbColors::Colorsys.hsv_to_rgb(0.4, 0.5, 0.4))
      assert_equal([0.2, 0.4, 0.4],
                   ::RbColors::Colorsys.hsv_to_rgb(0.5, 0.5, 0.4))
      assert_equal([0.23999999999999988, 0.2, 0.4],
                   ::RbColors::Colorsys.hsv_to_rgb(0.7, 0.5, 0.4))
      assert_equal([0.4, 0.2, 0.31999999999999995],
                   ::RbColors::Colorsys.hsv_to_rgb(0.9, 0.5, 0.4))
    end
  end

  class BasicColorTest < RbColorsTest
    class MyColor < ::RbColors::Color
    end

    def test_my_color
      assert_raises(NotImplementedError) { MyColor.new.rgb }
      assert_raises(NotImplementedError) { MyColor.new.hsv }
    end

    def test_rgb_color
      assert_equal('<RbColors::RGBColor @red: 100, @green: 100, @blue: 100>',
                   @rgb_color.to_s)
      assert_equal [100, 100, 100], @rgb_color.to_a
      assert_equal('<RbColors::RGBColor @red: 100, @green: 100, @blue: 100>',
                   @rgb_color.rgb.to_s)
      assert_equal(
        '<RbColors::HSVColor @hue: 0.0, @saturation: 0.0, ' \
        '@value: 0.39215686274509803>',
        @rgb_color.hsv.to_s)
      assert_equal('<RbColors::HexColor @red: 64, @green: 64, @blue: 64>',
                   @rgb_color.hex.to_s)
      assert_raises(ArgumentError) { ::RbColors::RGBColor.new(300, 0, 0) }
    end

    def test_hsv_color
      assert_equal('<RbColors::HSVColor @hue: 0, @saturation: 1, @value: 1>',
                   @hsv_color.to_s)
      assert_equal [0, 1, 1], @hsv_color.to_a
      assert_equal('<RbColors::RGBColor @red: 255, @green: 0.0, @blue: 0.0>',
                   @hsv_color.rgb.to_s)
      assert_equal('<RbColors::HSVColor @hue: 0, @saturation: 1, @value: 1>',
                   @hsv_color.hsv.to_s)
      assert_equal('<RbColors::HexColor @red: ff, @green: 00, @blue: 00>',
                   @hsv_color.hex.to_s)
    end

    def test_hex_color
      assert_equal '646464', @hex_color.to_str
      assert_equal('<RbColors::HexColor @red: 64, @green: 64, @blue: 64>',
                   @hex_color.to_s)
      assert_equal ['64', '64', '64'], @hex_color.to_a
      assert_equal('<RbColors::RGBColor @red: 100, @green: 100, @blue: 100>',
                   @hex_color.rgb.to_s)
      assert_equal('<RbColors::HSVColor @hue: 0.0, @saturation: 0.0, ' \
                   '@value: 0.39215686274509803>',
                   @hex_color.hsv.to_s)
      assert_equal('<RbColors::HexColor @red: 64, @green: 64, @blue: 64>',
                   @hex_color.hex.to_s)
    end

    def test_color_wheel
      color = ::RbColors::ColorWheel.new.next
      color_array = color.to_a
      assert color_array[0] >= 0 && color_array[0] < 1
      assert_equal [1, 0.8], color_array[1, 2]
      assert_equal ::RbColors::HSVColor, color.class
    end

    def test_random_color
      color = ::RbColors::RandomColor.rand
      color.to_a.map { |c| assert c >= 0 && c < 1 }
      assert_equal ::RbColors::HSVColor, color.class
    end

    def test_compare_color_equality
      assert @rgb_color == @hex_color
      assert @hsv_color != @rgb_color
    end
  end

  class ColorArithmeticTest < RbColorsTest
    def test_color_add
      assert_equal(::RbColors::RGBColor.new(255, 100, 100),
                   @rgb_color + @hsv_color)
    end

    def test_color_subtract
      assert_equal ::RbColors::RGBColor.new(0, 0, 0), @rgb_color - @hex_color
    end

    def test_color_mutiply
      assert_equal(::RbColors::HexColor.new('640000'),
                   (@rgb_color * @hsv_color).hex)
    end

    def test_color_divide
      assert_equal ::RbColors::RGBColor.new(1, 1, 1), @rgb_color / @hex_color
    end
  end

  class ColorBlendModesTest < RbColorsTest
    def test_color_screen
      assert_equal(::RbColors::HexColor.new('a0a0a0'),
                   @hex_color.screen(@rgb_color).hex)
    end

    def test_color_difference
      assert_equal(::RbColors::HexColor.new('000000'),
                   @hex_color.difference(@rgb_color).hex)
    end

    def test_color_overlay
      assert_equal(::RbColors::HexColor.new('7b7b7b'),
                   @hex_color.overlay(@rgb_color).hex)
    end

    def test_color_invert
      assert_equal ::RbColors::RGBColor.new(155, 155, 155), @hex_color.invert
    end
  end

  class ColorPaletteTest < RbColorsTest
    def test_primary_color_palette
      assert_equal 5, ::RbColors::Primary.constants.size
      assert_same ::RbColors::Primary::GREEN, ::RbColors::Primary::GREEN
      assert ::RbColors::Primary::GREEN != ::RbColors::Rainbow::GREEN
      each_palette_color(::RbColors::Primary)
    end

    def test_raibow_color_palette
      assert_equal 7, ::RbColors::Rainbow.constants.size
      assert_same ::RbColors::Primary::RED, ::RbColors::Primary::RED
      each_palette_color(::RbColors::Rainbow)
    end

    def test_w3c_color_palette
      assert_equal 147, ::RbColors::W3C.constants.size
      assert_same ::RbColors::Primary::AQUA, ::RbColors::Primary::AQUA
      each_palette_color(::RbColors::W3C)
    end

    private

    def each_palette_color(palette)
      rgb_values = palette.instance_variable_get(:@colors).values
      color_constants = palette.constants
      color_constants.zip(rgb_values).each do |color_name, rgb_value|
        assert_equal(RbColors::RGBColor.new(*rgb_value),
                     palette.const_get(color_name))
      end
    end
  end
end
