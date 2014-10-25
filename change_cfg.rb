$LOAD_PATH.push(".")
require 'yaml'
require 'lib/commit'
require 'lib/status'

class ChangeCfg
  def initialize(node, cfg_filepath)
    @node = node

    @node_filepath = "./node/#{@node}.yml"
    @commit_cfg_filepath  = cfg_filepath
    @show_cfg_filepath    = "./cfg/show_cmd.txt"
    

    node_info = YAML.load( File.read( @node_filepath ) )
    @login_info = {
      # When you execute this script on production environment, you need to fix
      # "development" ---> "production"
      :target     => node_info["network_node"]["development"]["ip_addr"],
      :username   => node_info["network_node"]["development"]["username"],
      :password   => node_info["network_node"]["development"]["password"]
    }
  end

  # ------------------------------------------------------------------
  # change JUNIPER configuration
  def execute
    # status check before commit
    before_status = Status.new(@login_info, @show_cfg_filepath).get
    save( before_status )

    # configuration and commit
    Commit.new(@login_info, @commit_cfg_filepath).execute

    # status check after commit
    after_status = Status.new(@login_info, @show_cfg_filepath).get
    save( after_status )
  end

  def save( data )
    out_filepath = "./output/#{Time.now.strftime("%Y%m%d_%H%M%S")}_#{@node}.txt"
    File.open(out_filepath, "w") { |f|
      data.each { |k, v| f.write("#{k}\n#{v}\n") }
    }
  end
end


# ------------------------------------------------------------------
# MAIN
if __FILE__ == $0
  node         = ARGV[0] || "DEFAULT_HOSTNAME" 
  cfg_filepath = ARGV[1] || "./cfg/default_set.txt"
  puts "execute 'ruby change_cfg.rb #{node} #{cfg_filepath}'"
  ChangeCfg.new(node, cfg_filepath).execute
end
