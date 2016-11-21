DIMENSION_ERROR = "ERROR: each dimension of the image must be between 1 and 250"
COLOUR_ERROR = "ERROR: colour must be a capital letter"
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
    else
      puts 'unrecognised command :('
    end
  end

  def init_image(m, n)
    if !valid_coord(m) || !valid_coord(n)
      puts DIMENSION_ERROR
      return
    end
    n.to_i.times do
      @image << ["0"]*m.to_i
    end
  end

  def colour_pixel(x, y, c)
    if !valid_coord(x) || !valid_coord(y)
      puts DIMENSION_ERROR
      return
    end
    puts COLOUR_ERROR and return if !is_capital_letter(c)
    @image[y.to_i-1][x.to_i-1] = c
  end

  def colour_column(x, y1, y2, c)
    if !valid_coord(x) || !valid_coord(y1) || !valid_coord(y2)
      puts DIMENSION_ERROR
      return
    end
    puts COLOUR_ERROR and return if !is_capital_letter(c)
    (y1.to_i..y2.to_i).each { |y| @image[y-1][x.to_i-1] = c }
  end

  def valid_coord(n)
    # strings.to_i is always 0, so this handles invalid param type
    (n.to_i >= 1) && (n.to_i <= 250)
  end

  def is_capital_letter(c)
    /[[:upper:]]/.match(c) && c.length == 1
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
