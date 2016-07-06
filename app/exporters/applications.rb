module Exporters
  class Applications < Base

    # Assumption: all applications of a given year share the structure of the
    # Application#application_data hash:
    class KeysAndHeaders < Struct.new(:season)
      def keys
        @keys ||= application.application_data&.keys || []
      end

      def headers
        @headers ||= ["Team ID"] +
          keys.map { |key| Application.data_label key } +
          ["Coaching Company", "Misc. Info", "City", "Country", "Project Visibility"] +
          Application::FLAGS.map(&:to_s).map(&:titleize)
      end

      private

      def application
        @application ||= Application.where(season: season).first || Application.new
      end
    end

    def current
      applications     = Application.where(season: Season.current)
      keys_and_headers = KeysAndHeaders.new(Season.current)
      keys             = keys_and_headers.keys
      csv_headers      = keys_and_headers.headers

      generate(applications, *csv_headers) do |app|
        values = keys.map{ |k| app.application_data[k] }
        [app.team_id] +
          values +
          [:coaching_company, :misc_info, :city, :country, :project_visibility].map { |attribute| app.send attribute } +
          Application::FLAGS.map { |flag| app.send flag }
      end
    end

  end
end
