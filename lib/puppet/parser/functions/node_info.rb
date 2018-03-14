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
    node_name = args[0]
    node_facts = args[1]
    node_trusted = args[2]

    ng = Puppet::Util::Nc_https.new
    # groups = ng.get_groups

    ngroups = []

    # When querying a specific group
    raw = ng.get_classified(node_name, false, node_facts, node_trusted)

    Puppet::Type.type(:node_group)
    Puppet::Type::Node_group::ProviderHttps.instances

    raw['groups'].map do |group|
      gindex = Puppet::Type::Node_group::ProviderHttps.get_name_index_from_id(group)
      ngroups << Hash[$ngs[gindex]['name'] => $ngs[gindex]['id'].to_s]
    end
    ngroups.to_json
  end
end

