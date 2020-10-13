//
//  Flowers.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import Foundation

class PlantsSpecies: Decodable {
    var name: String
    init(name: String) {
        self.name = name
    }
    static func decodeFlowers() -> [PlantsSpecies]? {
        do {
            return try JSONDecoder().decode([PlantsSpecies].self, from: flowersJSONData)
        } catch {
            return nil
        }
    }
    
    static let flowersJSONData = """
[
  {
    "id": "1598925749-189",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Moss Rose"
  },
  {
    "id": "1598925749-4",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Agapanthus"
  },
  {
    "id": "1598925749-64",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Columbine"
  },
  {
    "id": "1598925749-21",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bee Balm"
  },
  {
    "id": "1598925749-240",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Rose of Sharon"
  },
  {
    "id": "1598925749-72",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cotoneaster"
  },
  {
    "id": "1598925749-222",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Photinia"
  },
  {
    "id": "1598925749-58",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Chicory"
  },
  {
    "id": "1598925749-273",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Valerian"
  },
  {
    "id": "1598925749-22",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Begonia"
  },
  {
    "id": "1598925749-157",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Kangaroo Paw"
  },
  {
    "id": "1598925749-135",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Heliotrope"
  },
  {
    "id": "1598925749-63",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Clover"
  },
  {
    "id": "1598925749-257",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Sweet Pea"
  },
  {
    "id": "1598925749-116",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Foxglove"
  },
  {
    "id": "1598925749-196",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "New Zealand Tea Tree"
  },
  {
    "id": "1598925749-127",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Goldenrod"
  },
  {
    "id": "1598925749-27",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Black-eyed Susan"
  },
  {
    "id": "1598925749-233",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Queen of the Meadow"
  },
  {
    "id": "1598925749-158",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Knautia"
  },
  {
    "id": "1598925749-143",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hydrangea"
  },
  {
    "id": "1598925749-249",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Snapdragon"
  },
  {
    "id": "1598925749-293",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Xylosma"
  },
  {
    "id": "1598925749-172",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lotus"
  },
  {
    "id": "1598925749-149",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Iris"
  },
  {
    "id": "1598925749-94",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dutch Iris"
  },
  {
    "id": "1598925749-93",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Disa"
  },
  {
    "id": "1598925749-139",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hollyhock"
  },
  {
    "id": "1598925749-276",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Viola"
  },
  {
    "id": "1598925749-285",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Whirling Butterflies"
  },
  {
    "id": "1598925749-24",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bergamot"
  },
  {
    "id": "1598925749-26",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Billbergia"
  },
  {
    "id": "1598925749-39",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Brassica"
  },
  {
    "id": "1598925749-42",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Butterfly Bush"
  },
  {
    "id": "1598925749-124",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Geranium"
  },
  {
    "id": "1598925749-121",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Gaillardia"
  },
  {
    "id": "1598925749-85",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Delphinium"
  },
  {
    "id": "1598925749-96",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Echium"
  },
  {
    "id": "1598925749-54",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Catharanthus"
  },
  {
    "id": "1598925749-252",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Soapwort"
  },
  {
    "id": "1598925749-129",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Guzmania"
  },
  {
    "id": "1598925749-182",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Mayflower"
  },
  {
    "id": "1598925749-170",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lily"
  },
  {
    "id": "1598925749-224",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Pincushion Flower"
  },
  {
    "id": "1598925749-291",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Xerophyllum"
  },
  {
    "id": "1598925749-195",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Nerine"
  },
  {
    "id": "1598925749-32",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bluestar Flower"
  },
  {
    "id": "1598925749-160",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lady’s Slipper"
  },
  {
    "id": "1598925749-76",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cuckoo Flower"
  },
  {
    "id": "1598925749-140",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Honeysuckle"
  },
  {
    "id": "1598925749-126",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Gladiolas"
  },
  {
    "id": "1598925749-141",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hosta"
  },
  {
    "id": "1598925749-188",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Morning Glory"
  },
  {
    "id": "1598925749-190",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Narcissus"
  },
  {
    "id": "1598925749-113",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Forget Me Not"
  },
  {
    "id": "1598925749-123",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Gazania"
  },
  {
    "id": "1598925749-25",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bergenia"
  },
  {
    "id": "1598925749-263",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Trillium"
  },
  {
    "id": "1598925749-173",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Love in the Mist"
  },
  {
    "id": "1598925749-279",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Wandflower"
  },
  {
    "id": "1598925749-271",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ursinia"
  },
  {
    "id": "1598925749-174",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lunaria"
  },
  {
    "id": "1598925749-165",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lavender"
  },
  {
    "id": "1598925749-255",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Statice"
  },
  {
    "id": "1598925749-11",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Amaryllis"
  },
  {
    "id": "1598925749-216",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Penstemon"
  },
  {
    "id": "1598925749-53",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Carnation"
  },
  {
    "id": "1598925749-297",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Yellow-eyed Grass"
  },
  {
    "id": "1598925749-77",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cyclamen"
  },
  {
    "id": "1598925749-38",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Brachyscome"
  },
  {
    "id": "1598925749-268",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tuberose"
  },
  {
    "id": "1598925749-281",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Watsonia"
  },
  {
    "id": "1598925749-74",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Crocus"
  },
  {
    "id": "1598925749-97",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Elder"
  },
  {
    "id": "1598925749-236",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Rain Lily"
  },
  {
    "id": "1598925749-213",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Passion Flower"
  },
  {
    "id": "1598925749-159",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Kniphofia"
  },
  {
    "id": "1598925749-136",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hellebore"
  },
  {
    "id": "1598925749-91",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dietes"
  },
  {
    "id": "1598925749-220",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Petunia"
  },
  {
    "id": "1598925749-292",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Xylobium"
  },
  {
    "id": "1598925749-70",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Corydalis"
  },
  {
    "id": "1598925749-133",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Helenium"
  },
  {
    "id": "1598925749-78",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Daffodil"
  },
  {
    "id": "1598925749-86",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Desert Rose"
  },
  {
    "id": "1598925749-201",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Orchid"
  },
  {
    "id": "1598925749-269",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tulip"
  },
  {
    "id": "1598925749-296",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Yellow Bell"
  },
  {
    "id": "1598925749-66",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Coral Bells"
  },
  {
    "id": "1598925749-254",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Starflower"
  },
  {
    "id": "1598925749-283",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Wedelia"
  },
  {
    "id": "1598925749-286",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Winter Jasmine"
  },
  {
    "id": "1598925749-168",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lilac"
  },
  {
    "id": "1598925749-180",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Marigold"
  },
  {
    "id": "1598925749-214",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Peace Lily"
  },
  {
    "id": "1598925749-118",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Freesia"
  },
  {
    "id": "1598925749-60",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Chrysanthemum"
  },
  {
    "id": "1598925749-227",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Potentilla"
  },
  {
    "id": "1598925749-259",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tiger Flower"
  },
  {
    "id": "1598925749-264",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Triteleia"
  },
  {
    "id": "1598925749-12",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Anemone"
  },
  {
    "id": "1598925749-36",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bottlebrush"
  },
  {
    "id": "1598925749-14",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Armeria Maritima"
  },
  {
    "id": "1598925749-61",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Clarkia"
  },
  {
    "id": "1598925749-37",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bouvardia"
  },
  {
    "id": "1598925749-203",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Oriental Poppy"
  },
  {
    "id": "1598925749-40",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Broom"
  },
  {
    "id": "1598925749-101",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Erica"
  },
  {
    "id": "1598925749-100",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Eremurus"
  },
  {
    "id": "1598925749-232",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Queen Anne’s Lace"
  },
  {
    "id": "1598925749-71",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cosmos"
  },
  {
    "id": "1598925749-260",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tithonia"
  },
  {
    "id": "1598925749-65",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Coneflower"
  },
  {
    "id": "1598925749-200",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Olearia"
  },
  {
    "id": "1598925749-88",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dianella"
  },
  {
    "id": "1598925749-137",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hibiscus"
  },
  {
    "id": "1598925749-83",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Daylily"
  },
  {
    "id": "1598925749-108",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Firethorn"
  },
  {
    "id": "1598925749-73",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Crocosmia"
  },
  {
    "id": "1598925749-62",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Clematis"
  },
  {
    "id": "1598925749-154",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Johnny Jump Up"
  },
  {
    "id": "1598925749-221",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Phlox"
  },
  {
    "id": "1598925749-186",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Monk’s Hood"
  },
  {
    "id": "1598925749-130",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hawthorn"
  },
  {
    "id": "1598925749-246",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Sedum"
  },
  {
    "id": "1598925749-241",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Sage"
  },
  {
    "id": "1598925749-56",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Celosia"
  },
  {
    "id": "1598925749-43",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Calceolaria"
  },
  {
    "id": "1598925749-295",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Yellow Archangel"
  },
  {
    "id": "1598925749-80",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Daisy"
  },
  {
    "id": "1598925749-238",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Rondeletia"
  },
  {
    "id": "1598925749-284",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Weigela"
  },
  {
    "id": "1598925749-55",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Catmint"
  },
  {
    "id": "1598925749-115",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Four O’clock"
  },
  {
    "id": "1598925749-51",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cape Primrose"
  },
  {
    "id": "1598925749-30",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bleeding Heart"
  },
  {
    "id": "1598925749-45",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "California Poppy"
  },
  {
    "id": "1598925749-120",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Fuchsia"
  },
  {
    "id": "1598925749-266",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Trollius"
  },
  {
    "id": "1598925749-161",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Laelia"
  },
  {
    "id": "1598925749-90",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Diascia"
  },
  {
    "id": "1598925749-171",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Linaria"
  },
  {
    "id": "1598925749-117",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Frangipani Flower"
  },
  {
    "id": "1598925749-122",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Gardenia"
  },
  {
    "id": "1598925749-212",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Parodia"
  },
  {
    "id": "1598925749-258",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tea Rose"
  },
  {
    "id": "1598925749-187",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Moraea"
  },
  {
    "id": "1598925749-208",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Oxeye Daisy"
  },
  {
    "id": "1598925749-228",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Polyanthus"
  },
  {
    "id": "1598925749-185",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Moonflower Vine"
  },
  {
    "id": "1598925749-103",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Euphorbia"
  },
  {
    "id": "1598925749-274",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Verbena"
  },
  {
    "id": "1598925749-57",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cerastium Tomentosum"
  },
  {
    "id": "1598925749-290",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Xanthoceras sorbifolium"
  },
  {
    "id": "1598925749-18",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bachelor’s Button"
  },
  {
    "id": "1598925749-179",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Marguerite Daisy"
  },
  {
    "id": "1598925749-106",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Fall Crocus"
  },
  {
    "id": "1598925749-181",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Matthiola"
  },
  {
    "id": "1598925749-206",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Osteospermum"
  },
  {
    "id": "1598925749-278",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Wallflower"
  },
  {
    "id": "1598925749-31",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bletilla"
  },
  {
    "id": "1598925749-35",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Borage"
  },
  {
    "id": "1598925749-125",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Gerbera Flower"
  },
  {
    "id": "1598925749-191",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Nasturtium"
  },
  {
    "id": "1598925749-3",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "African Daisy"
  },
  {
    "id": "1598925749-183",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Meconopsis"
  },
  {
    "id": "1598925749-226",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Poinsettia"
  },
  {
    "id": "1598925749-231",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Quaker Ladies"
  },
  {
    "id": "1598925749-15",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Aster"
  },
  {
    "id": "1598925749-192",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Nemesia"
  },
  {
    "id": "1598925749-250",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Snowdrop"
  },
  {
    "id": "1598925749-111",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Flax Flower"
  },
  {
    "id": "1598925749-247",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Shasta Daisy"
  },
  {
    "id": "1598925749-142",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hyacinth"
  },
  {
    "id": "1598925749-209",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Oyster Plant"
  },
  {
    "id": "1598925749-48",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Candytuft"
  },
  {
    "id": "1598925749-215",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Pelargonium"
  },
  {
    "id": "1598925749-119",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "French Marigold"
  },
  {
    "id": "1598925749-218",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Periwinkle"
  },
  {
    "id": "1598925749-239",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Roses"
  },
  {
    "id": "1598925749-33",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bluebonnets"
  },
  {
    "id": "1598925749-150",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ixia"
  },
  {
    "id": "1598925749-275",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Viburnum"
  },
  {
    "id": "1598925749-2",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Aconite"
  },
  {
    "id": "1598925749-199",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Oleander"
  },
  {
    "id": "1598925749-298",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Zenobia"
  },
  {
    "id": "1598925749-68",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Coreopsis"
  },
  {
    "id": "1598925749-34",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Blue-eyed Grass"
  },
  {
    "id": "1598925749-132",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hebe"
  },
  {
    "id": "1598925749-204",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ornamental Cherry"
  },
  {
    "id": "1598925749-198",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Nolana"
  },
  {
    "id": "1598925749-169",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lily of the Valley"
  },
  {
    "id": "1598925749-162",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lantana"
  },
  {
    "id": "1598925749-9",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Alyssum"
  },
  {
    "id": "1598925749-147",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Impatiens"
  },
  {
    "id": "1598925749-82",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Daphne"
  },
  {
    "id": "1598925749-49",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Canna Lily"
  },
  {
    "id": "1598925749-248",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Silene"
  },
  {
    "id": "1598925749-270",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Urn Plant"
  },
  {
    "id": "1598925749-197",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Nierembergia"
  },
  {
    "id": "1598925749-217",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Peony"
  },
  {
    "id": "1598925749-128",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Grape Hyacinth"
  },
  {
    "id": "1598925749-262",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Trachelium"
  },
  {
    "id": "1598925749-177",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Maltese Cross"
  },
  {
    "id": "1598925749-146",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Iceland Poppy"
  },
  {
    "id": "1598925749-109",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Flaming Katy"
  },
  {
    "id": "1598925749-10",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Amaranthus"
  },
  {
    "id": "1598925749-20",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ballota"
  },
  {
    "id": "1598925749-253",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Speedwell"
  },
  {
    "id": "1598925749-229",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Poppy"
  },
  {
    "id": "1598925749-46",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Calla Lily"
  },
  {
    "id": "1598925749-225",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Pinks"
  },
  {
    "id": "1598925749-144",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Hyssop"
  },
  {
    "id": "1598925749-44",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Calendula"
  },
  {
    "id": "1598925749-223",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Physostegia"
  },
  {
    "id": "1598925749-7",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Allium"
  },
  {
    "id": "1598925749-1",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Acacia"
  },
  {
    "id": "1598925749-81",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dandelion"
  },
  {
    "id": "1598925749-156",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Kalmia"
  },
  {
    "id": "1598925749-234",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Queen’s Cup"
  },
  {
    "id": "1598925749-299",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Zinnia"
  },
  {
    "id": "1598925749-193",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Nemophila"
  },
  {
    "id": "1598925749-205",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ornithogalum"
  },
  {
    "id": "1598925749-261",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tobacco Plant"
  },
  {
    "id": "1598925749-194",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Neoregelia"
  },
  {
    "id": "1598925749-164",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lavatera"
  },
  {
    "id": "1598925749-50",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cape Leadwort"
  },
  {
    "id": "1598925749-184",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Mimosa"
  },
  {
    "id": "1598925749-265",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Tritonia crocata"
  },
  {
    "id": "1598925749-211",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Pansy"
  },
  {
    "id": "1598925749-242",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Saint John’s Wort"
  },
  {
    "id": "1598925749-75",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Crown Imperial"
  },
  {
    "id": "1598925749-167",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lewesia"
  },
  {
    "id": "1598925749-16",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Azalea"
  },
  {
    "id": "1598925749-153",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Jasmine"
  },
  {
    "id": "1598925749-59",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Chionodoxa"
  },
  {
    "id": "1598925749-175",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lupin"
  },
  {
    "id": "1598925749-5",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ageratum"
  },
  {
    "id": "1598925749-134",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Helichrysum"
  },
  {
    "id": "1598925749-19",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Balloon Flower"
  },
  {
    "id": "1598925749-29",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Blazing Star"
  },
  {
    "id": "1598925749-104",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Eustoma"
  },
  {
    "id": "1598925749-6",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Alchemilla"
  },
  {
    "id": "1598925749-267",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Trumpet Vine"
  },
  {
    "id": "1598925749-148",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ipomoea Lobata"
  },
  {
    "id": "1598925749-52",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cardinal Flower"
  },
  {
    "id": "1598925749-84",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Decumaria"
  },
  {
    "id": "1598925749-87",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Deutzia"
  },
  {
    "id": "1598925749-235",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Quince"
  },
  {
    "id": "1598925749-69",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Cornflower"
  },
  {
    "id": "1598925749-251",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Snowflake"
  },
  {
    "id": "1598925749-17",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Baby’s Breath"
  },
  {
    "id": "1598925749-155",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Kaffir Lily"
  },
  {
    "id": "1598925749-230",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Powder Puff"
  },
  {
    "id": "1598925749-98",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "English Bluebell"
  },
  {
    "id": "1598925749-41",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Buttercup"
  },
  {
    "id": "1598925749-277",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Virginia Creeper"
  },
  {
    "id": "1598925749-294",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Yarrow"
  },
  {
    "id": "1598925749-163",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Larkspur"
  },
  {
    "id": "1598925749-152",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Jacob’s Ladder"
  },
  {
    "id": "1598925749-280",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Water lilies"
  },
  {
    "id": "1598925749-110",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Flannel Flower"
  },
  {
    "id": "1598925749-95",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Echinops"
  },
  {
    "id": "1598925749-245",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Scilla"
  },
  {
    "id": "1598925749-79",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dahlia"
  },
  {
    "id": "1598925749-105",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Evening Primrose"
  },
  {
    "id": "1598925749-99",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Epimedium"
  },
  {
    "id": "1598925749-256",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Sunflower"
  },
  {
    "id": "1598925749-28",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Blanket Flower"
  },
  {
    "id": "1598925749-151",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ixora"
  },
  {
    "id": "1598925749-287",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Winterberry"
  },
  {
    "id": "1598925749-89",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dianthus barbatus"
  },
  {
    "id": "1598925749-219",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Persian Buttercup"
  },
  {
    "id": "1598925749-47",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Camellia"
  },
  {
    "id": "1598925749-244",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Scented Geranium"
  },
  {
    "id": "1598925749-207",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Oxalis"
  },
  {
    "id": "1598925749-13",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Anise Hyssop"
  },
  {
    "id": "1598925749-138",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Holly"
  },
  {
    "id": "1598925749-210",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Painted Daisy"
  },
  {
    "id": "1598925749-288",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Wishbone Flower"
  },
  {
    "id": "1598925749-131",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Heather"
  },
  {
    "id": "1598925749-145",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Ice Plant"
  },
  {
    "id": "1598925749-176",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Magnolia"
  },
  {
    "id": "1598925749-243",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Scaevola"
  },
  {
    "id": "1598925749-114",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Forsythia"
  },
  {
    "id": "1598925749-166",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Lemon Verbena"
  },
  {
    "id": "1598925749-272",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Uva Ursi"
  },
  {
    "id": "1598925749-8",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Alstroemeria"
  },
  {
    "id": "1598925749-202",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Oriental Lily"
  },
  {
    "id": "1598925749-112",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Flowering Dogwood"
  },
  {
    "id": "1598925749-92",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Dill"
  },
  {
    "id": "1598925749-23",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Bellflower"
  },
  {
    "id": "1598925749-107",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Feverfew"
  },
  {
    "id": "1598925749-102",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Erigeron"
  },
  {
    "id": "1598925749-237",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Rock Rose"
  },
  {
    "id": "1598925749-282",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Wax Plant"
  },
  {
    "id": "1598925749-289",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Woolly Violet"
  },
  {
    "id": "1598925749-67",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Coral Vine"
  },
  {
    "id": "1598925749-178",
    "url": "https://florgeous.com/types-of-flowers/",
    "name": "Mandevilla"
  }
]
""".data(using: .utf8)!
}
