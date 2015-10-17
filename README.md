# RbColors

[![Latest Version][1]][2]
[![Build Status][3]][4]
[![Coverage Status][5]][6]

Convert colors between rgb, hsv and hex, perform arithmetic, blend modes, and
generate random colors within boundaries. This is a ruby implementation for the
original [colors.py][].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rb_colors'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rb_colors

## Usage

To use RbColors:

```ruby
require "rb_colors"
```

### Basic

#### RGBColor, HSVColor, HexColor

I'll take the RGBColor as an example to show you the basic usages.

create and RGB color object

	> rgb_color = RbColors::RGBColor.new(100, 100, 100)
	 => #<RbColors::RGBColor:0x00000001364b50 @red=100, @green=100, @blue=100>

get the red color, green color or blue color

	> rgb_color.red
	 => 100

convert it to HSVColor

	> rgb_color.hsv
	 => #<RbColors::HSVColor:0x00000000ef98e0 @hue=0.0, @saturation=0.0, @value=0.39215686274509803>

convert it to HexColor

	> rgb_color.hex
	 => #<RbColors::HexColor:0x00000000effc40 @red="64", @green="64", @blue="64">

the string representing of a color

	> rgb_color.to_s
	 => "<RbColors::RGBColor @red: 100, @green: 100, @blue: 100>"

get the rgb value array

	> rgb_color.to_a
	 => [100, 100, 100]

#### ColorWheel

The color wheel allows you to randomly choose colors while keeping the colors
relatively evenly distributed. Think generating random colors without pooling in
one hue, e.g., not 50 green, and 1 red.

    > color_wheel = RbColors::ColorWheel.new
	 => #<RbColors::ColorWheel:0x000000013a5240 @phase=0>
	> color_wheel.next
	 => #<RbColors::HSVColor:0x0000000139ee18 @hue=0.1130311042805524, @saturation=1, @value=0.8>
	> color_wheel.next
	 => #<RbColors::HSVColor:0x00000001381ca0 @hue=0.2755130313932345, @saturation=1, @value=0.8>

#### RandomColor

generate a random HSVColor

    > RbColors::RandomColor.rand
	 => #<RbColors::HSVColor:0x000000013ef430 @hue=0.1951741813062533, @saturation=0.20363532841868148, @value=0.48843165752999573>

### Arithmetic

Note: All arithmetic operations return RGBColor.

#### Add

    > RbColors::RGBColor.new(10, 10, 10) + RbColors::RGBColor.new(10, 10, 10)
	 => #<RbColors::RGBColor:0x00000001ead318 @red=20, @green=20, @blue=20>

#### Substract

    > RbColors::RGBColor.new(10, 10, 10) - RbColors::RGBColor.new(10, 10, 10)
	 => #<RbColors::RGBColor:0x00000001e3fb38 @red=0, @green=0, @blue=0>

#### Multiply

	> RbColors::RGBColor.new(10, 10, 10) * RbColors::RGBColor.new(10, 10, 10)
     => #<RbColors::RGBColor:0x00000001519720 @red=0.39215686274509803, @green=0.39215686274509803, @blue=0.39215686274509803>

#### Divid

    > RbColors::RGBColor.new(10, 10, 10) / RbColors::RGBColor.new(10, 10, 10)
	 => #<RbColors::RGBColor:0x00000001dfc4a0 @red=1.0, @green=1.0, @blue=1.0>

### Blend modes

Read the souce code at `rb_colors/color.rb RbColors::Color` if you feel puzzled ;)

Note: All arithmetic operations return RGBColor.

#### Screen

	> RbColors::HexColor.new('ff9999').screen(RbColors::RGBColor.new(10, 10, 10)).hex
	 => #<RbColors::HexColor:0x000000015d0628 @red="ff", @green="9d", @blue="9d">

#### Difference

	> RbColors::HexColor.new('ff9999').difference(RbColors::RGBColor.new(10, 10, 10)).hex
	 => #<RbColors::HexColor:0x000000015a5c20 @red="f5", @green="8f", @blue="8f">

#### Overlay

	> RbColors::HexColor.new('ff9999').overlay(RbColors::RGBColor.new(10, 10, 10)).hex
	 => #<RbColors::HexColor:0x0000000158cb30 @red="ff", @green="9b", @blue="9b">

#### Invert

	> RbColors::HexColor.new('000000').invert
	 => #<RbColors::RGBColor:0x0000000153ce78 @red=255, @green=255, @blue=255>

### Color palettes

`rb_colors` current ships with three color palettes full of constants. Get all the
available colors of a palette via `RbColors::ColorPalette.colors`.

#### RbColors::Primary

    > RbColors::Primary.colors
	 => [:BLACK, :WHITE, :RED, :GREEN, :BLUE]
    > RbColors::Primary::RED
	 => #<RbColors::RGBColor:0x00000001c88420 @red=255, @green=0, @blue=0>

#### RbColors::Rainbow

	> RbColors::Rainbow.colors
	 => [:RED, :ORANGE, :YELLOW, :GREEN, :BLUE, :INDIGO, :VIOLET]
    > RbColors::Rainbow::INDIGO
	 => #<RbColors::RGBColor:0x00000001c583d8 @red=75, @green=0, @blue=130>

#### RbColors::W3C

	> RbColors::W3C.colors
     => [:ALICEBLUE, :ANTIQUEWHITE, :AQUA, :AQUAMARINE, :AZURE, :BEIGE, ...]
    > RbColors::W3C::GHOSTWHITE
	 => #<RbColors::RGBColor:0x00000001c1e728 @red=248, @green=248, @blue=255>

## Classes

	- RbColors::Color          |    superclass for RGB, HSV, Hex color
    - RbColors::RGBColor       |    RGB color
	- RbColors::HSVColor       |    HSV color
	- RbColors::HexColor       |    Hex color
	- RbColors::ColorPalette   |    superclass for Primary, Rainbow, W3C palette
	- RbColors::Primary        |    the Primary palette
	- RbColors::Rainbow        |    the Rainbow palette
	- RbColors::W3C            |    the W3C palette
	- RbColors::ColorWheel     |    randomly choose colors while keeping the colors relatively evenly distributed
	- RbColors::RandomColor    |    generate a random HSVColor
	- RbColors::ColorSys       |    convert between rgb and hsv color, port from python's colorsys module

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org][].

## Contributing

* It sucks? Why not help me improve it? Let me know the bad things.
* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or it's better if you can send me a pull request.

Contributions are always welcome at any time! :sparkles: :cake: :sparkles:
Bug reports and pull requests are welcome on GitHub at [lord63/rb_colors][].

## Kudos

All the glories should belong to [@mattrobenolt][], I just port it to python :)

## License

BSD3

[1]: https://badge.fury.io/rb/rb_colors.svg
[2]: http://badge.fury.io/rb/rb_colors
[3]: https://travis-ci.org/lord63/rb_colors.svg?branch=master
[4]: https://travis-ci.org/lord63/rb_colors
[5]: https://codecov.io/github/lord63/rb_colors/coverage.svg?branch=master
[6]: https://codecov.io/github/lord63/rb_colors?branch=master
[colors.py]: https://github.com/mattrobenolt/colors.py
[rubygems.org]: https://rubygems.org
[lord63/rb_colors]: https://github.com/lord63/rb_colors
[@mattrobenolt]: https://github.com/mattrobenolt
