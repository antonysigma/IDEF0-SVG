require_relative 'box'
require_relative 'labels'

# TODO: Probably could just call this a ChildBox?
module IDEF0
  class ProcessBox < Box
    attr_accessor :sequence

    def precedence
      [-right_side.anchor_count, left_side.anchor_count]
    end

    def parsed_title
      raw_title = @name.to_s.strip
      parts = raw_title.split(':', 2)

      return ["", raw_title] if parts.length == 1
      [parts[0].strip, parts[1].strip]
    end

    def function_id
      parsed_title[0].upcase
    end

    def function_name
      parsed_title[1]
    end

    def width
      [Label.length(function_name)+40, [top_side.anchor_count, bottom_side.anchor_count].max*20+20].max
    end

    def height
      [60, [left_side.anchor_count, right_side.anchor_count].max*20+20].max
    end

    def after?(other)
      sequence > other.sequence
    end

    def before?(other)
      sequence < other.sequence
    end

    def to_svg
      title = CentredLabel.new(
        function_name,
        Point.new(x1 + (width / 2), y1 + (height / 2) - 6)
      )

      identifier = RightAlignedLabel.new(
        function_id,
        Point.new(x2 - 8, y2 - 8)
      )

      <<-XML
    <rect x="#{x1}" y="#{y1}" width="#{width}" height="#{height}" fill="lightyellow" stroke="black" filter="url(#f1fkw0u0qbu464)" />
    #{title.to_svg}
    #{identifier.to_svg}
    XML
    end
  end
end
