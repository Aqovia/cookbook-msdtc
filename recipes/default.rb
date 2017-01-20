#
# Cookbook Name:: cookbook-enable-MSDTC
# Recipe:: default
#
# Copyright 2017, Aqovia Ltd.
#
# All rights reserved - Do Not Redistribute
#


registry_key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security' do
  values [{:name => 'NetworkDtcAccessTransactions', :type => :dword, :data => node['msdtc']['NetworkDtcAccessTransactions']},
          {:name => 'NetworkDtcAccess', :type => :dword, :data => node['msdtc']['NetworkDtcAccess']},
          {:name => 'NetworkDtcAccessClients', :type => :dword, :data => node['msdtc']['NetworkDtcAccessClients']},
          {:name => 'NetworkDtcAccessInbound', :type => :dword, :data => node['msdtc']['NetworkDtcAccessInbound']},
          {:name => 'NetworkDtcAccessOutbound', :type => :dword, :data => node['msdtc']['NetworkDtcAccessOutbound']},
          {:name => 'NetworkDtcAccessTip', :type => :dword, :data => node['msdtc']['NetworkDtcAccessTip']}
         ]
  action :create_if_missing
end

windows_firewall_rule 'Sql Server DTC' do
	localport node['msdtc']['fromport']..node['msdtc']['toport']
	protocol 'TCP'
	firewall_action :allow
end

registry_key 'HKEY_LOCAL_MACHINE\Software\Microsoft\Rpc\Internet' do
  values [{:name => 'Ports', :type => :REG_MULTI_SZ, :data => node['msdtc']['fromport']-node['msdtc']['toport']},
          {:name => 'PortsInternetAvailable', :type => :REG_SZ, :data => node['msdtc']['PortsInternetAvailable']},
          {:name => 'UseInternetPorts', :type => :REG_SZ, :data => node['msdtc']['UseInternetPorts']}
         ]
  action :create_if_missing
end
