# frozen_string_literal: true

require 'redcarpet_camo_renderer'

module MarkdownHelper
  def render_markdown(source)
    renderer = Redcarpet::Render::Camo.new(
      filter_html: true,
      safe_links_only: true,
      hard_wrap: true
    )
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(source || '')
  end
end
