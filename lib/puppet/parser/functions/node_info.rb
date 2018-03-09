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
    raise ArgumentError, 'Function accepts a single String' unless args.length == 1 && args[0].is_a?(String)

    node_name = args[0]
    ng = Puppet::Util::Nc_https.new
    # groups = ng.get_groups

    ngroups = []

    # When querying a specific group
    if args.length == 1
      raw = ng.get_classified(node_name)

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
