# frozen_string_literal: true

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
          ["Coaching Company", "Misc. Info", "City", "Country"] +
          Selection::Table::FLAGS.map(&:to_s).map(&:titleize)
      end

      private

      def application
        @application ||= Application.where(season: season).first || Application.new
      end
    end

    (2015..Date.today.year).each do |year|
      define_method "applications_#{year}" do
        season = Season.find_by(name: year)
        applications = Application.where(season: season)
        export_applications(season, applications)
      end
    end

    (2015..Date.today.year).each do |year|
      define_method "accepted_applications_#{year}" do
        season       = Season.find_by(name: year)
        applications = Application.where(season: season).select do |application|
          application.team&.accepted?
        end
        export_applications(season, applications)
      end
    end

    def current
      applications = Application.where(season: Season.current)
      export_applications(Season.current, applications)
    end

    private

    def export_applications(season, applications)
      keys_and_headers = KeysAndHeaders.new(season)
      application_keys = keys_and_headers.keys
      csv_headers      = keys_and_headers.headers

      generate(applications, *csv_headers) do |app|
        application_data_values = application_keys.map { |k| app.application_data[k] }
        [app.team_id] +
          application_data_values +
          [:coaching_company, :misc_info, :city, :country].map { |attribute| app.send attribute } +
          Selection::Table::FLAGS.map { |flag| app.send flag }
      end
    end
  end
end
