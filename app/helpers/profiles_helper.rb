module ProfilesHelper
  def github_handle=(github_handle)
    super(github_handle.to_s.sub(%r(^https?://github\.com/), '').split('/').first)
  end

  def twitter_handle=(twitter_handle)
    twitter_handle = twitter_handle.to_s.sub(%r(^https?://twitter\.com/), '').sub(/^@/, '').split('/').first
    super(twitter_handle && "@#{twitter_handle}")
  end

  def twitter_url
    "http://twitter.com/#{twitter_handle.to_s.sub('@', '')}"
  end

  def github_url
    "https://github.com/#{github_handle}"
  end
end
