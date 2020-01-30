apt_update

package 'net-tools' do
  action :install
end

package 'apache2' do
  action :install
end

# file '/var/www/html/index.html' do
#   action :create
#   content "<html>
# <body>
# <h1>Hello Pipeline World!</h1>
# <h2>This machine is running #{node['os']}</h2>
# <h2>My ip address is #{node['cloud']['public_ipv4']}</h2>
# <h2>This computer belongs to #{node['apache']['company_name']}</h2>
# </body>
# </html>"
# end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end

service 'apache2' do
  action [ :enable, :start ]
end
