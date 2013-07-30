# To run this script pass a filename as ARGV[0], as in
#
#   $ ruby -Ilib lib/confs.rb path/to/data.rb
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

BANNER = <<txt
Rails Girls Summer of Code Conference Raffle

Applications are grouped by: sponsored teams, volunteering teams, students
who applied but did not make it into the program. Conferences are sorted by
popularity (number of applications we have received), most popular ones
first.

1) We run a raffle for students from sponsored teams:

  a) We try to randomly pick a team that has applied for the most popular
     conference.
  b) If there's no such team we try to randomly pick a student who has
     applied for this conference.
  c) If we've successfully picked a team or student we remove all other
     applications from these students for this raffle (the will be added
     back for the next round).
  d) We repeat this process for the next popular conference, and so on,
     for each of the conferences.

2) We run the same raffle for students from volunteering teams.
3) We run the same raffle for students who applied but are not on the
   program.
4) If any of the raffles in this round have yielded winners then we will do
   another round of raffles, i.e. run steps 1-3 again. If none of the
   raffles in a round yielded any winners then we have our final result and
   stop.

You can find the full code that generated the following results here:

https://github.com/rails-girls-summer-of-code/rgsoc-teams/blob/master/lib/confs.rb
txt

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
  confs: ['Applications', 'Conference', 'Tickets', 'Flights']
}

def tp(type, data)
  puts Table.new(data, headers: TABLE_HEADERS[type]).to_s
end

# A round of raffles is one raffle per type (sponsored, volunteering, no-team).
# Winners from each raffle are added to the result set. We run another round of
# raffles while any of the raffles from last round yielded winners.

# puts BANNER
# puts

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
puts "FINAL RESULTS - CONGRATULATIONS!"
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


