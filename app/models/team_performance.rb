class TeamPerformance
# Memo: calculates Team's Performance Score for Supervisor's Dashboard

  def initialize(team)
    @team = team
  end

  def buffer_days?
    # the first few days of the season, and the days before the season starts
    Time.now < Season.current.starts_at+2.days || !Season.current.started?
  end

  def score
    @score = 0

    if @team.comments.any?
      comments_score
    else
      @score += 3 unless buffer_days?
    end

    if @team.activities.any?
      activity_score
    else
      @score += 3 unless buffer_days?
    end

    evaluate_performance
  end

  private

  def comments_score
    latest_comment = @team.comments.ordered.first
    if latest_comment.created_at <= Time.now-5.days
      @score += 2
    elsif latest_comment.created_at <= Time.now-2.days
      @score += 1
    elsif latest_comment.created_at > Time.now-2.days
      @score += 0
    else
      @score += 1
    end
  end

  def activity_score
    if @team.last_activity.created_at <= Time.now-5.days
      @score += 2
    elsif @team.last_activity.created_at <= Time.now-3.days
      @score += 1
    elsif @team.last_activity.created_at > Time.now-3.days
      @score += 0
    else
      @score += 1
    end
  end

  def evaluate_performance
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
end