require 'csv'
class Conference::Importer
  
  class << self
    def import(file)
      check_valid(file)
      imports_logger.info "\n***** Start importing #{file}"
      process_csv(file)
      imports_logger.info "\n******* Finished importing :-) ******"
    end
    
    private
    
    def imports_logger
      Logger.new("#{Rails.root}/log/imports_logger.log")
    end
    
    def check_valid(file)
      raise "Oops! I can upload .csv only :-(" unless file.content_type == "text/csv"
    end
    
    def process_csv(file)
      CSV.foreach(file.path, headers: true, col_sep: ';' ) do |row|
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
            season_id: Season.current.id
          }
          conference.update(conference_hash)
        rescue => e
          imports_logger.error "Error: #{e.message}"
        end
      end
    end
  end # class << self
end