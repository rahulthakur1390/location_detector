class FetchIpService
  require 'uri'
  require 'net/http'
  require 'socket'
  require 'ipaddr'

  def initialize(url)
    @url = url
    convert_url_to_ip
  end

  def track
    uri = URI("http://api.ipstack.com/#{@url}?access_key=2b7f28a9b07abe846d809757b3e4a97a&format=1")
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  end

  def dns_or_ip_addrs_check(address)
    addr = address[/http(?:s)?:\/\/([a-z0-9.]+)\/?/i,1]
    begin
      IPAddr.new addr
      'ip address'
    rescue IPAddr::InvalidAddressError
      'dns address'
    end
  end

  def convert_url_to_ip
    if dns_or_ip_addrs_check(@url) == "dns address"
      url = @url.split("//").last
      @url = IPSocket::getaddress(url)
    end
  end

end
