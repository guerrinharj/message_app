require 'pagy/extras/metadata'

# Set default items per page
Pagy::DEFAULT[:items] = 10

# Include :items in metadata response
Pagy::DEFAULT[:metadata] = %i[page prev next count pages items]
