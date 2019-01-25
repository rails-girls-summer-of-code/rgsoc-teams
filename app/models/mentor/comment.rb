# frozen_string_literal: true

module Mentor
  class Comment < ApplicationRecord
    self.table_name = 'comments'

    default_scope { where(commentable_type: COMMENTABLE_TYPE) }

    COMMENTABLE_TYPE = 'Mentor::Application'

    attribute :commentable_type, :string, default: COMMENTABLE_TYPE
    belongs_to :user, optional: true

    after_update_commit { |comment| comment.destroy if comment.text.blank? }
  end
end
