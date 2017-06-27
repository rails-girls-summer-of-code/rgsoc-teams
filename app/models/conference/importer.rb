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
      raise "File must be .csv" unless File.extname(file.to_s) == ".csv"
    end
    
    def process_csv(file)
      CSV.foreach(file, headers: true) do |row|
        begin
          conference_hash = row.to_hash
          conference = Conference.find_or_create_by!(id: row['id'])
          conference.update!(conference_hash)
        rescue => e
          imports_logger.error "Error: #{e.message} in #{conference.name}"
        end
      end
    end
  end # class << self
end