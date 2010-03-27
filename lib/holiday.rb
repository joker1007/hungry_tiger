# calendar/japanese/holiday.rb

require 'nkf'

# ユーティリティ群
module Util
  # 日付操作のユーティリティ
  module DateTimeUtil
    # +a+ と +b+ が同じ日付かどうかを判定
    def DateTimeUtil.equals_date(a, b)
      return (a.year == b.year and a.month == b.month and a.day == b.day)
    end

    # 曜日を算出する
    # Since:: 1.1
    def DateTimeUtil.wday(date)
      return date.wday if defined?(date.wday)
      # Zeller(ツェラー)の公式 1583年から3999年まで
      year = date.year
      month = date.month
      day = date.day
#      raise "year 1583-3999 [#{year}]" if year < 1583 or year > 3999
      if month == 1 or month == 2
        month += 12
        year -= 1
      end
      # 西暦を上下二桁ずつに分解
      head = (year / 100).to_i
      tail = year - 100 * head
      return ((head / 4).to_i - 2 * head + tail + (tail / 4).to_i + (2.6 * (month + 1)).to_i + day - 1) % 7 
    end
  end

  # プラットフォームに関するユーティリティ
  # Since:: 1.1
  module PlatformUtil
    @@charcode = nil

    # ネイティブの文字コードを判定する
    # Warning:: このメソッドのロジックはびっくりするくらい適当です
    def PlatformUtil.default_charcode
      return @@charcode unless @@charcode.nil?
      @@charcode = "euc"
      if /win32|cygwin|mingw|darwin|hpux|aix|bccwin/ =~ RUBY_PLATFORM
        @@charcode = "sjis"
      end
      return @@charcode
    end
  end
end

