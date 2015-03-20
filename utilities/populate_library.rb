#!/usr/bin/env ruby

require 'json'
require './settings'
require './models'

#Parses an MGF spectral library. See Ming about this stuff.
def parse_mgf_library(library_name)
    spectra_object = nil
    peaks_list = []
    
    File.open(library_name, "r").each_line do |line|
        if line.include? "BEGIN IONS"
            spectra_object = Spectrum.new
            peaks_list = []
            next
        end
        
        if line.include? "END IONS"
            puts "SAVING " + spectra_object.peptide
            spectra_object.peaks = peaks_list.to_json
            spectra_object.save
            next
        end
        
        if line.include? "="
            field = line.split("=")[0]
            value = line.split("=")[1].rstrip
            
            if field == "CHARGE"
                spectra_object.charge = Integer(value.gsub(/[+]/,''))
            end
            
            if field == "SEQ"
                spectra_object.peptide = value
                spectra_object.unmodifiedpeptide = value.gsub(/[().+-,0-9]+/,'')
            end
            
            
            if field == "PRECURSOR"
                spectra_object.precursor = Float(value)
            end
        else
            if line.length > 5
                #these are probably peaks
                splits = line.split("\t")
                peaks_list.push([Float(splits[0]).to_s, Float(splits[1]).to_s])
            end
        end
        
        
    end
end



puts ARGV[0]

parse_mgf_library(ARGV[0])