# frozen_string_literal: true

module Selection
  module Service
    class ApplicationDistribution
      def initialize(application:)
        @application = application
      end

      def distribute
        reviewers.each do |reviewer|
          Todo.create!(user: reviewer, application: @application)
        end
      end

      private

      def assigned_reviewers
        Todo.where(application_id: @application.id).collect(&:user)
      end

      def reviewers
        all_reviewers = User.with_role("reviewer").to_a

        # remove already assigned reviewers
        possible_reviewers = all_reviewers - assigned_reviewers

        # sort by assigned applications to distribute the work evenly
        sorted_reviewers = possible_reviewers.shuffle.sort_by { |u| u.todos.count }

        sorted_reviewers.take(3)
      end
    end
  end
end
