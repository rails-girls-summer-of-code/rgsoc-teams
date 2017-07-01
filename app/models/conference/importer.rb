require 'csv'
class Conference::Importer
  
  ## This importer is depending on agreed-upon input format.
  ## Input file:
  # - Dates should be formatted with dd mm yyyy
  # - UID should be unique and formatted with 'current season' + id: 2017001
  # - The headers should not be changed
  # Output:
  # Conferences will be updated or created
  # Conferences deleted in the input file, are not removed from the table
  # Import errors are logged in a separate 'imports_logger' file
  
  class << self
    def import(file)
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
      imports_logger.info "\n***" + notices[arg] + "***"
    end
   
    def imports_logger
      Logger.new("#{Rails.root}/log/imports_logger.log")
    end
    
    def check_valid(file)
      raise "Oops! I can upload .csv only :-(" unless file.content_type == "text/csv"
    end
    
    def count_conferences_in(file)
      CSV.foreach(file.path, headers: true).count
    end
    
    def process_csv(file)
      CSV.foreach(file.path, headers: true, col_sep: ';' ) do |row|
        begin
          conference = Conference.find_or_initialize_by(gid: row['UID'])
          # TODO check: when extra columns are added in the Google Doc, what happens?
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
          fetch_season_id(row['UID'])
          conference.update!(conference_hash.merge(season_id: @season_id))
        rescue => e
          imports_logger.error "Error in #{row['UID']}: #{e.message}"
        end
      end
    end
    
    def fetch_season_id(uid)
      year = uid.to_s[0,4]
      @season_id = Season.find_by(name: year).id
    end
  end
end