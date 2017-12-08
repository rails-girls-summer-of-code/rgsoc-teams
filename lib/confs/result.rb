# frozen_string_literal: true
class Result
  attr_reader :confs, :winners

  def initialize(confs)
    @confs = confs
    @winners = []
  end

  def add(winners)
    @winners += winners
  end

  def by_conf
    winners.sort_by(&:conf).group_by(&:conf)
  end

  def by_team
    winners.sort_by(&:team).group_by(&:conf)
  end
end
