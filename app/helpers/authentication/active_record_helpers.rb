module Authentication
  module ActiveRecordHelpers
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find_or_create_for_github_oauth(auth)
        find_for_github_oauth(auth) || create_for_github_oauth(auth)
      end

      def find_for_github_oauth(auth)
        where(github_id: auth.uid.to_s).first || where(github_handle: auth.extra.raw_info.login).first
      end

      def create_for_github_oauth(auth)
        user = new(
          avatar_url:    auth.extra.raw_info.avatar_url,
          name:          auth.info.name,
          email:         auth.info.email,
          homepage:      auth.extra.raw_info.blog,
          location:      auth.extra.raw_info.location,
          bio:           auth.extra.raw_info.bio
        )
        user.github_id = auth.uid
        user.github_handle = auth.extra.raw_info.login
        user.save!
        user
      end
    end
  end
end
