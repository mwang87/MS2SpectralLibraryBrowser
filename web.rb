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
    @libraries = Library.all
    
    haml :index
end


get '/spectra/library/:libraryid' do
    page_number = 1
    if params[:page] != nil
        page_number = params[:page].to_i
    end
    
    library_db = Library.first(params[:libraryname])
    
    
    @library_spectra = library_db.spectrum.all(:offset => (page_number - 1) * PAGINATION_SIZE , :limit => PAGINATION_SIZE)
    
    #Determining next and prev page
    if page_number == 1
        @next_page = page_number + 1
        @previous_page = nil
    else
        @next_page = page_number + 1
        @previous_page = page_number - 1
    end
    
    @request_path = request.path
    @param_string = ""
    
    @display_string = "Library View: " + library_db.name
    
    haml :spectra
end


get '/spectrum/:id' do
    @library_spectrum = Spectrum.get(params[:id])
    
    haml :spectrum
end

get '/spectra/querysequence' do
    query_peptide = params[:sequence]
    
    page_number = 1
    if params[:page] != nil
        page_number = params[:page].to_i
    end
    
    query_peptide =  "%" + query_peptide + "%"
    
    @library_spectra = Spectrum.all(:offset => (page_number - 1) * PAGINATION_SIZE, :limit => PAGINATION_SIZE, :unmodifiedpeptide.like => query_peptide)
    
    #Determining next and prev page
    if page_number == 1
        @next_page = page_number + 1
        @previous_page = nil
    else
        @next_page = page_number + 1
        @previous_page = page_number - 1
    end
    
    @param_string = "sequence="  + params[:sequence]
    @request_path = request.path
    
    @display_string = "Sequence Query: " + params[:sequence]
    
    haml :spectra
end

get '/spectra/querypeptide' do
    query_peptide = params[:sequence]
    
    page_number = 1
    if params[:page] != nil
        page_number = params[:page].to_i
    end
    
    query_peptide =  "%" + query_peptide + "%"
    
    @library_spectra = Spectrum.all(:offset => (page_number - 1) * PAGINATION_SIZE, :limit => PAGINATION_SIZE, :peptide.like => query_peptide)
    
    #Determining next and prev page
    if page_number == 1
        @next_page = page_number + 1
        @previous_page = nil
    else
        @next_page = page_number + 1
        @previous_page = page_number - 1
    end
    
    @param_string = "sequence="  + params[:sequence]
    @request_path = request.path
    
    @display_string = "Peptide Query: " + params[:sequence]
    
    haml :spectra
end
