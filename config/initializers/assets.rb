Rails.application.config.assets.precompile += %w( chosen-sprite.png chosen-sprite@2x.png tidy.js )
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
