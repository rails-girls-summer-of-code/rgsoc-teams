atom_feed language: 'en-US' do |feed|
  feed.title "Rails Girls Summer of Code Activities"
  feed.updated @activities.first.try(:updated_at)

  @activities.each do |activity|
    next if activity.updated_at.blank?

    feed.entry(activity, url: activity.source_url) do |entry|
      entry.url activity.source_url
      entry.title activity.title
      entry.updated(activity.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
      entry.author do |author|
        author.name activity.team.display_name
      end
    end
  end
end
