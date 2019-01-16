# frozen_string_literal: true

module Redcarpet
  module Render
    class Camo < Redcarpet::Render::HTML
      include ::Camo

      def image(link, title, alt_text)
        if camo_configured? and link.starts_with?('http:')
          link = camo(link)
        end
        "<img src=\"#{link}\" alt=\"#{alt_text}\" title=\"#{title}\">"
      end

      private

      def camo_configured?
        [ENV["CAMO_HOST"], ENV["CAMO_KEY"]].all?(&:present?)
      end
    end
  end
end
