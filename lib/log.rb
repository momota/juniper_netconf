require 'logger'

class Log
  def initialize
    @debug_logger  = Logger.new("./log/debug.log", 10)
    @error_logger  = Logger.new("./log/error.log", 10)
  end

  def debug_log( msg )
    @debug_logger.debug msg
    puts msg
  end

  def error_log( msg )
    @error_logger.error msg
    puts msg
  end
end
