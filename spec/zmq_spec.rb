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

describe ZMQ do

	it "knows what version of the zeromq library it's using" do
		described_class.zeromq_version.should be_an( Array )
		described_class.zeromq_version.should have( 3 ).members
		described_class.zeromq_version.should all_be( Integer )
	end


	it "knows what version of the gem it is" do
		described_class.version_string.should =~ /\w+ [\d.]+/
	end


	it "can include its revision in the version string" do
		described_class.version_string(true).should =~ /\w+ [\d.]+ \(build [[:xdigit:]]+\)/
	end


	it "can select on zmq sockets" do
		ctx = ZMQ::Context.new
		sock1 = ctx.socket( ZMQ::PULL )
		sock1.setsockopt( ZMQ::LINGER, 0 )
		sock1.bind( TEST_RECV_SPEC )
		sock2 = ctx.socket( ZMQ::PUSH )
		sock2.setsockopt( ZMQ::LINGER, 0 )
		sock2.connect( TEST_SEND_SPEC )

		rval = ZMQ.select( nil, [sock2], nil, 0.2 )
		rval.should == [ [], [sock2], [] ]

		sock2.send( "Hi!" ).should be_true()
		
		rval = ZMQ.select( [sock1,sock2], nil, nil, 0.2 )
		rval.should == [ [sock1], [], [] ]

		sock1.recv.should == 'Hi!'

		sock1.close
		sock2.close
		ctx.close
	end

	it "can select on non-zmq sockets" do
		server = Thread.new do
			srv = TCPServer.new( '127.0.0.1', 28813 )
			Thread.current[:ready] = true
			client = srv.accept
			client.puts "Stuff"
			client.shutdown
			srv.close
		end

		sleep 0.1 until server[:ready]

		sock = TCPSocket.new( '127.0.0.1', 28813 )
		rval = ZMQ.select( [sock], nil, nil, 0.2 )
		rval.first.should == [sock]
		sock.read
		sock.close

		server.join
	end

end

