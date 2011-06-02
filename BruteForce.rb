# Written by Matthew Wean
# MattWean.com

class BruteForce
  attr_accessor :attack_type, :password, :charset, :length, :combinations, :speed
  attr_reader :time
  # Length of a year in seconds
  @@year = 31556926
  def initialize(params)
    # You can pass any of these parameters as a hash when you instantiate a BruteForce object

    @attack_type = params[:attack_type]
    # Choose any of the pre-defined speeds below
    user_gen = params[:user_gen] 
    # Boolean to include decrease in password strength due to predictability of user-generated passwords
    @combinations = params[:combinations]
    @password = params[:password]
    @speed = params[:speed]
    # You can specify your own attempts/second value
    
    if @attack_type
      @attack_type = @attack_type.to_sym
      case @attack_type
      when :Extreme # Multi-GPU or distributed
        @speed = 10000000000
      when :GPU # GPU-based desktop attack
        @speed = 3000000000
      when :desktop # ~Core i7
        @speed = 200000000
      when :online
        @speed = 100
      end
    else  # Default speed if no speed or cracker chosen
      @attack_type = :desktop
      @speed = 200000000
    end

    if @password
      @charset = 0
      # Lowercase
      @charset += 26 if @password.match(/[a-z]/)
      # Uppercase
      @charset += 26 if @password.match(/[A-Z]/)
      # Numbers
      @charset += 10 if @password.match(/\d+/)
      # Symbols
      @charset += 16 if @password.match(/[.,,,!,@,#,$,%,^,&,*,?,_,~,-,(,)]/)

      # Ruby 1.8.7 doesn't support Unicode very well, so I left these out for now
      # Unicode Latin characters
      # @charset += 94 if @password.match(/[^\u0080-\u00FF]+/)
      # @charset += 128 if @password.match(/[^\u0100-\u017F]+/)
      # @charset += 208 if @password.match(/[^\u0180-\u024F]+/)
      # @charset += 32 if @password.match(/[^\u2C60-\u2C7F]+/)
      # @charset += 29 if @password.match(/[^\uA720-\uA7FF]+/)
      # # Unicode Cyrillic characters
      # @charset += 40 if @password.match(/[^\u0500-\u052F]+/)
      # @charset += 74 if @password.match(/[^\uA640-\uA69F]+/)

      @length = @password.length
      @combinations = @charset**@length
    end
    if user_gen == "true"
      case 
      when @length <= 8
        @combinations /= ((@length*6.5546)/(2*@length+2))
      when @length <= 20
        @combinations /= ((@length*6.5546)/(1.5*@length+6))
      else
        @combinations /= ((@length*6.5546)/(@length+16))
      end
    end
    @raw_time = @combinations/@speed.to_f
  end

  def crack_time
    small_names = [
      "minute",
      "hour",
      "day", 
      "month"
    ]
    big_names = [
      "year",
      "thousand years",
      "million years",
      "billion years",
      "trillion years",
      "quadrillion years",
      "quintillion years",
      "septillion years",
      "octillion years",
      "nonillion years",
      "decillion years"
    ]
    small_values = [
      60,
      3600,
      86400,
      2592000,
      @@year
    ]
    big_values = [
      @@year,
      @@year*1000,
      @@year*10**6,
      @@year*10**9,
      @@year*10**12,
      @@year*10**15,
      @@year*10**18,
      @@year*10**21,
      @@year*10**24,
      @@year*10**27,
      @@year*10**30
    ]

    period = "second"
    if @raw_time <= 1
      @time = "#{@raw_time} seconds"
    elsif @raw_time < 60
      @raw_time = @raw_time.floor
      @time = "about #{@raw_time} seconds"
    elsif @raw_time < @@year
      small_values.size.times do |i|
        if @raw_time < small_values[i+1]
          new_time = (@raw_time/small_values[i]).round
          @time = "about #{new_time} #{small_names[i]}"
          @time += "s" if new_time != 1
          break
        end
      end
    else
      i = 0
      big_values.each do |v|
        if @raw_time < v*999
          new_time = (@raw_time/v).round
          @time = "about #{new_time} #{big_names[i]}"
          @time += "s" if i == 0 and new_time != 1
          break
        else
          @time = "more than 1,000,000,000,000,000,000,000,000,000,000,000,000 years"
        end
        i += 1
      end
    end
    return @time
  end

  def chance_of_failure(years)
    chance = ((years*@@year*@speed)/@combinations.to_f)*100
    chance = 100 if chance > 100
    return sprintf("%.2f%", chance)
  end
end