DIMENSION_ERROR = "ERROR: each dimension of the image must be between 1 and 250"
COLOUR_ERROR = "ERROR: colour must be a capital letter"
COORD_ERROR = "ERROR: coordinates out of range"
class BitmapEditor

  def run
    @running = true
    @image = []
    puts 'type ? for help'
    while @running
      print '> '
      input = gets.chomp
      case input
      when '?'
        show_help
      when 'X'
        exit_console
      when 'C'
        @image.each { |row| row.map!{"0"} }
      when 'S'
        if @image.empty?
          puts "no image"
        else
          @image.each do |line|
            puts line.join()
          end
        end
      else
        process_command(input.split(' '))
      end
    end
  end

  private

  def process_command(args)
    case args[0]
    when 'I'
      init_image(args[1], args[2])
    when 'L'
      colour_pixel(args[1], args[2], args[3])
    when 'V'
      colour_column(args[1], args[2], args[3], args[4])
    when 'H'
      colour_row(args[1], args[2], args[3], args[4])
    else
      puts 'unrecognised command :('
    end
  end

  def init_image(m, n)
    return if !valid_dimensions([m,n])
    n.to_i.times do
      @image << ["0"]*m.to_i
    end
  end

  def colour_pixel(x, y, c)
    return if !valid_dimensions([x,y]) || !valid_colour(c)
    @image[y.to_i-1][x.to_i-1] = c
  end

  def colour_column(x, y1, y2, c)
    return if !valid_dimensions([x, y1, y2]) || !valid_coords([x], [y1, y2]) || !valid_colour(c)
    y1,y2 = y2,y1 if y1 > y2
    (y1.to_i..y2.to_i).each { |y| @image[y-1][x.to_i-1] = c }
  end

  def colour_row(x1, x2, y, c)
    return if !valid_dimensions([x1, x2, y]) || !valid_coords([x1, x2], [y]) || !valid_colour(c)
    x1,x2 = x2,x1 if x1 > x2
    (x1.to_i..x2.to_i).each { |x| @image[y.to_i-1][x-1] = c }
  end

  def valid_colour(c)
    if !(/[[:upper:]]/.match(c) && c.length == 1)
      puts COLOUR_ERROR
      return false
    end
    true
  end

  def valid_dimensions(ns)
    ns.each do |n|
      # strings.to_i is always 0, so this handles invalid param type
      if !((n.to_i >= 1) && (n.to_i <= 250))
        puts DIMENSION_ERROR
        return false
      end
    end
    true
  end

  def valid_coords(xs, ys)
    columns = @image[0].length
    xs.each do |x|
      if !((x.to_i >= 1) && (x.to_i <= columns))
        puts COORD_ERROR
        return false
      end
    end

    rows = @image.length
    ys.each do |y|
      if !((y.to_i >= 1) && (y.to_i <= columns))
        puts COORD_ERROR
        return false
      end
    end
    true
  end

  def exit_console
    puts 'goodbye!'
    @running = false
  end

  def show_help
    puts "? - Help
    I M N - Create a new M x N image with all pixels coloured white (O).
    C - Clears the table, setting all pixels to white (O).
    L X Y C - Colours the pixel (X,Y) with colour C.
    V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
    H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
    S - Show the contents of the current image
    X - Terminate the session"
  end
end
