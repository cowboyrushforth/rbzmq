#!/usr/bin/env rake
#encoding: utf-8

begin
	require 'rake/extensiontask'
rescue LoadError
	abort "This Rakefile requires rake-compiler (gem install rake-compiler)"
end

begin
	require 'hoe'
rescue LoadError
	abort "This Rakefile requires 'hoe' (gem install hoe)"
end

Hoe.plugin :mercurial
Hoe.plugin :signing
Hoe.plugin :deveiate

Hoe.plugins.delete :rubyforge
Hoe.plugins.delete :compiler

$hoespec = Hoe.spec 'zmq' do
	self.readme_file = 'README.rdoc'
	self.history_file = 'History.rdoc'
	self.extra_rdoc_files = Rake::FileList[ '*.rdoc' ]

	self.developer 'Martin Sustrik', 'sustrik@250bpm.com'
	self.developer 'Brian Buchanan', 'bwb@holo.org'

	self.dependency 'simplecov',       '~> 0.6', :developer
	self.dependency 'hoe-deveiate',    '~> 0.1', :developer

	self.spec_extras[:licenses] = ["LGPL"]
	self.spec_extras[:rdoc_options] = ['-f', 'fivefish', '-t', 'Ruby API for ZeroMQ']

	self.hg_sign_tags = true if self.respond_to?( :hg_sign_tags= )
	self.check_history_on_release = true if self.respond_to?( :check_history_on_release= )

	self.rdoc_locations << "deveiate:/usr/local/www/public/code/#{remote_rdoc_dir}"
end

ENV['VERSION'] ||= $hoespec.spec.version.to_s

# Ensure the specs pass before checking in
task 'hg:precheckin' => [:check_manifest, :check_history, :spec]

# Rebuild the ChangeLog immediately before release
task :prerelease => [:check_manifest, :check_history, 'ChangeLog']

task :check_manifest => 'ChangeLog'

# Compile before testing
task :spec => :compile

# gem-testers support
task :test do
	# rake-compiler always wants to copy the compiled extension into lib/, but
	# we don't want testers to have to re-compile, especially since that
	# often fails because they can't (and shouldn't have to) write to tmp/ in
	# the installed gem dir. So we clear the task rake-compiler set up
	# to break the dependency between :spec and :compile when running under
	# rubygems-test, and then run :spec.
	Rake::Task[ EXT.to_s ].clear
	Rake::Task[ :spec ].execute
end

desc "Turn on warnings and debugging in the build."
task :maint do
	ENV['MAINTAINER_MODE'] = 'yes'
end

ENV['RUBY_CC_VERSION'] ||= '1.8.7:1.9.3'

# Rake-compiler task
Rake::ExtensionTask.new do |ext|
	ext.name           = 'zmq_ext'
	ext.gem_spec       = $hoespec.spec
	ext.ext_dir        = 'ext/zmq'
	ext.source_pattern = "*.{c,h}"
	ext.cross_compile  = true
	ext.cross_platform = %w[i386-mingw32]
end

desc "Build a coverage report"
task :coverage do
	ENV["COVERAGE"] = 'yes'
	Rake::Task[:spec].invoke
end

