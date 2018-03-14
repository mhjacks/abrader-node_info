begin
  cached_catalog_file = "#{Puppet[:client_datadir]}/catalog/#{Facter.value('fqdn')}.json"
  cached_catalog_json = JSON.parse(File.read(cached_catalog_file))

  Facter.add(:cached_catalog_classes) do
    setcode do
      cached_catalog_json['classes']
    end
  end

  Facter.add(:cached_catalog_environment) do
    setcode do
      cached_catalog_json['environment']
    end
  end

  Facter.add(:cached_catalog_version) do
    setcode do
      cached_catalog_json['version']
    end
  end
end
