
# Hash with method_addess and indifferent access for SchedResource
class SRHash < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::KeyConversion
end
