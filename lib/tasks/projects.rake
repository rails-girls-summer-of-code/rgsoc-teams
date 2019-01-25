namespace :projects do
  namespace :licenses do
    desc 'Grabs a list of OSI approved Open Source licenses from opensource.org'
    task :update do
      require 'open-uri'
      require 'nokogiri'

      file = 'public/osi-licenses.json'
      site = 'https://opensource.org/licenses/alphabetical'
      html = Nokogiri::HTML(open(site))

      licenses = html.css('.content article li a').map(&:text)

      File.open(file, 'w+') { |f| f.write JSON.dump(licenses.uniq) }
      puts File.read(file)
    end
  end
end
