module Lady

  HEADERS = {
    'Accept' => '*/*',
    'Accept-Language' => 'zh-CN,zh;q=0.8,gl;q=0.6,zh-TW;q=0.4',
    'User-Agent' => 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.181 Mobile Safari/537.36'
  }

  ANALYSE_PREFIX = 'https://api.cooluc.com/?url='.freeze

  class Download < Command
    self.summary = "下载抖音视频"
    self.description = "解析分享链接并将下载视频到本地"

    self.arguments = [
      CLAide::Argument.new("link", true)
    ]
    def initialize(argv)
      @link = argv.shift_argument
      # @save_path = argv.flag?('save-path')
      super
    end

    def run
      # 1.匹配下载链接
      urls = match_url(@link)
      unless urls.empty?
        # 2.解析下载链接
        response = RestClient.get(ANALYSE_PREFIX + urls[0] , HEADERS)
        json_obj =  JSON.parse(response)
        nickname = json_obj['nickname'] ||= 'temp'
        #puts json_obj
        video_url =  json_obj['video']
        if video_url.length > 0
          # 3.下载
          video_data = RestClient.get(video_url)
          mkdir = FileUtils.mkdir_p('/Users/mac/Desktop/video')[0]
          # 4.写入本地
          file = File.open("#{mkdir}/#{nickname}.mp4", 'a+')
          if file
            puts "保存成功!".green
            file.syswrite(video_data)
          end
        end
      end
    end

    def match_url(string)
      urls = []
      regular = Regexp.new('http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+')
      string.scan(regular) do |url|
        urls << url
      end
      urls
    end

    def validate!
      super
      unless @link
        help! "link is necessary!"
      end
    end

  end

end