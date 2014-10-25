require 'sloe/junos'
require 'lib/cfg_file'
require 'lib/log'

class Status
  def initialize(login_info, cfg_filepath)
    @login_info    = login_info
    @cfg_filepath  = cfg_filepath
    @logger        = Log.new
  end

  def get
    status = Hash.new
    begin
      Sloe::Junos.new( @login_info ) do |ssh|
        @logger.debug_log "[#{self.class.name}]: connecting to device: #{@login_info[:target]}"

        show_cmd = CfgFile.new( @cfg_filepath ).read
        @logger.debug_log "[#{self.class.name}]: reading #{@cfg_filepath} done"

        show_cmd.each { |cmd|
          @logger.debug_log "[#{self.class.name}]: execute '#{cmd}'"
          status[cmd] =  ssh.cli( cmd )
        }
      end
    rescue => e
      @logger.error_log "[#{self.class.name}]: exception occured: #{e}"
    else
      status
    end
  end
end
