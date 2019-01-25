# frozen_string_literal: true

module Reviewers
  class TodosController < Reviewers::BaseController
    respond_to :html

    def set_breadcrumbs
      super
      @breadcrumbs << ['Todo', [:reviewers, :todos]]
    end

    def index
      @todos = current_user.todos.for_current_season
    end
  end
end
