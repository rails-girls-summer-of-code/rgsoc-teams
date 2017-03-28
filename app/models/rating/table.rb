class Rating::Table
  DEFAULT_OPTS = { hide_flags: [] }

  def initialize(applications:, options: {})
    @options      = DEFAULT_OPTS.merge(options)
    @applications = applications
      .to_a
      .delete_if { |a| hide?(a) }
      .sort_by(&order)
  end

  attr_reader :applications, :options

  private

  def hide?(application)
    (options[:hide_flags] & application.flags).any?
  end

  def order
    options[:order].try(:to_sym)
  end
end
