require_relative 'external_line'

module IDEF0

  class ExternalMechanismLine < ExternalLine

    def self.make_line(source, target)
      source.bottom_side.each_anchor do |anchor|
        yield(new(source, target, anchor.name)) if target.bottom_side.expects?(anchor.name)
      end
    end

    def initialize(*args)
      super
      clear(@target.bottom_side, 20)
    end

    def attach
      @target_anchor = target.bottom_side.attach(self)
      self
    end

    def bounds(bounds)
      add_clearance_from(@target.bottom_side, bounds.y2 - y1 + 40)
    end

    def avoid(lines, bounds_extension)
      claim = 0
      while lines.any? { |other| label.overlapping?(other.label) } do
        claim += 20
        add_clearance_from(@target.bottom_side, -20)
      end
      bounds_extension.south = claim
    end

    def extend_bounds(extension)
      add_clearance_from(@target.bottom_side, extension.south)
    end

    def x1
      target_anchor.x
    end

    def y1
      y2+clearance_from(@target.bottom_side)
    end

    def x2
      x1
    end

    def left_edge
      label.left_edge
    end

    def right_edge
      label.right_edge
    end

    def label
      CentredLabel.new(@name, Point.new(x1, y1-5))
    end

    def clearance_group(side)
      case
      when @target.bottom_side
        2
      else
        super
      end
    end

    def to_svg
      <<-XML
#{svg_line(x1, y1-20, x2, y2)}
#{svg_up_arrow(x2, y2)}
#{label.to_svg}
XML
    end

  end

end
