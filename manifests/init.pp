# This class must be classified to produce node information file
class node_info (
  Stdlib::Absolutepath $node_groups_file = $facts['kernel'] ? {
    'windows' => 'C:/ProgramData/PuppetLabs/facter/facts.d/lastrun_node_groups.json',
    default   => '/etc/facter/facts.d/lastrun_node_groups.json',
  },
){
  $node_groups = node_info($trusted['certname'], { 'fact' =>  $facts }, { 'trusted' => $trusted })

  if $facts['kernel'] == 'windows' {
    $facter_dir       = dirname($node_groups_file)
    $facter_child_dir = 'C:/ProgramData/PuppetLabs/facter'
  }
  else {
    $facter_dir        = dirname($node_groups_file)
    $facter_parent_dir = '/etc/facter'
  }

  file { [$facter_dir, $facter_parent_dir] :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    #recurse => true,
  }

  file { $node_groups_file :
    ensure  => file,
    content => inline_template("{ \"lastrun_node_groups\": <%= @node_groups %> }\n"),
  }
}
