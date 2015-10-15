require 'rb_colors/palette/base'

module RbColors
  class Rainbow < ColorPalette
    @colors = {
      RED: [255, 0, 0],
      ORANGE: [255, 165, 0],
      YELLOW: [255, 255, 0],
      GREEN: [0, 128, 0],
      BLUE: [0, 0, 255],
      INDIGO: [75, 0, 130],
      VIOLET: [238, 130, 238]
    }
  end
end
