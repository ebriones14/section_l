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
    map_pin: "35.66966, 139.76811",
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
    maps: "https://maps.app.goo.gl/nftoMh5JJU4HDHjk8",
    image_url: "https://cms-media.section-l.co/20210513_Section_L_Ginza_9769_d5fc2129fc.jpg",
    tags: [ "Cafes" ]
  },
  {
    neighbourhood_names: [ "Ginza", "Hatchobori", "Tsukiji" ],
    name: "Maru",
    category: "Food & Drink",
    short: "A hidden wine and dine spot.",
    long: "If you're a wine lover, you can't skip this spot. You'll be impressed by the bottles of wine lined up along the wall. Tapas served there includes asparagus gratin and anchovy butter fries that will satisfy any light cravings.",
    maps: "https://maps.app.goo.gl/p732xJiykxpnDPaJ6",
    image_url: "https://cms-media.section-l.co/20210514_Section_L_Ginza_0284_7e0d8683bc.jpg",
    tags: [ "Restaurants", "International Cuisine", "Bars" ]
  },
  {
    neighbourhood_names: [ "Ginza", "Hatchobori", "Tsukiji" ],
    name: "Nihombashi Sando",
    category: "Food & Drink",
    short: "Modern izakaya with classic dishes.",
    long: "The izakaya to go to if you are looking to sample Japanese dishes of the highest quality. Fresh sashimi, perfectly fried cream croquettes, and sake from Nagano are among visitors' favorites here.",
    maps: "https://maps.app.goo.gl/gGq6y8YYTazMtGqd7",
    image_url: "https://cms-media.section-l.co/20210514_Section_L_Ginza_0199_5640316bd5.jpg",
    tags: [ "Japanese Food", "Restaurants" ]
  },
  {
    neighbourhood_names: [ "Ginza" ],
    name: "Postalco",
    legacy_names: [ "Postaco" ],
    category: "Shopping",
    short: "Founded in New York and now based in Tokyo, this design studio and brand has won fans worldwide.",
    long: "Founded in New York and now based in Tokyo, this design studio and brand has won fans worldwide. Its products, born from close observation of everyday life, range from stationery and bags to an encicing line of apparel.",
    maps: "https://maps.app.goo.gl/8oyR8zXPDStanhvH7",
    image_url: "https://cms-media.section-l.co/AM_0_S8_A9393_a86ea2198f.jpg",
    tags: [ "Family-Friendly" ]
  },
  {
    neighbourhood_names: [ "Ginza" ],
    name: "FEELLSEEN",
    legacy_names: [ "FEELSEN" ],
    category: "Shopping",
    short: "A place to treat yourself to carefully selected artisan items.",
    long: "Once sleeping quarters for kabuki actors, this shop now houses a fine selection of items curated by a well-traveled couple.",
    maps: "https://goo.gl/maps/oiaa7X3sMC7CdeAW9",
    image_url: "https://cms-media.section-l.co/Section_L_2310_cfd718474d.jpg",
    tags: [ "Souvenirs" ]
  },
  {
    neighbourhood_names: [ "Ginza" ],
    name: "Ginza Six Rooftop",
    category: "Culture",
    short: "Look down at Ginza's bustling streets.",
    long: "Contains a secret shrine and gives you free views of Ginza's streets.",
    maps: "https://goo.gl/maps/oLrCstHkyURAgXBM9",
    tags: []
  },
  {
    neighbourhood_names: [ "Hatchobori" ],
    name: "Cafe Ajito .N",
    legacy_names: [ "Cafe Ajito N" ],
    category: "Food & Drink",
    short: "The sheep standing outside is sure to catch your attention.",
    long: "A sheep stands guard here, where you can try lamb taco rice and a unique dates and almond latte.",
    maps: "https://maps.app.goo.gl/URRaoJrZVAKe4kGD6",
    tags: []
  },
  {
    neighbourhood_names: [ "Hatchobori" ],
    name: "Teppozu Inari Shrine",
    category: "Culture",
    short: "A shrine that has been relocated many times.",
    long: "Nestled in a residential area, it's quiet and peaceful. Don't miss the mini Mount Fuji at the back, made of lava from it, that you can walk up.",
    maps: "https://maps.app.goo.gl/6bqMjftANxJBWsT9A",
    tags: []
  },
  {
    neighbourhood_names: [ "Hatchobori" ],
    name: "Senmaiya",
    category: "Food & Drink",
    short: "Classic and tasty onigiri made with love.",
    long: "It is a tiny shop with a wide selection of onigiri (rice balls), with brown rice as an option. Simple, tasty, ready to make your belly happy.",
    maps: "https://maps.app.goo.gl/EHGjjr4zyvJKxjuv6",
    tags: []
  },
  {
    neighbourhood_names: [ "Tsukiji" ],
    name: "Shutoku Ganso",
    legacy_names: [ "Shukuba Ganso" ],
    category: "Food & Drink",
    short: "Omakase sushi hidden in an alley.",
    long: "Only 8 seats in here and 3 courses to choose from. The dining experience feels private and you can look forward to the chef's special selection of sushi.",
    maps: "https://goo.gl/maps/cHWQmovv5T8ZcM5n6",
    image_url: "https://cms-media.section-l.co/Section_L_Tsukiji_City_Gems_6157_b7eeb7f3db.jpg",
    tags: [ "Sushi", "Japanese Food", "Restaurants" ]
  },
  {
    neighbourhood_names: [ "Tsukiji" ],
    name: "Ichifuji",
    category: "Shopping",
    short: "Pick up a unique souvenir here!",
    long: "If you want a practical souvenir, look no further! Ichifuji stocks a wide selection of kitchenware that can find a new home with you or serve as a special gift for someone.",
    maps: "https://goo.gl/maps/Xt5d17w7uAZVMUmb6",
    image_url: "https://cms-media.section-l.co/Section_L_Tsukiji_City_Gems_5842_f44d0f424f.jpg",
    tags: [ "Souvenirs" ]
  },
  {
    neighbourhood_names: [ "Tsukiji" ],
    name: "Kunisuke Coffee",
    category: "Food & Drink",
    short: "Forest vibes on the outside, cozy on the inside.",
    long: "This cozy cafe overgrown with plants sells coffees and a delectable selection of ever-changing pastries. It also hosts puzzle games in Japanese on the second floor.",
    maps: "https://goo.gl/maps/UK2sJdRQJ8Gv43kM8",
    image_url: "https://cms-media.section-l.co/Section_L_Tsukiji_City_Gems_5633_5f71aeba22.jpg",
    tags: [ "Cafes" ]
  }
]

city_gem_data.each do |data|
  attributes = data.except(:legacy_names, :neighbourhood_names)
  names = [ data.fetch(:name), *data.fetch(:legacy_names, []) ]
  city_gem = CityGem.find_by(name: names) || CityGem.new(name: data.fetch(:name))
  city_gem.update!(attributes)
  city_gem.neighbourhoods = data.fetch(:neighbourhood_names).map { |name| neighbourhoods.fetch(name) }
end
