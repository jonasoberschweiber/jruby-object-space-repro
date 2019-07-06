require File.join(File.dirname(__FILE__), 'lib/my-ext.jar')
Java::com.oberschweiber.MyRubyLoader

# Check whether MyRubyObject is part of the object space
ObjectSpace.each_object(Module) do |mod_|
  if mod_.name == 'Java::ComOberschweiber::MyRubyLoader::MyRubyObject'
    puts 'In object space!'
  end
end

klass = Java::ComOberschweiber::MyRubyLoader::MyRubyObject
puts klass.constants.inspect
if klass.constants.include?(:NEVER)
  puts 'NEVER included in constants'
end

puts 'Trying to access never'
never = klass.const_get(:NEVER)
puts never

# klass = Java::ComOberschweiber::MyRubyLoader::MyRubyObject
# puts klass.constants.inspect

# klass = Java::com.oberschweiber.MyRubyObject

# puts "Constants using instance method"
# puts klass.constants.inspect

# real_constants = Module.instance_method(:constants)
# all_constants = real_constants.bind(klass).call
# puts "Constant using bind"
# puts all_constants.inspect

# all_constants.each do |constant|
#   puts "Trying to get constant #{constant}"
#   puts klass.const_get(constant).inspect
# end