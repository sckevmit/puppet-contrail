class contrail::profile::provision_simple_gateway(
  $action,
) {
  require contrail::profile::utils

  # create network needs to be done on controller
  if $action == 'create_network' {
    neutron_network { 'private':
      ensure      => present,
      tenant_name => 'admin',
    }
    neutron_subnet { 'private_subnet':
      ensure       => present,
      cidr         => '10.0.0.0/24',
      network_name => 'private',
      tenant_name  => 'admin',
    }
  # network device must be create on compute node
  } elsif $action == 'create_vgw_device' {
    exec {'provision simple gateway':
      command => 'python /usr/share/contrail-utils/provision_vgw_interface.py --oper create --interface vgw1 --subnets 10.0.0.0/24 --vrf default-domain:admin:private:private_subnet--routes 0.0.0.0/0',
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      unless  => 'ifconfig vgw1',
    }
  }
}
