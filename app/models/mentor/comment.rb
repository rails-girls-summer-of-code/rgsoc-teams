module Mentor
  class Comment < ActiveRecord::Base
    self.table_name = 'comments'

    default_scope { where(commentable_type: COMMENTABLE_TYPE) }

    COMMENTABLE_TYPE = 'Mentor::Application'

    attribute :commentable_type, :string, default: COMMENTABLE_TYPE
    belongs_to :user
  end
end
