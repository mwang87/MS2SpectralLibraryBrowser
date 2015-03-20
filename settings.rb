require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/data.db")
