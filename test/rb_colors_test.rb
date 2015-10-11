require 'test_helper'

class RbColorsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RbColors::VERSION
  end

  def test_rgb_to_hsv
    assert [0.5, 0.5, 0.4], ::Colorsys.rgb_to_hsv(0.2, 0.4, 0.4)
  end

  def test_hsv_to_rgb
    assert [0.2, 0.4, 0.4], ::Colorsys.hsv_to_rgb(0.5, 0.5, 0.4)
  end

  def test_rgb_color
    rgb_color = ::RbColors::RGBColor.new(100, 100, 100)
    assert "<RbColors::RGBColor @blue: 100, @green: 100, @red: 100>", rgb_color.to_s
    assert [100, 100, 100], rgb_color.to_a
    assert "<RbColors::RGBColor @blue: 100, @green: 100, @red: 100>", rgb_color.rgb.to_s
    assert "<RbColors::HSVColor @hue: 0.0, @saturation: 0.0, @value: 0.39215686274509803>", rgb_color.hsv.to_s
    assert "<RbColors::HexColor @red: 64, @green: 64, @blue: 64>", rgb_color.hex.to_s
  end

  def test_hsv_color
    hsv_color = ::RbColors::HSVColor.new(0, 1, 1)
    assert "<RbColors::HSVColor @hue: 0, @saturation: 1, @value: 1>", hsv_color.to_s
    assert [0, 1, 1], hsv_color.to_a
    assert "<RbColors::RGBColor @blue: 0.0, @green: 0.0, @red: 255>", hsv_color.rgb.to_s
    assert "<RbColors::HSVColor @hue: 0, @saturation: 1, @value: 1>", hsv_color.hsv.to_s
    assert "<RbColors::HexColor @red: 00, @green: 00, @blue: ff>", hsv_color.hex.to_s
  end

  def test_hex_color
    hex_color = ::RbColors::HexColor.new('646464')
    assert "646464", hex_color.to_str
    assert "<RbColors::HexColor @red: 64, @green: 64, @blue: 64>", hex_color.to_s
    assert ["64", "64", "64"], hex_color.to_a
    assert "<RbColors::RGBColor @blue: 100, @green: 100, @red: 100>", hex_color.rgb.to_s
    assert "<RbColors::HSVColor @hue: 0.0, @saturation: 0.0, @value: 0.39215686274509803>", hex_color.hsv.to_s
    assert "<RbColors::HexColor @red: 64, @green: 64, @blue: 64>", hex_color.hex.to_s
  end
end
