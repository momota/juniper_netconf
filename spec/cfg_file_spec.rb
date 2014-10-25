require "rspec"
require "cfg_file"

describe CfgFile do
  it "should be exit reading file" do
  end

  it "should read detect line with starting 'show'" do
    cfg_file = CfgFile.new("./cfg/show_cmd.txt")
    cfg_file.read == true
  end
end
