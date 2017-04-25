require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(' ')
  path, params = path_and_params.split('?')

  params = params.split('&').each_with_object({}) do |pair, hash|
  pair = pair.split('=')
  hash[pair[0]] = pair[1]
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  client.puts "HTTP/1.1 200 OK"
  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line
  client.puts request_line

  http_method, path, params = parse_request(request_line)

  params["rolls"].to_i.times do
    client.puts rand(params["sides"].to_i) + 1
  end
  client.close
end
