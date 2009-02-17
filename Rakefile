require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'rubyforge'

SPEC = Gem::Specification.new do |s|
   s.name               = 'acts_as_nice_url'
   s.version            = '2.0.1'
   s.authors            = ['Nicolas Cavigneaux']
   s.email              = 'nico@bounga.org'
   s.homepage           = 'http://www.bitbucket.org/Bounga/acts_as_nice_url'
   s.rubyforge_project  = %q{nice-url}
   s.summary            = 'A Ruby on Rails extension to generate pretty URLs from models data '
   s.description        = 'This Ruby on Rails acts_as extension provides the capabilities for creating a nice url based on an attribute of the current object. You can set / unset the object id in front of the URL and choose the object attribute to use to generate the URL.'
   s.files              = [ "Rakefile", "init.rb", "install.rb", "README", "LICENSE", "uninstall.rb" ] +
                          Dir.glob("{bin,assets,doc,lib,tasks,test}/**/*")
   s.test_file          = "test/nice_url_test.rb"
   s.has_rdoc           = true
   s.extra_rdoc_files   = ['README']
   s.require_paths      = ["lib"]
   s.add_dependency('activerecord', '>=2.2.0')
end

desc 'run unit tests'
task :default => :test

task :gem
Rake::GemPackageTask.new(SPEC) do |pkg|
  pkg.need_zip = true
  pkg.need_tar_bz2 = true
end

desc "Install gem file #{SPEC.name}-#{SPEC.version}.gem"
task :install => [:gem] do
  sh "gem install pkg/#{SPEC.name}-#{SPEC.version}.gem"
end

desc "Publish documentation to RubyForge"
task :publish_doc => [:rdoc] do
  rf = Rake::RubyForgePublisher.new(SPEC.rubyforge_project, 'bounga')
  rf.upload
  puts "Published documentation to RubyForge"
end

desc "Release gem #{SPEC.name}-#{SPEC.version}.gem"
task :release => [:gem, :publish_doc] do
  rf = RubyForge.new.configure
  puts "Logging in"
  rf.login

  puts "Releasing #{SPEC.name} v.#{SPEC.version}"

  files = Dir.glob('pkg/*.{zip,bz2,gem}')
  rf.add_release SPEC.rubyforge_project, SPEC.rubyforge_project, SPEC.version, *files
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.title    = 'Acts_as_nice_url'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
