neighbourhood_data = [
  {
    name: "Hatchobori",
    hashtag: "#LocalLife",
    description: "A hidden neighborhood filled with small parks and local restaurants with easy access to Disneyland.",
    hashtag_description: "Peaceful parks, local culinary delights, and an architectural wonder of a library at your doorstep. Join the hustle and bustle only when you want to.",
    city: "Tokyo",
    map_pin: "35.67452, 139.77761",
    tags: "Residential"
  },
  {
    name: "Tsukiji",
    hashtag: "#SushiTown",
    description: "The sushi paradise of Japan, where fresh catch and collection-worthy kitchenware can be bought.",
    hashtag_description: "Watch the freshest seafood prepared in front of you and pick up a handcrafted pottery tool as a souvenir.",
    city: "Tokyo",
    map_pin: "35.66617, 139.77059",
    tags: "Cheap-Eats, Historical"
  },
  {
    name: "Ginza",
    hashtag: "#EndlessLuxury",
    description: "Tokyo's flashy entertainment district, where luxury boutiques and gourmet eateries make for the chicest stroll.",
    hashtag_description: "Shop till you drop and dine at Michelin-star restaurants while popping into tiny art galleries at your pace.",
    city: "Tokyo",
    map_pin: "35.66956, 139.76811",
    tags: "Fancy"
  }
]

neighbourhoods = neighbourhood_data.index_with do |attributes|
  Neighbourhood.find_or_initialize_by(name: attributes.fetch(:name)).tap do |neighbourhood|
    neighbourhood.update!(attributes)
  end
end.transform_keys { |attributes| attributes.fetch(:name) }

property_data = [
  {
    name: "Section L Hatchobori",
    slug: "hatchobori",
    address: "1 Chome-9-10 Irifune, Chuo City, Tokyo 104-0042",
    description: "The thoughtful space to come home to, a quieter residential pocket near Ginza and Tokyo Station.",
    neighbourhood_names: [ "Hatchobori" ]
  },
  {
    name: "Section L Ginza East",
    slug: "ginza-east",
    address: "1 Chome-14-5 Shintomi, Chuo City, Tokyo 104-0041",
    description: "Local bliss right next door to Ginza glitz, between Ginza's shops and Tsukiji's food.",
    neighbourhood_names: [ "Ginza", "Hatchobori" ]
  },
  {
    name: "Section L Residence Ginza",
    slug: "residence-ginza",
    address: "7 Chome-10-5 Ginza, Chuo City, Tokyo 104-0061",
    description: "Springboard to art galleries, luxury shopping, and Michelin-star restaurants.",
    neighbourhood_names: [ "Ginza" ]
  }
]

properties = property_data.index_with do |data|
  attributes = data.except(:neighbourhood_names).merge(city: "Tokyo")
  Property.find_or_initialize_by(slug: data.fetch(:slug)).tap do |property|
    property.update!(attributes)
    property.neighbourhoods = data.fetch(:neighbourhood_names).map { |name| neighbourhoods.fetch(name) }
  end
end.transform_keys { |data| data.fetch(:slug) }

