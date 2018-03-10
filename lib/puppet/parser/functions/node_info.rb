begin
  require 'json'
  require 'puppet/util/nc_https'
  require 'puppet_x/node_manager/common'
rescue LoadError
  mod = Puppet::Module.find('node_manager', Puppet[:environment].to_s)
  require File.join mod.path, 'lib/puppet/util/nc_https'
  require File.join mod.path, 'lib/puppet_x/node_manager/common'
end

# Retrieves node information to be parsed by 3rd party products
module Puppet::Parser::Functions
  newfunction(:node_info, type: :rvalue) do |args| 
    raise ArgumentError, 'Function accepts a String (nodename) as first arg' unless args[0].is_a?(String)
    raise ArgumentError, 'Function accepts a Hash with key "fact" as second arg' unless args[1].is_a?(Hash) and args[1].has_key?('fact')
    raise ArgumentError, 'Function accepts a Hash with key "trusted" as third arg' unless args[2].is_a?(Hash) and args[2].has_key?('trusted')

    node_name = args[0]
    node_facts = args[1]
    node_trusted = args[2]

    ng = Puppet::Util::Nc_https.new
    # groups = ng.get_groups

    ngroups = []

    # When querying a specific group
    if args.length == 3
      raw = ng.get_classified(node_name, false, node_facts, node_trusted)

      Puppet::Type.type(:node_group)
      Puppet::Type::Node_group::ProviderHttps.instances

      raw['groups'].map do |group|
        gindex = Puppet::Type::Node_group::ProviderHttps.get_name_index_from_id(group)
        ngroups << Hash[$ngs[gindex]['name'] => $ngs[gindex]['id'].to_s]
      end
    end
    ngroups.to_json
  end
end
