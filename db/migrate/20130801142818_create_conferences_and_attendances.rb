class CreateConferencesAndAttendances < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.string :location
      t.string :twitter
      t.string :url
      t.date :starts_on
      t.date :ends_on
      t.integer :tickets
      t.integer :accomodation
      t.integer :flights
    end

    create_table :attendances do |t|
      t.belongs_to :conference
      t.belongs_to :user
    end

    confs = [
      {:name=>'ArrrrCamp',        :attendances_attributes => [{ github_handle: 'vicandroid' },    { github_handle: 'oana-sipos' }], :location=>'Ghent, Belgium', :twitter=>'@arrrrcamp', :starts_on=>'2013-10-03', :ends_on=>'2013-10-04', :tickets=>2, :flights=>nil, :accomodation=>nil, :url=>'http://www.arrrrcamp.be'},
      {:name=>'DevCon TLV',       :attendances_attributes => [{ github_handle: 'berlintam' },     { github_handle: 'FrauBienenstich' }], :location=>'Tel Aviv, Israel', :twitter=>'#DevconTLV', :starts_on=>'2013-10-10', :ends_on=>'2013-10-10', :tickets=>3, :flights=>nil, :accomodation=>nil, :url=>'http://devcon-oct13.events.co.il'},
      {:name=>'Distill',          :attendances_attributes => [{ github_handle: 'jendiamond' },    { github_handle: 'joyicecloud' }], :location=>'San Francisco, USA', :twitter=>'@distill', :starts_on=>'2013-08-08', :ends_on=>'2013-08-09', :tickets=>2, :flights=>nil, :accomodation=>2, :url=>'https://distill.engineyard.com'},
      {:name=>'DotRBeu',          :attendances_attributes => [{ github_handle: 'dalach' },        { github_handle: 'Dellilah' }, { github_handle: 'carlad' }, { github_handle: 'berlintam' }, { github_handle: 'FrauBienenstich' }], :location=>'Paris, France', :twitter=>'@dotRBeu', :starts_on=>'2013-10-18', :ends_on=>'2013-10-18', :tickets=>5, :flights=>nil, :accomodation=>nil, :url=>'http://www.dotrb.eu'},
      {:name=>'FutureStack',      :attendances_attributes => [{ github_handle: 'lauragarcia' }], :location=>'San Francisco, USA', :twitter=>'#futurestack', :starts_on=>'2013-10-24', :ends_on=>'2013-10-25', :tickets=>1, :flights=>1, :accomodation=>1, :url=>'http://futurestack.io'},
      {:name=>'JRubyConfEU',      :attendances_attributes => [{ github_handle: 'ninabreznik' },   { github_handle: 'juliaguar' }], :location=>'Berlin', :twitter=>'@jrubyconfeu', :starts_on=>'2013-08-14', :ends_on=>'2013-08-15', :tickets=>2, :flights=>nil, :accomodation=>nil, :url=>'http://2013.jrubyconf.eu'},
      {:name=>'Madison Ruby',     :attendances_attributes => [{ github_handle: 'hestervanwijk' }, { github_handle: 'jacqueline-homan' }], :location=>'Madison, USA', :twitter=>'@madisonruby', :starts_on=>'2013-08-20', :ends_on=>'2013-08-24', :tickets=>2,:flights=>nil, :accomodation=>nil, :url=>'http://madisonruby.org'},
      {:name=>'RUPY',             :attendances_attributes => [{ github_handle: 'majakomel' },     { github_handle: 'ninabreznik' }], :location=>'Budapest, Hungary', :twitter=>'@rupy', :starts_on=>'2013-10-11', :ends_on=>'2013-10-14', :tickets=>2, :flights=>2, :accomodation=>2, :url=>'http://13.rupy.eu'},
      {:name=>'Rails Israel',     :attendances_attributes => [{ github_handle: 'berlintam' },     { github_handle: 'FrauBienenstich' }], :location=>'Tel Aviv, Israel', :twitter=>'#RailsIL', :starts_on=>'2013-10-09', :ends_on=>'2013-10-09', :tickets=>3, :flights=>nil, :accomodation=>nil, :url=>'http://railsisrael2013.events.co.il'},
      {:name=>'RubyShift',        :attendances_attributes => [{ github_handle: 'tyranja' }, { github_handle: 'carlad' }, { github_handle: 'majakomel' }, { github_handle: 'berlintam' }, { github_handle: 'FrauBienenstich' }, { github_handle: 'juliaguar' }], :location=>'Kiev', :twitter=>'@rubyshift', :starts_on=>'2013-08-27', :ends_on=>'2013-08-28', :tickets=>9, :flights=>2, :accomodation=>2, :url=>'http://rubyshift.org'},
      {:name=>'SoCoded',          :attendances_attributes => [{ github_handle: 'trekr5' },        { github_handle: 'juliaguar' }], :location=>'Hamburg, Germany', :twitter=>'@socoded', :starts_on=>'2013-08-19', :ends_on=>'2013-08-20', :tickets=>2, :flights=>nil, :accomodation=>nil, :url=>'http://socoded.com'},
      {:name=>'StarTechConf',     :attendances_attributes => [{ github_handle: 'ceciliarivero' }, { github_handle: 'maynkj' }], :location=>'Santiago, Chile', :twitter=>'@startechconf', :starts_on=>'2013-10-25', :ends_on=>'2013-10-26', :tickets=>5, :flights=>nil, :accomodation=>nil, :url=>'http://www.startechconf.com'},
      {:name=>'Strange Loop',     :attendances_attributes => [{ github_handle: 'lauragarcia' },   { github_handle: 'nanampp' }], :location=>'St Louis, USA', :twitter=>'@strangeloop_stl', :starts_on=>'2013-09-18', :ends_on=>'2013-09-19', :tickets=>2, :flights=>2, :accomodation=>2, :url=>'https://thestrangeloop.com'},
      {:name=>'Wicked Good Ruby', :attendances_attributes => [{ github_handle: 'hestervanwijk' }], :location=>'Boston, USA', :twitter=>'@wickedgoodruby', :starts_on=>'2013-10-12', :ends_on=>'2013-10-13', :tickets=>5, :flights=>nil, :accomodation=>nil, :url=>'http://wickedgoodruby.com'},
      {:name=>'eurucamp',         :attendances_attributes => [{ github_handle: 'queenfrankie' },  { github_handle: 'majakomel' }], :location=>'Berlin, Germany', :twitter=>'@eurucamp', :starts_on=>'2013-08-16', :ends_on=>'2013-08-18', :tickets=>2, :flights=>nil, :accomodation=>nil, :url=>'http://2013.eurucamp.org'},
    ]
    confs.each do |attrs|
      Conference.create!(attrs)
    end
  end
end
