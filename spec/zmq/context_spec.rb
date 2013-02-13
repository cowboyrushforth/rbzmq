# -*- ruby -*-
# encoding: utf-8
# vim: set nosta noet ts=4 sw=4:

require 'rspec'
require 'zmq'
require 'helpers'
require 'socket'

#####################################################################
###	C O N T E X T S
#####################################################################

describe ZMQ::Context do

	it "can be created without specifying a thread pool size" do
		ctx = described_class.new
		ctx.should be_a( described_class )
	end

	it "can be created with a thread pool size of 0 (for in-proc transports)" do
		ctx = described_class.new( 0 )
		ctx.should be_a( described_class )
	end

	it "can be created with a thread pool size of >1" do
		ctx = described_class.new( 8 )
		ctx.should be_a( described_class )
	end


	describe "instances" do
	
		before( :each ) do
			@ctx = described_class.new
		end


		it "can be closed" do
			@ctx.close
		end
		
		it "can be closed more than once safely" do
			@ctx.close
			@ctx.close
		end

		it "can be used to create sockets" do
			@ctx.socket( ZMQ::PUSH ).should be_a( ZMQ::Socket )
		end
		
	end

end

