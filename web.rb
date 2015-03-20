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
    page_number = 1
    if params[:page] != nil
        page_number = params[:page].to_i
    end
    @library_spectra = Spectrum.all(:offset => (page_number - 1) * PAGINATION_SIZE , :limit => PAGINATION_SIZE)
    
    #Determining next and prev page
    if page_number == 1
        @next_page = page_number + 1
        @previous_page = nil
    else
        @next_page = page_number + 1
        @previous_page = page_number - 1
    end
    
    haml :spectra
end

get '/spectrum/:id' do
    @library_spectrum = Spectrum.get(params[:id])
    @library_spectrum.to_json
end

get '/spectra/sequence/:querysequence' do
    query_peptide = params[:querysequence]
    
    page_number = 1
    if params[:page] != nil
        page_number = params[:page].to_i
    end
    
    
    @library_spectra = Spectrum.all(:offset => (page_number - 1) * PAGINATION_SIZE, :limit => PAGINATION_SIZE, :unmodifiedpeptide => query_peptide)
    
    
    #Determining next and prev page
    if page_number == 1
        @next_page = page_number + 1
        @previous_page = nil
    else
        @next_page = page_number + 1
        @previous_page = page_number - 1
    end
    
    haml :spectra
end

get '/spectra/peptide/:querypeptide' do
    query_peptide = params[:querypeptide]
    
    page_number = 1
    if params[:page] != nil
        page_number = params[:page].to_i
    end
    
    @library_spectra = Spectrum.all(:offset => (page_number - 1) * PAGINATION_SIZE, :limit => PAGINATION_SIZE, :peptide => query_peptide)
    
    #Determining next and prev page
    if page_number == 1
        @next_page = page_number + 1
        @previous_page = nil
    else
        @next_page = page_number + 1
        @previous_page = page_number - 1
    end
    
    haml :spectra
    
end