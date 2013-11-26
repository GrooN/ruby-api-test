require './web.rb'
require 'multi_json'
 
class App <  Sinatra::Application
	configure do
		# Don't log them. We'll do that ourself
		set :dump_errors, false
 
		# Don't capture any errors. Throw them up the stack
		set :raise_errors, true
 
		# Disable internal middleware for presenting errors
		# as useful HTML pages
		set :show_exceptions, false

		# enable croos origin, so that we can accept request
		# from other hosts
	end
end
 
class ExceptionHandling
	def initialize(app)
		@app = app
	end
 
	def call(env)
		begin
			@app.call env
		rescue => ex
			env['rack.errors'].puts ex
			env['rack.errors'].puts ex.backtrace.join("\n")
			env['rack.errors'].flush
 
			hash = { :message => ex.to_s }
			#hash[:backtrace] = ex.backtrace if RACK_ENV['development']

 
			[500, {'Content-Type' => 'application/json'}, [MultiJson.dump(hash)]]
		end
	end
end
 
use ExceptionHandling
run App