require 'rb_colors/palette/base'

module RbColors
  class Primary < ColorPalette
    # Each color palette should have their own cache, in case that they
    # will cache other color which has the same name in other palettes,
    # e.g. GREEN color in RbColors::Primary and RbColors::Rainbow, the
    # rgb value is different from each other.
    @cached_color = {}
    @colors = {
      BLACK: [0, 0, 0],
      WHITE: [255, 255, 255],
      RED: [255, 0, 0],
      GREEN: [0, 255, 0],
      BLUE: [0, 0, 255]
    }
  end
end
