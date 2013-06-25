module UrlHelper
  def normalize_url(url)
    url = url.strip if url
    url && url !~ /^http/ ? "http://#{url}" : url
  end
end
