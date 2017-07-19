module GithubHandle
  extend ActiveSupport::Concern

  def github_handle
    user.try(:github_handle)
  end

  def github_handle=(github_handle)
    if github_handle.present?
      self.user = User.where("github_handle ILIKE ?", github_handle).first_or_initialize(github_handle: github_handle)
      user.github_handle = github_handle
      user.github_import = true
    end
  end
end