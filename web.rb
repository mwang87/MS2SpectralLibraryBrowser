require 'sinatra'
require 'time'
require 'net/http'
require 'uri'
require 'json'
require 'data_mapper'
require 'dm-transactions'
require './settings'
require './models'
require './utils'

class Sinatra::Application < Sinatra::Base
end

get '/' do
    @libraries = Library.all
    
    haml :index
end


get '/spectra/aggregateview' do
    page_number, @previous_page, @next_page = page_prev_next_utilties(params)
    @page_number = page_number

    @all_libraries = Library.all().map(&:name)

    @query_variant = params[:variant]
    @query_peptide = params[:peptide]
    @query_library = params[:library]

    query_parameters = Hash.new
    query_parameters[:offset]  = (page_number - 1) * PAGINATION_SIZE
    query_parameters[:limit]  = PAGINATION_SIZE
    count_parameters = Hash.new

    @param_string = ""

    if @query_variant != nil and @query_variant.length > 2
        query_parameters[:peptide.like] = "%" + @query_variant + "%"
        @param_string += "&variant=" + @query_variant
    end

    if @query_peptide != nil and @query_peptide.length > 2
       query_parameters[:unmodifiedpeptide.like] = "%" + @query_peptide + "%"
       @param_string += "&peptide=" + @query_peptide
    end
 
    if @query_library != nil and @query_library.length > 2
        query_parameters[:library] = Library.first(:name => @query_library)
        @param_string += "&library=" + @query_library
    end

    puts query_parameters

    @all_spectra = Spectrum.all(query_parameters)
    @total_count = Spectrum.count(count_parameters)

    if (@next_page - 1) * PAGINATION_SIZE > @total_count
        @next_page = nil
    end

    haml :spectra
end

get '/spectrum/:id' do
    @library_spectrum = Spectrum.get(params[:id])
    
    haml :spectrum
end
