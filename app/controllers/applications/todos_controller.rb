class Applications::TodosController < ApplicationController
  before_action :authenticate_user!
  before_filter -> { require_role 'reviewer' }, except: [:new, :create]
  respond_to :html

  private

    def students
      @students ||= todo.students
    end
    helper_method :students

    def teams
      @teams ||= todo.teams
    end
    helper_method :teams

    def applications
      @applications ||= todo.applications
    end
    helper_method :applications

    def todo
      Application::Todo.new(current_user)
    end
end
