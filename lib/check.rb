require 'net/netcong/jnpr'
require 'junos-ez/stdlib'
require 'lib/cfg_file'
require 'lib/log'

class Check
  def initialize(login_info, cfg_filepath)
    @login_info    = login_info
    @cfg_filepath  = cfg_filepath
    @logger        = Log.new
  end

  def execute
    begin
      ndev = Netconf::SSH.new( @login_info )

      @logger.debug_log "[#{self.class.name}]: connecting to device: #{@login_info[:target]}"
      ndev.open
      @logger.debug_log "[#{self.class.name}]: connected"
      

    rescue => e
      @logger.error_log "[#{self.class.name}]: exception occured: #{e}"
    else
      status
    end
  end






    status = Hash.new
    begin
      Sloe::Junos.new( @login_info ) do |ssh|

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
