module ColorHelper
  COLORS = %w(
    turquoise emerland peterriver amethyst wetasphalt greensea nephritis
    belizehole wisteria midnightblue sunflower carrot alizarin
    orange pumpkin pomegranate asbestos
  )

  def color
    color = COLORS[number % COLORS.size]
    color = "#{color} .light" unless kind == 'sponsored'
    color
  end
end
