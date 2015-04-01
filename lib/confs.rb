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

require 'artii'
require 'lolize'

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
COLORIZER = Lolize::Colorizer.new
LOG = File.open('conferences_raffle.txt', 'w+')

TABLE_HEADERS = {
  apps: ['Conference', 'Name', 'Team'],
  confs: ['#', 'Conference', 'Tickets', 'Flights']
}
INDENT = ' ' * 8

def titleize(font, string)
  string = Artii::Base.new(font: font).asciify(string).gsub(/\s*$/, '')
  string = string.split("\n").map { |line| INDENT.sub(' ', '') + line }.join("\n")
  string + "\n"
end

def h1(string)
  print titleize('big', string)
  puts
end

def h2(string)
  print titleize('small', string)
  puts
end

def table(type, data)
  ['', *Table.new(data, headers: TABLE_HEADERS[type]).lines]
end

def msg(*strings)
  out '', *strings
end

def progress(count)
  1.times { puts }
  print INDENT + 'Working: '
  ('.' * count).each_char { |char| print_d(char, 0.001) }
  2.times { puts }
end

def out(*strings)
  strings = strings.map { |string| INDENT + string }
  strings.join("\n").each_char { |char| print_d(char) }
  1.times { puts }
end

def print_d(char, delay = 0.0005)
  print char
  sleep delay
end

def pause(delay = :short)
  2.times { puts }
  sleep delay == :long ? 2 : 1
end

def clear
  printf "\033c"
  3.times { puts }
  LOG.print('-' * 100)
end

def print(str)
  COLORIZER.write(str)
  LOG.print(str)
end

def puts(str = '')
  print str + "\n"
end


# A round of raffles is one raffle per type (sponsored, volunteering, no-team).
# Winners from each raffle are added to the result set. We run another round of
# raffles while any of the raffles from last round yielded winners.

# out BANNER
# pause
# pause
#
clear

h1 'Rails Girls Summer of Code'
h2 'CONFERENCES RAFFLE'
pause :long

clear
h2 'Free tickets + flights!'
msg "No less than #{confs.total_tickets} conference tickets to give away ..."
msg 'Thanks to our amazing conference sponsors!'
msg 'Please visit http://railsgirlssummerofcode.org/conferences and say thanks to them :)'
pause :long

clear
h1 'Are you ready?'
pause :long

clear
h1 'Get ready!'
pause

h2 '5 ...'
pause

h2 '4 ...'
pause

h2 '3 ...'
pause

h2 '2 ...'
pause

h2 '1 ...'
pause

h1 'Goooooooooooooooooo!'
pause

clear
h1 'Rails Girls Summer of Code'
h2 'CONFERENCES RAFFLE'
msg 'Available tickets:', *table(:confs, confs.map(&:to_row))
pause :long

start = Time.zone.now
round = 0

begin
  round += 1
  winners_found = false

  clear
  h1 "ROUND ##{round}"
  pause
  clear

  types.each do |type|
    next if type == 'no team'

    h1 'RAFFLE'
    h2 "#{type.upcase} TEAMS"

    progress(confs.total_tickets)
    winners = raffles[type].run
    result.add(winners)
    winners_found |= winners.any?

    if winners.any?
      msg "YAY! We've got some winners:", *table(:apps, winners.map(&:to_row))
    else
      msg "No winners this time."
    end

    pause
    clear
  end

  h1 'DONE.'

  if winners_found
    h2 'Doing another round ...'
    msg "We still have #{confs.total_tickets} tickets available:", *table(:confs, confs.map(&:to_row))
  else
    msg'This rounds yielded no winners any more. So we have our final result.'
  end

  pause
end while winners_found

clear
h1 'FINAL RESULTS'
h2 'CONGRATULATIONS!'

msg *table(:apps, result.winners.map(&:to_row)), '*) flights covered'

pause :long
h2 'HAPPY CONFERENCING!!'

msg 'THANKS TO OUR AMAZING SPONSORS!'
msg 'Please visit http://railsgirlssummerofcode.org/conferences and say thanks to them :)'


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

LOG.close

sleep 1000
puts
puts
puts "\n\nTime taken: #{Time.zone.now - start}"
puts
