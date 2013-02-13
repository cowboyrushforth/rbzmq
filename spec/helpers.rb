# -*- ruby -*-
#encoding: utf-8

require 'rspec'
require 'zmq'


module ZMQ::SpecHelpers


	# A collection of constants to use in testing.
	module TestConstants

		# 0mq socket specifications for Handlers
		TEST_SEND_SPEC = 'inproc://zmq-spec-socket'
		TEST_RECV_SPEC = 'inproc://zmq-spec-socket'
		
	end # module TestConstants


    ### A type matcher for collections.
	class AllBeMatcher

		def initialize( expected_class )
			@expected_class = expected_class
		end

		def matches?( actual )
			@actual = actual
			return actual.all? {|obj| obj.is_a?(@expected_class) }
		rescue NoMethodError => ex
			return false
		end

		def description
			"to all be instances of %p" % [ @expected_class ]
		end

		def failure_message
			"but got %p (%p)" % [ 
				@actual.map( &:class ),
				@actual
			]
		end

	end # class AllBeMatcher


	###############
	module_function
	###############

	### Return true if the actual value includes the specified +objects+.
	def all_be( expected_class )
		AllBeMatcher.new( expected_class )
	end

end # module ZMQ::SpecHelpers


### Mock with RSpec
RSpec.configure do |c|
	include ZMQ::SpecHelpers::TestConstants

	c.mock_with( :rspec )

	c.include( ZMQ::SpecHelpers )
end

