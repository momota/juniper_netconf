require 'net/netconf/jnpr'
require 'lib/cfg_file'
require 'lib/log'


class Commit
  def initialize(login_info, cfg_filepath)
    @login_info    = login_info
    @cfg_filepath  = cfg_filepath
    @logger        = Log.new
  end

  def execute
    @logger.debug_log "[#{self.class.name}]: connecting to device: #{@login_info[:target]}"
    Netconf::SSH.new( @login_info ) { |dev|
      @logger.debug_log "[#{self.class.name}]: connected"

      conf = []
      conf = CfgFile.new( @cfg_filepath ).read
      @logger.debug_log "[#{self.class.name}]: reading #{@cfg_filepath} done"

      begin
        rsp = dev.rpc.lock_configuration
        @logger.debug_log "[#{self.class.name}]: locked configuration"

        rsp = dev.rpc.load_configuration(conf, :format => "set")
        rpc = dev.rpc.check_configuration
        rpc = dev.rpc.commit_configuration

        rpc = dev.rpc.unlock_configuration
        @logger.debug_log "[#{self.class.name}]: unlocked configuration"

      rescue Netconf::LockError => e
        @logger.error_log "[#{self.class.name}]: Lock Error: #{e}"
      rescue Netconf::EditError => e
        @logger.error_log "[#{self.class.name}]: Edit error: #{e}"
      rescue Netconf::ValidateError => e
        @logger.error_log "[#{self.class.name}]: Validate Error #{e}:"
      rescue Netconf::CommitError => e
        @logger.error_log "[#{self.class.name}]: Commit error: #{e}"
      rescue Netconf::RpcError => e
        @logger.error_log "[#{self.class.name}]: Rpc error: #{e}"
      else
        @logger.debug_log "[#{self.class.name}]: configuration committed."
      end
    }
  end
end