city_gem_data = [
  {
    neighbourhood_names: [ "Ginza", "Hatchobori", "Tsukiji" ],
    name: "Turret Coffee",
    category: "Food & Drink",
    short: "Craft matcha latte by a former fish monger.",
    long: "You can't miss the bright red bench outside this cafe. Both artsy and eccentric, the menu features seasonal lattes and hot spiced cider.",
    maps: "https://www.google.com/maps/search/?api=1&query=Turret+Coffee+Tokyo"
  },
  {
    neighbourhood_names: [ "Ginza", "Hatchobori", "Tsukiji" ],
    name: "Maru",
    category: "Food & Drink",
    short: "A hidden wine and dine spot.",
    long: "If you're a wine lover, you can't skip this spot. You'll be impressed by the bottles of wine lined up along the wall. Tapas served there includes asparagus gratin and anchovy butter fries that will satisfy any light cravings.",
    maps: "https://www.google.com/maps/search/?api=1&query=Maru+Ginza+Tokyo"
  },
  {
    neighbourhood_names: [ "Ginza", "Hatchobori", "Tsukiji" ],
    name: "Nihombashi Sando",
    category: "Food & Drink",
    short: "Modern izakaya with classic dishes.",
    long: "The izakaya to go to if you are looking to sample Japanese dishes of the highest quality. Fresh sashimi, perfectly fried cream croquettes, and sake from Nagano are among visitors' favorites here.",
    maps: "https://www.google.com/maps/search/?api=1&query=Nihombashi+Sando+Tokyo"
  },
  {
    neighbourhood_names: [ "Ginza" ],
    name: "Postaco",
    category: "Shopping",
    short: "Founded in New York and now based in Tokyo, this design studio and brand has won fans worldwide.",
    long: "Founded in New York and now based in Tokyo, this design studio and brand has won fans worldwide. Its products, born from close observation of everyday life, range from stationery and bags to an enticing line of apparel.",
    maps: "https://www.google.com/maps/search/?api=1&query=Postaco+Tokyo"
  },
  {
    neighbourhood_names: [ "Ginza" ],
    name: "FEELSEN",
    category: "Shopping",
    short: "A place to treat yourself to carefully selected artisan items.",
    long: "Once sleeping quarters for kabuki actors, this shop now houses a fine selection of items curated by a well-traveled couple.",
    maps: "https://www.google.com/maps/search/?api=1&query=FEELSEN+Ginza+Tokyo"
  },
  {
    neighbourhood_names: [ "Ginza" ],
    name: "Ginza Six Rooftop",
    category: "Culture",
    short: "Look down at Ginza's bustling streets.",
    long: "Contains a secret shrine and gives you free views of Ginza's streets.",
    maps: "https://www.google.com/maps/search/?api=1&query=Ginza+Six+Rooftop+Tokyo"
  },
  {
    neighbourhood_names: [ "Hatchobori" ],
    name: "Cafe Ajito N",
    category: "Food & Drink",
    short: "The sheep standing outside is sure to catch your attention.",
    long: "A sheep stands guard here, where you can try lamb taco rice and a unique dates and almond latte.",
    maps: "https://www.google.com/maps/search/?api=1&query=Cafe+Ajito+N+Tokyo"
  },
  {
    neighbourhood_names: [ "Hatchobori" ],
    name: "Teppozu Inari Shrine",
    category: "Culture",
    short: "A shrine that has been relocated many times.",
    long: "Nestled in a residential area, it's quiet and peaceful. Don't miss the mini Mount Fuji at the back, made of lava from it, that you can walk up.",
    maps: "https://www.google.com/maps/search/?api=1&query=Teppozu+Inari+Shrine+Tokyo"
  },
  {
    neighbourhood_names: [ "Hatchobori" ],
    name: "Senmaiya",
    category: "Food & Drink",
    short: "Classic and tasty onigiri made with love.",
    long: "It is a tiny shop with a wide selection of onigiri rice balls, with brown rice as an option. Simple, tasty, ready to make your belly happy.",
    maps: "https://www.google.com/maps/search/?api=1&query=Senmaiya+Tokyo"
  },
  {
    neighbourhood_names: [ "Tsukiji" ],
    name: "Shukuba Ganso",
    category: "Food & Drink",
    short: "Omakase sushi hidden in an alley.",
    long: "Only 8 seats in here and 3 courses to choose from. The dining experience feels private and you can look forward to the chef's special selection of sushi.",
    maps: "https://www.google.com/maps/search/?api=1&query=Shukuba+Ganso+Tokyo"
  },
  {
    neighbourhood_names: [ "Tsukiji" ],
    name: "Ichifuji",
    category: "Shopping",
    short: "Pick up a unique souvenir here!",
    long: "If you want a practical souvenir, look no further! Ichifuji stocks a wide selection of kitchenware that can find a new home with you or serve as a special gift for someone.",
    maps: "https://www.google.com/maps/search/?api=1&query=Ichifuji+Tsukiji+Tokyo"
  },
  {
    neighbourhood_names: [ "Tsukiji" ],
    name: "Kunisuke Coffee",
    category: "Food & Drink",
    short: "Forest vibes on the outside, cozy on the inside.",
    long: "This cozy cafe overgrown with plants sells coffees and a delectable selection of ever-changing pastries. It also hosts puzzle games in Japanese on the second floor.",
    maps: "https://www.google.com/maps/search/?api=1&query=Kunisuke+Coffee+Tokyo"
  }
]

city_gem_data.each do |data|
  attributes = data.except(:neighbourhood_names)
  city_gem = CityGem.find_or_initialize_by(name: data.fetch(:name))
  city_gem.update!(attributes)
  city_gem.neighbourhoods = data.fetch(:neighbourhood_names).map { |name| neighbourhoods.fetch(name) }
end
