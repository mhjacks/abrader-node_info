Facter.add('classes') do
  setcode do
    cls = []

    File.readlines(Puppet[:classfile]).each do |line|
      cls << line.chomp
    end

    cls.to_json
  end
end
