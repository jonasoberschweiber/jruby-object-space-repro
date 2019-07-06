gem 'rake-compiler'

require 'rake/javaextensiontask'

Rake::JavaExtensionTask.new('myext', nil) do |ext|
  jruby_home = RbConfig::CONFIG['prefix']
  ext.ext_dir = 'ext'
  ext.source_version = '1.6'
  ext.target_version = '1.6'
  jars = ["#{jruby_home}/lib/jruby.jar"]
  ext.classpath = jars.map { |x| File.expand_path x }.join(':')
  ext.name = 'my-ext'
end