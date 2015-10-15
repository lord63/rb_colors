require 'rb_colors/palette/base'

module RbColors
  class Primary < ColorPalette
    @colors = {
      BLACK: [0, 0, 0],
      WHITE: [255, 255, 255],
      RED: [255, 0, 0],
      GREEN: [0, 255, 0],
      BLUE: [0, 0, 255]
    }
  end
end
