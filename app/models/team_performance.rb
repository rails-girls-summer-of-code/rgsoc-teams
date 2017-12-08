# frozen_string_literal: true
class TeamPerformance
# Internal: calculates a Team's performance score for supervisor's dashboard

  def self.teams_to_remind
    if buffer_days?
      Team.none
    else
      Team.by_season_phase.without_recent_log_update
    end
  end

  def initialize(team)
    @team = team
  end

  def evaluation
    @score = 0

    comments_score
    activity_score

    if @score > 3
      @performance = :red
    elsif @score >= 2
      @performance = :orange
    elsif @score == 0
      @performance = :green
    else
      @performance = :orange
    end
  end

  private

  def self.buffer_days?
    # the first few days, plus the days before and after the coding season
    Time.now < Season.current.starts_at + 2.days || !Season.current.started? || Time.now > Season.current.ends_at + 2.days
  end

  def comments_score
    latest_comment = @team.comments.ordered.first
    if !self.class.buffer_days?
      if @team.comments.empty?
        @score += 3
      elsif latest_comment.created_at <= Time.now - 5.days
        @score += 2
      elsif latest_comment.created_at <= Time.now - 2.days
        @score += 1
      elsif latest_comment.created_at > Time.now - 2.days
        @score += 0
      else
        @score += 1
      end
    end
  end

  def activity_score
    if !self.class.buffer_days?
      if @team.activities.empty?
        @score += 3
      elsif @team.last_activity.created_at <= Time.now - 5.days
        @score += 2
      elsif @team.last_activity.created_at <= Time.now - 3.days
        @score += 1
      elsif @team.last_activity.created_at > Time.now - 3.days
        @score += 0
      else
        @score += 1
      end
    end
  end

end
