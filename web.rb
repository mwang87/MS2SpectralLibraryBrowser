require 'sinatra'
require 'time'
require 'net/http'
require 'uri'
require 'json'
require 'data_mapper'
require 'dm-transactions'
require './settings'
require './models'

class Sinatra::Application < Sinatra::Base
end

get '/' do
    @library_spectra = Spectrum.all(:offset => 0, :limit => 10)
    @library_spectra.to_json
end


get '/spectra' do
    
end