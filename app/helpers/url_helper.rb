module UrlHelper
  def normalize_url(url)
    url =~ /^http/ ? url : "http://#{url}"
  end
end
