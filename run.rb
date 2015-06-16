#!/usr/bin/env ruby

require 'net/http'
require 'securerandom'
require 'sinatra'

def get(url)
  url = URI.parse(url)
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') {|http|
      http.request(req)
  }
  res.body
end

def write(name, contents)
  File.open(name, 'w') { |file| file.write(contents) }
end

def convert(src, dest)
  system("/tmp/graphviz/bin/dot -Tpng #{src} -o #{dest}")
  return $? == 0
end

def doit(url)
  uuid = SecureRandom.uuid

  write("/tmp/in-#{uuid}.dot", get(url))
  convert("/tmp/in-#{uuid}.dot", "/tmp/out-#{uuid}.png")
  return "/tmp/out-#{uuid}.png"
end

get '/render' do
  send_file(doit(params['url']))
end

