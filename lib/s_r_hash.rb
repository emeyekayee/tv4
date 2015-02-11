
# Hash with method_addess and indifferent access for ScheduledResource
class SRHash < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::KeyConversion
end
