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

describe ZMQ::Socket do

	before( :all ) do
		@context = ZMQ::Context.new
	end

	after( :all ) do
		@context.close
	end


	it "can't be instantiated directly" do
		expect {
			described_class.new
		}.to raise_error( TypeError, /allocator/i )
	end


	describe "instances" do
	
		before( :each ) do
			@socket = @context.socket( ZMQ::PUSH )
		end

		after( :each ) do
			@socket.setsockopt( ZMQ::LINGER, 0 )
			@socket.close
		end


		it "allow socket options to be fetched" do
			@socket.getsockopt( ZMQ::TYPE ).should == ZMQ::PUSH
		end

		it "allow socket options to be set" do
			@socket.setsockopt( ZMQ::IDENTITY, 'notices' )
			@socket.getsockopt( ZMQ::IDENTITY ).should == 'notices'
		end

		it "can bind to (listen on) an endpoint" do
			@socket.bind( TEST_RECV_SPEC )
		end

	end

	describe "a pair of PUSH/PULL instances" do

		before( :each ) do
			@push = @context.socket( ZMQ::PUSH )
			@pull = @context.socket( ZMQ::PULL )
		end

		after( :each ) do
			@push.setsockopt( ZMQ::LINGER, 0 )
			@push.close
			@pull.setsockopt( ZMQ::LINGER, 0 )
			@pull.close
		end


		it "can send and receive messages" do
			@pull.bind( TEST_RECV_SPEC )
			@push.connect( TEST_SEND_SPEC )

			@push.send( 'some stuff' )
			sleep 0.1 until ( @pull.getsockopt(ZMQ::EVENTS) & ZMQ::POLLIN ).nonzero?
			@pull.recv.should == 'some stuff'
		end
		
	end

end

