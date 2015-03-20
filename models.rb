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
end


DataMapper.finalize
Spectrum.auto_migrate! unless Spectrum.storage_exists?
DataMapper.auto_upgrade!

