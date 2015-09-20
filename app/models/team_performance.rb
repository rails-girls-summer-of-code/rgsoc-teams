module TeamPerformance
# Memo: calculates Team's Performance Score for Supervisor's Dashboard

  def performance
    @score = 0

    if comments.any?
      comments_score
    elsif Time.now-2.days > Season.current.starts_at && Time.now < Season.current.ends_at
      # Maybe we should change the +3 score temporarily for the upcoming week,
      # because before Wed 16th comments-without-text were not being saved.
      @score += 3
    else
      @score += 0
    end


    if activities.any?
      activity_score
    elsif Time.now-2.days > Season.current.starts_at && Time.now < Season.current.ends_at
      @score += 3
    else
      @score += 0
    end
    evaluate_performance
  end

  def comments_score
    latest_comment = comments.ordered.first
    if latest_comment.created_at < Time.now-5.days
      @score += 2
    elsif latest_comment.created_at < Time.now-2.days
      @score += 1
    elsif latest_comment.created_at > Time.now-2.days
      @score += 0
    else
      @score += 1
    end
  end

  def activity_score
    if last_activity.created_at < Time.now-5.days
      @score += 2
    elsif last_activity.created_at < Time.now-3.days
      @score += 1
    elsif last_activity.created_at > Time.now-3.days
      @score += 0
    else
      @score += 1
    end
  end

  def evaluate_performance
    @performance = ' '
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




