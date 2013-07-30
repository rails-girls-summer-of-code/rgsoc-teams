# Pass a filename as ARGV[0] as in $ ruby -Ilib lib/confs.rb path/to/data.rb
#
# data.rb is supposed to define a hash as follows:
#
#   {
#     'applications' => {
#       'sponsored' => {
#         'Team 1' => {
#           'Student 1' => ['conf 1', 'conf 2', ...],
#           'Student 2' => ['conf 1', 'conf 3', ...]
#         },
#         'Team 2' => {
#           # ...
#         }
#       },
#       'volunteering' => {
#         # ...
#       },
#       'no team' => {
#         # ...
#       }
#     },
#     'confs' => {
#       'conf 1' => { tickets: 1, flights: 0 },
#       'conf 2' => { tickets: 2, flights: 2 },
#       'conf 3' => { tickets: 2, flights: 0 }
#     }
#   }

require 'confs/application'
require 'confs/applications'
require 'confs/conf'
require 'confs/confs'
require 'confs/raffle'
require 'confs/result'
require 'confs/table'

DATA = eval(File.read(ARGV[0]))
confs = Confs.new(DATA['confs'])
result = Result.new(confs)
types = DATA['applications'].keys
raffles = DATA['applications'].inject({}) { |r, (type, data)| r.merge(type => Raffle.new(confs, data)) }

TABLE_HEADERS = {
  apps: ['Conference', 'Name', 'Team'],
  confs: ['Conference', 'Tickets', 'Flights']
}

def tp(type, data)
  puts Table.new(data, headers: TABLE_HEADERS[type]).to_s
end

# A round of raffles is one raffle per type (sponsored, volunteering, no-team).
# Winners from each raffle are added to the result set. We run another round of
# raffles while any of the raffles from last round yielded winners.
begin
  winners_found = false
  puts
  puts "Available tickets:"
  puts
  tp :confs, confs.map(&:to_row)

  types.each do |type|
    puts
    puts  '=' * 20 + " RAFFLE: #{type.upcase} " + '=' * 20
    puts

    winners = raffles[type].run
    result.add(winners)
    winners_found |= winners.any?

    if winners.any?
      puts "Winners:"
      puts
      tp :apps, winners.map(&:to_row)
    else
      puts 'No winners this time.'
    end
  end

  puts
  puts winners_found ? 'Still tickets available, doing another round ...' : 'This rounds yielded no winners any more. So we have our final result.'
end while winners_found

puts
puts "RESULTS"
puts

tp :app, result.winners.map(&:to_row)

# puts
# puts "RESULTS BY CONFS"
# puts
#
# tp :app, result.by_conf.values.flatten.map(&:to_row)
#
# puts
# puts "RESULTS BY TEAMS"
# puts
#
# tp :app, result.by_team.values.flatten.map(&:to_row)


