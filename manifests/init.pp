# This class must be classified to produce node information file
class node_info (
  Stdlib::Absolutepath $node_info_file = '/tmp/node_info.json',
){
  $node_groups = node_info($trusted['certname'])

  file { $node_info_file :
    ensure  => file,
    content => epp('node_info/node_info.json.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }
}
