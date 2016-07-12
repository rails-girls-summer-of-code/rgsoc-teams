class Comment < ActiveRecord::Base
  belongs_to :team
  belongs_to :application
  belongs_to :project
end

class MakeExistingForeignKeysPolymorphicForComments < ActiveRecord::Migration
  def up
    ActiveRecord::Base.transaction do
      Comment.includes(:team, :application, :project).find_each do |comment|
        if assoc = [:team, :application, :project].detect { |a| comment.send(a).present? }
          old_foreign_key = "#{assoc}_id".to_sym
          comment.update!({
            :commentable_id   => comment.send(old_foreign_key),
            :commentable_type => assoc.to_s.camelize,
            old_foreign_key   => nil
          })
        end
      end
    end
  end

  def down
  end
end
