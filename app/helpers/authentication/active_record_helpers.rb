# frozen_string_literal: true

module Authentication
  module ActiveRecordHelpers
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find_or_create_for_github_oauth(auth)
        find_and_update_for_github_oauth(auth) || create_for_github_oauth(auth)
      end

      def find_and_update_for_github_oauth(auth)
        user = find_for_github_oauth(auth)
        update_user(user, auth) if unconfirmed_user?(user)
        user
      end

      def find_for_github_oauth(auth)
        find_by(github_id: auth.uid.to_s) ||
          find_by("github_handle ILIKE ?", auth.extra.raw_info.login)
      end

      def create_for_github_oauth(auth)
        update_user(new, auth)
      end

      def update_user(user, auth)
        user.avatar_url    = auth.extra.raw_info.avatar_url
        user.name          = auth.info.name
        user.email         = auth.info.email
        user.homepage      = github_homepage(auth)
        user.location      = auth.extra.raw_info.location
        user.bio           = auth.extra.raw_info.bio
        user.github_import = true
        user.github_id     = auth.uid
        user.github_handle = auth.extra.raw_info.login
        user.skip_confirmation_notification!
        user.save!
        user
      end

      private

      def unconfirmed_user?(user)
        user && user.email.nil? && user.unconfirmed_email.nil?
      end

      def github_homepage(auth)
        homepage = auth.extra.raw_info.blog
        if homepage.present? && !homepage.match(User::URL_PREFIX_PATTERN)
          homepage = "http://" + homepage
        end
        homepage
      end
    end
  end
end
