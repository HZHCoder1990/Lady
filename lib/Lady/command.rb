require 'claide'
require 'colored2'
require 'rest-client'
require 'json'

module Lady

  class Command < CLAide::Command

    # 导入子命令
    require 'Lady/command/download'

    self.abstract_command = true
    # 和可执行程序同名
    self.command = 'lady'
    self.version = VERSION
    self.description = "通过抖音分享链接下载小姐姐视频"

    def self.options
      []
    end

  end

end