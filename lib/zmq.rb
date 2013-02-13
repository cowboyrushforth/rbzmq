# -*- ruby -*-
#encoding: utf-8

begin
	require 'zmq_ext'
rescue LoadError
	# If it's a Windows binary gem, try the <major>.<minor> subdirectory
	if RUBY_PLATFORM =~/(mswin|mingw)/i
		major_minor = RUBY_VERSION[ /^(\d+\.\d+)/ ] or
			raise "Oops, can't extract the major/minor version from #{RUBY_VERSION.dump}"
		require "#{major_minor}/zmq_ext"
	else
		raise
	end

end


# ZeroMQ binding for Ruby.
module ZMQ

	# Gem version
	VERSION = '3.0.0'

	# Version-control revision constant
	REVISION = %q$Revision$


	### Get the Treequel version.
	def self::version_string( include_buildnum=false )
		vstring = "%s %s" % [ self.name, VERSION ]
		vstring << " (build %s)" % [ REVISION[/: ([[:xdigit:]]+)/, 1] || '0' ] if include_buildnum
		return vstring
	end
	
end # module ZMQ

