require 'confs/application'
require 'confs/applications'
require 'confs/confs'
require 'confs/raffle'
require 'confs/result'
require 'confs/table'

def tp(data)
  puts Table.new(data, headers: ['Conference', 'Name', 'Team'], indent: 2).to_s
end

DATA = eval(File.read(ARGV[0]))
confs = Confs.new(DATA['confs'])
result = Result.new(confs)
types = DATA['applications'].keys
raffles = DATA['applications'].inject({}) { |r, (type, data)| r.merge(type => Raffle.new(confs, data)) }

begin
  round = false
  types.each do |type|
    puts
    puts "Raffle: #{type.upcase}"
    puts "Available tickets: #{confs.data.select { |name, conf| conf[:tickets] > 0 }.map { |name, conf| [name, conf[:tickets]].join(': ') }.join(', ')}"
    puts

    raffle = raffles[type]
    winners = raffle.run
    result.add(winners)
    round |= winners.any?

    if winners.any?
      tp(winners.map { |winner| [winner.conf, winner.name, winner.team] })
    else
      puts '  no winners this time'
    end

    puts
    puts round ? 'Still tickets available, doing another round ...' : 'This rounds yielded no winners any more. So we have our final result.'
  end
end while round

puts
puts "RESULTS"
puts

tp result.winners.map { |winner| [winner.conf, winner.name, winner.team] }

puts
puts "RESULTS BY CONFS"
puts

tp result.by_conf.values.flatten.map { |winner| [winner.conf, winner.name, winner.team] }

puts
puts "RESULTS BY TEAMS"
puts

tp result.by_team.values.flatten.map { |winner| [winner.conf, winner.name, winner.team] }