module Calendar
  module Japanese

    # 日本の祝日を扱うモジュール
    module Holiday
      # 休日情報オブジェクト
      class HolidayInfo
        def initialize(date)
          @date = date
          @is_national = false
          @name = ""
          @is_substitute = false
        end
        # 日付オブジェクト
        attr_accessor :date
        # 祝日かどうか
        attr_accessor :is_national
        # 祝日名
        attr_accessor :name
        # 振替休日かどうか
        attr_accessor :is_substitute
      end

      # 日付 +date+ に関する祝日情報オブジェクト (HolidayInfo) を取得する
      def Holiday.holiday_info(date)
        holiday_info = Holiday.national_holiday_info(date)
        if !holiday_info.is_national
          holiday_info.is_substitute = Holiday.check_substitute_holiday(date)
        end
        return holiday_info
      end

      # 休日かどうかを返す
      def holiday?
        return (weekend? or national_holiday? or substitute_holiday?)
      end

      # 祝日名を返す
      def holiday
        return get_holiday_info.name
      end

      # 土日かどうかを返す
      def weekend?
        weekday = Util::DateTimeUtil.wday(self)
        return (weekday == 0 or weekday == 6)
      end

      # 国民の祝日かどうかを返す
      def national_holiday?
        return get_holiday_info.is_national
      end

      # 振り替え休日かどうかを返す
      def substitute_holiday?
        return get_holiday_info.is_substitute
      end

      # NKF の実行オプションを設定する
      # Since:: 1.1
      def Holiday.set_nkf_opts opts
        @@nkf_opts = opts
      end

      private

      # NKF の実行オプション
      @@nkf_opts = nil

      # NKF の実行オプションを返す
      def nkf_opts
        unless @@nkf_opts.nil?
          @@nkf_opts = "" if @@nkf_opts == "-s"
          return @@nkf_opts
        end
        if "euc" == Util::PlatformUtil.default_charcode
          @@nkf_opts = "-e"
        else
          @@nkf_opts = ""
        end
        return @@nkf_opts
      end

      # str を適切な文字コードに変換して返す
      def get_nkf_text str
        if !str.empty? and !nkf_opts.empty?
          return NKF.nkf("-S #{nkf_opts}", str)
        end
        return str
      end

      # date から国民の祝日情報が設定された HolidayInfo オブジェクトを生成する
      def Holiday.national_holiday_info(date)
        info = HolidayInfo.new(date)
        case date.month
        when 1
          if date.year <= 1948
            if date.day == 3
              info.name = "元始祭"
            elsif date.day == 5
              info.name = "新年宴會"
            elsif date.year < 1913 and date.day == 30
              info.name = "孝明天皇祭"
            end
          elsif date.year < 2000
            if date.day == 1
              info.name = "元日"
            elsif date.day == 15
              info.name = "成人の日"
            end
          else
            if date.day == 1
              info.name = "元日"
            elsif date.day >= 8 and date.day <= 14 and Util::DateTimeUtil.wday(date) == 1 and date.year > 1999
              info.name = "成人の日"
            end
          end
        when 2
          if date.year <= 1948
            if date.day == 11
              info.name = "紀元節"
            end
          elsif date.year > 1966
            if date.day == 11
              info.name = "建国記念の日"
            elsif date.year == 1989
              if date.day == 24
                info.name = "大喪の礼"
              end
            end
          end
        when 3
          if date.year <= 1948
            if date.year >= 1900 and date.day == (date.year * 0.24242 - date.year / 4 + 35.84).to_i
              info.name = "春季皇靈祭"
            end
          else
            if date.year <= 2099 and date.day == (date.year * 0.24242 - date.year / 4 + 35.84).to_i
              info.name = "春分の日"
            end
          end
        when 4
          if date.year <= 1948
            if date.day == 3
              info.name = "神武天皇祭"
            elsif date.day == 29 and date.year > 1926
              info.name = "天長節"
            end
          elsif date.year == 1959 and date.day == 10
            info.name = "明仁親王結婚の儀"
          elsif date.year < 1989
            info.name = "天皇誕生日" if date.day == 29
          elsif date.year < 2007
            info.name = "みどりの日" if date.day == 29
          else
            info.name = "昭和の日" if date.day == 29
          end
        when 5
          if date.year > 1948
            if date.day == 3
              info.name = "憲法記念日"
            elsif date.day == 5
              info.name = "こどもの日"
            end
            if date.year < 2007
              if date.year > 1985 and date.day == 4 and Util::DateTimeUtil.wday(date) > 1
                info.name = "国民の休日"
              end
            else
              info.name = "みどりの日" if date.day == 4
            end
          end
        when 6
          if date.day == 9 and date.year == 1993
            info.name = "徳仁親王結婚の儀"
          end
        when 7
          if date.year < 1926 and date.year > 1912
            if date.day == 30
              info.name = "明治天皇祭"
            end
          elsif date.year > 1995
            if date.year < 2003
              info.name = "海の日" if date.day == 20
            elsif date.day >= 15 and date.day <= 21 and Util::DateTimeUtil.wday(date) == 1
              info.name = "海の日"
            end
          end
        when 8
          if date.year < 1926 and date.year > 1912
            if date.day == 31
              info.name = "天長節"
            end
          end
        when 9
          if date.year < 1948
            if date.year < 1879 and date.day == 17
              info.name = "神嘗祭"
            elsif date.year >= 1900 and date.day == (date.year * 0.24204 - date.year / 4 + 39.01).to_i
              info.name = "秋季皇靈祭"
            end
          else
            if date.year <= 2099 and date.day == (date.year * 0.24204 - date.year / 4 + 39.01).to_i
              info.name = "秋分の日"
            elsif date.year > 1965
              if date.year < 2003
                info.name = "敬老の日" if date.day == 15
              elsif date.day >= 15 and date.day <= 21 and Util::DateTimeUtil.wday(date) == 1
                info.name = "敬老の日"
              elsif date.day >= 16 and date.day <= 22 and Util::DateTimeUtil.wday(date) == 2 and 
                  date.year <= 2099 and (date.day + 1) == (date.year * 0.24204 - date.year / 4 + 39.01).to_i
                info.name = "国民の休日"
              end
            end
          end
        when 10
          if date.year <= 1947
            if date.year >= 1879 and date.day == 17
              info.name = "神嘗祭"
            elsif date.year < 1927 and date.year > 1912
              info.name = "天長節祝日" if date.day == 31
            end
          elsif date.year > 1965
            if date.year < 2000
              if date.day == 10
                info.name = "体育の日"
              end
            else
              if date.day >= 8 and date.day <= 14 and Util::DateTimeUtil.wday(date) == 1
                info.name = "体育の日"
              end
            end
          end
        when 11
          if date.year <= 1947
            if date.day == 23
              info.name = "新嘗祭"
            elsif date.year == 1915
              case date.day
              when 10
                info.name = "即位ノ禮"
              when 14
                info.name = "大嘗祭"
              when 16
                info.name = "即位禮及大嘗祭後大饗第一日"
              end
            elsif date.year < 1912
              info.name = "天長節" if date.day == 3
            elsif date.year > 1926
              if date.year == 1928
                case date.day
                when 10
                  info.name = "即位ノ禮"
                when 14
                  info.name = "大嘗祭"
                when 16
                  info.name = "即位禮及大嘗祭後大饗第一日"
                end
              else
                info.name = "明治節" if date.day == 3
              end
            end
          else
            if date.day == 3
              info.name = "文化の日"
            elsif date.day == 23
              info.name = "勤労感謝の日"
            elsif date.day == 12 and date.year == 1990
              info.name = "即位礼正殿の儀"
            end
          end
        when 12
          if date.year <= 1947
            if date.year > 1926
              if date.day == 25
                info.name = "大正天皇祭"
              end
            end
          elsif date.year > 1988
            if date.day == 23
              info.name = "天皇誕生日"
            end
          end
        else
        end
        info.is_national = !info.name.empty?
        return info
      end

      # date が振替休日かどうかを判定する
      def Holiday.check_substitute_holiday(date)
        if Util::DateTimeUtil.wday(date) == 0 or Util::DateTimeUtil.wday(date) == 6
          return false
        end
        if (date.year < 1973 or (date.year == 1973 and date.month < 3))
          return false
        end
        substitute = false
        a_date = date
        loop do
          unless Holiday.national_holiday_info(a_date - 1).is_national
            break
          end
          if Util::DateTimeUtil.wday(a_date - 1) == 0
            substitute = true
            break
          end
          a_date -= 1
          break if date.year < 2007
        end
        return substitute
      end

      # 休日情報を取得する
      def get_holiday_info
        if @holiday_info.nil? or !Util::DateTimeUtil.equals_date(self, @holiday_info.date)
          @holiday_info = Holiday.holiday_info(self)
          @holiday_info.name = get_nkf_text(@holiday_info.name)
        end
        return @holiday_info
      end

    end # class Holiday
  end # module Japanese
end # module Calendar

#require 'date'
#
#class Date
#  include Calendar::Japanese::Holiday
#end
#
#class DateTime
#  include Calendar::Japanese::Holiday
#end
#
#class Time
#  include Calendar::Japanese::Holiday
#end
#
#if $0 == __FILE__
#  puts Time.now.extend(Calendar::Japanese::Holiday).holiday
#end
