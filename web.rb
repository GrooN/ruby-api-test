require 'rubygems'
require 'sinatra'
require 'json'

require 'data_mapper'

before do
	content_type 'application/json'
end

DataMapper.setup :default, {
  :adapter  => 'postgres',
  :host     => 'ec2-54-204-2-217.compute-1.amazonaws.com',
  :database => 'd86invmlbks028',
  :user     => 'jnkyeplxyoxccr',
  :password => 'T8mzTJAvZW_76d2t3emuEp7AnC'
}

class Company
	include DataMapper::Resource

	property :company_id,	Serial
	property :name, 		Text, :required => true
	property :address,		Text, :required => true
	property :city,			Text, :required => true
	property :country,		Text, :required => true
	property :email,		Text
	property :phone_number,	Text

	property :owners, 		Text # one or more directors and beneficial owners

	property :created_at, 	DateTime
	property :updated_at, 	DateTime

	def to_json(*a)
		{
			'company_id' => self.company_id,
			'name' => self.name,
			'address' => self.address,
			'city' => self.city,
			'country' => self.country,
			'email' => self.email,
			'phone_number' => self.phone_number
		}.to_json(*a)
	end
end

DataMapper.finalize
Company.auto_upgrade!

# get details about a company
get '/company/:id' do
  Company.get(params[:id]).to_json
end

# list companies
get '/company' do
	companies = Company.all()
	halt 404 if companies.nil?
	companies.to_json
end

# update company
put '/company/:id' do
	data = JSON.parse(request.body.read)
	halt 400 if data.nil?

	company = Company.get(params[:id])
	halt 404 if company.nil?

	%w(name address city country email phone_number).each do |key|
		if !data[key].nil? && data[key] != company[key]
			company[key] = data[key]
			company['updated_at'] = Time.now.utc
		end
	end

	halt 500 unless company.save
  	
  	company.to_json
end

# create company
post '/company' do
	data = JSON.parse(request.body.read)

	attributes = {
		:name => data['name'],
		:address => data['address'],
		:city => data['city'],
		:country => data['country']
	}

	company = Company.create(attributes)

	halt 500 unless company.save

	[201, {'Location' => "/company/#{company.company_id}"}, company.to_json]
end

get '/client' do
	content_type 'text/html'
	File.read(File.join('client', 'index.html'))
end

