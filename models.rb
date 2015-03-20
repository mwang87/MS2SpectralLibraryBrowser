require 'dm-migrations'
require 'dm-serializer'
require 'dm-constraints'

DataMapper::Property::String.length(255)

class Spectrum
    include DataMapper::Resource
    property :id,                       Serial
    property :unmodifiedpeptide,        String
    property :peptide,                  String
    property :charge,                   Integer
    property :precursor,                Float
    property :peaks,                    Text
    
    belongs_to :library
end

class Library
    include DataMapper::Resource
    property :id,                       Serial
    property :name,                     String
    
    has n, :spectrum
end

DataMapper.finalize
Spectrum.auto_migrate! unless Spectrum.storage_exists?
Library.auto_migrate! unless Library.storage_exists?
DataMapper.auto_upgrade!

