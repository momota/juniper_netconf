class CfgFile
  def initialize( path )
    @path = path
  end

  def read
    cfg_ary = []
    File.open( @path ) {|f|
      f.each_line { |cfg|
        cmd = cfg.chomp
        if /^(set|delete|show)/ =~ cmd
          cfg_ary << cmd
        end
      }
    }
    cfg_ary
  end

  def write
  end
end

