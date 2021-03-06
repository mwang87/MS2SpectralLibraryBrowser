require 'data_mapper'

PAGINATION_SIZE = 30

puts ENV["RACK_ENV"]
configure :test do
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/data.db")
	#DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/spectrallibrarybrowser' )
end
configure :development do
    DataMapper.setup(:default, ENV['DATABASE_URL'] )
end
configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'] )
end

