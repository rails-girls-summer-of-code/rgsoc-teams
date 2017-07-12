require 'csv'
class Conference::Importer
  
  ## This importer is depending on agreed-upon input format.
  ## Input file:
  # - Dates should be formatted with dd mm yyyy
  # - UID should be unique and formatted with season + id: 2017001
  # - The headers should not be changed
  # Output:
  # - Conferences will be updated or created
  # - Conferences deleted in the input file, are not removed from the table
  # - Import errors are logged in a Rails Logger
  # - UID is mapped to 'gid' ('google-id' LOL), and has the format: 2017001
  
  class << self
    def call(file)
      check_valid(file)
      info_log(:started, file)
      process_csv(file)
      info_log(:finished, file)
    end
    
    private
    
    def info_log(arg, file)
      notices = {
        started: "Started importing file #{file.original_filename}",
        finished: "Finished updating/creating #{count_conferences_in(file)} conferences"
      }
      logger { logger.info "\n***" + notices[arg] + "***" }
    end
   
    def logger(&block)
      Rails.logger.tagged("Importer") { block }
    end
    
    def check_valid(file)
      raise ArgumentError, "Oops! I can upload .csv only :-(" unless file.content_type == "text/csv"
    end
    
    def count_conferences_in(file)
      CSV.foreach(file.path, headers: true).count
    end
    
    def process_csv(file)
      CSV.foreach(file.path, { headers: true, col_sep: ';' }) do |row|
        begin
          conference = Conference.find_or_initialize_by(gid: row['UID'])
          conference_hash = {
            gid: row['UID'].to_i,
            name: row['Name'],
            starts_on: row['Start date'],
            ends_on: row['End date'],
            city: row['City'],
            country: row['Country'],
            region: row['Region'],
            url: row['Website'],
            notes: row['Notes'],
          }
          conference.update!(conference_hash.merge(season_id: fetch_season_id(row['UID'])))
        rescue => e
          logger  { logger.error "Error in #{row['UID']}: #{e.message}" }
        end
      end
    end
    
    def fetch_season_id(uid)
      # uid format : 2017001
      year = uid.to_s[0,4]
      Season.find_by(name: year).id
    end
  end
end
