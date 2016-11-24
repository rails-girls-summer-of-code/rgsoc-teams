namespace :projects do

  namespace :licenses do

    desc 'Grabs a list of OSI approved Open Source licenses from opensource.org'
    task :update do
      require 'open-uri'
      require 'nokogiri'

      site = 'https://opensource.org/licenses/alphabetical'
      html = Nokogiri::HTML(open(site))

      licenses = html.css('.content article li a').map(&:text)

      puts JSON.dump(licenses.uniq)
    end
  end
end
