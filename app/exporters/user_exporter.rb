module Exporters
  class Users < Base
    class << self

      # Note: This only grabs the user who sent in the application, not the pair.
      # FIXME: This will fall apart in 2015 when we keep the user data.
      def for_rejection_letter
        rejected = User.includes(:teams).joins(:applications).
                    where.not('applications.user_id' => nil).uniq.
                    select { |user| user.teams.empty? }

        generate(rejected, 'User ID', 'Name', 'GH Handle', 'Email') do |user|
          [user.id, user.name, user.github_handle, user.email]
        end
      end

    end

  end
end
