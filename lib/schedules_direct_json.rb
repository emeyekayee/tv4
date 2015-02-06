# ~/tv4/lib/schedules_direct_json.rb

# Nascent code to handle the newer json-based data feed from SchedulesDirect.  


require 'httparty'
require 'digest/sha1'


class SchedulesDirectJson

  def initialize( url_base = 'https://json.schedulesdirect.org/20140530' )
    @url_base = url_base
  end


  # File ~/.xtvd could look like:
  # [auth]
  # username: some.user.name@gmail.com
  # password: sekret
  #    
  def key_value_from_config( name )
    path  = File.expand_path '~/.xtvd'
    regex = /^ *#{name}: */
    line  = IO.readlines( path ).grep(regex).first
    line.sub( regex, '').strip
  end


  def pw_digest
    Digest::SHA1.hexdigest key_value_from_config( :password )
  end


  def auth_body
    { username: key_value_from_config( :username ),
      password: pw_digest 
    }.to_json
  end


  def token
    @token ||= get_token
  end

  def get_token
    headers   = { 'Content-Type' => 'application/json' }
    token_url = @url_base + '/token'

    resp = HTTParty.post( token_url, body: auth_body, headers: headers )

    unless resp.code == 200
      raise "get_token() failed: #{token_url}, #{auth_body} --> #{resp.inspect}"
    end

    resp.parsed_response['token']
  end


  def status( last_chance: false)
    resp = HTTParty.get( @url_base + '/status', headers: { 'token' => token } )

    unless resp.code == 200

      # Could be no token yet or token just expired.
      unless last_chance
        @token = nil
        return status( :last_chance )
      end
      
      raise "status() failed: #{@url_base}/status --> #{resp.inspect}"
    end

    resp.parsed_response
  end


  # NOTE:Developers, please contact grabber@schedulesdirect.org and
  # provide the clientname string and the version that you would like
  # the server to reply with.
  def version
    resp = HTTParty.get( @url_base + '/version/mfdb-json', 
                         headers: { 'token' => token } )
    resp.parsed_response
  end

  
  def headends
    resp = HTTParty.get( @url_base + '/headends?country=USA&postalcode=94306', 
                         headers: { 'token' => token } )
    resp.parsed_response
  end


  hes = headends
  he  = hes["CA55363"]
  # => { "type" => "Cable", 
  #      "location"=>"Palo Alto",
  #      "lineups" => [
  #          { "name" => "Comcast - Cable",
  #            "uri"  => "/20140530/lineups/USA-CA55363-DEFAULT"
  #           },
  #          { "name" => "Comcast - Digital",
  #            "uri"  => "/20140530/lineups/USA-CA55363-X"
  #           }
  #         ]
  #     }

  # PUT  https://json.schedulesdirect.org/20140530/lineups/USA-CA55363-X

  def add_lineup( lineup_ident )
    # lineup_ident = 'USA-CA55363-X'       FAIL
    resp = HTTParty.get( @url_base + '/lineups/' + lineup_ident, 
                         headers: { 'token' => token } )
    pr = resp.parsed_response
    pr.keys.each{|key| puts "#{key}:  #{pr[key]}"};nil
    # message:  Lineup not in account. Add lineup to account before requesting mapping.    
  end



end
