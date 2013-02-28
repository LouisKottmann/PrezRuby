class LogProxy
  def initialize(proxy_target)
    @target = proxy_target
  end

  def method_missing(name, *args, &block)
    if @target.respond_to? name
      puts "Called '#{name}' with arguments: #{args} on #{@target.class}"
      @target.send(name, *args, &block)
    else
      puts 'Method not defined!'
      super
    end
  end
end

array = [0, 1, 2]
loggedArray = LogProxy.new(array)

puts loggedArray.first
puts loggedArray.last
puts loggedArray.middle