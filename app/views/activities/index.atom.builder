atom_feed language: 'en-US' do |feed|
  feed.title "Rails Girls Summer of Code Activities"
  feed.updated @activities.first.try(:updated_at)

  @activities.each do |activity|
    next if activity.updated_at.blank?

    title = activity.title
    updated_at = activity.published_at.strftime('%Y-%m-%dT%H:%M:%SZ')
    content = activity.content

    case activity.kind
    when 'feed_entry'
      url = activity.source_url
      author_name = activity.team.display_name
    when 'mailing'
      url = mailing_url(activity.guid)
      author_name = activity.author
    end

    feed.entry(activity, url: url) do |entry|
      entry.url url
      entry.title title
      entry.author { |author| author.name author_name }
      entry.updated updated_at
      entry.content content
    end
  end
end
