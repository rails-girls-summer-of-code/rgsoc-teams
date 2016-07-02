module Exporters
  class Applications < Base

    def current
      applications = Application.where(season: Season.current)

      # Assumption: all applications of a given year share the structure of the
      # Application#application_data hash:
      keys = applications.first&.application_data&.keys || []
      csv_headers = ["Team ID"]  + keys.map { |key| Application.data_label key }

      generate(applications, *csv_headers) do |app|
        values = keys.map{ |k| app.application_data[k] }
        [app.team_id] + values
      end
    end

  end
end
