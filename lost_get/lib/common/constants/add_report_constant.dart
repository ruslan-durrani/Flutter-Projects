class AddReportConstant {
  final bool? isDark;

  AddReportConstant({this.isDark});
  List<Map<String, dynamic>> getCategoryList() {
    return [
      {
        "id": 1,
        "title": "Electronics",
        "imageUrl": "assets/icons/electronics.svg",
        "subCat": [
          {"title": "Mobile Phones"},
          {"title": "Laptops"},
          {"title": "Tablets"},
          {"title": "Cameras"},
          {"title": "Headphones"},
          {"title": "Wearable Technology"},
          {"title": "Portable Gaming Devices"},
          {"title": "Chargers and Power Banks"},
          {"title": "Memory Cards and USB Drive"},
          {"title": "Other Accessories"},
        ]
      },
      {
        "id": 2,
        "title": "Personal Items",
        "imageUrl": "assets/icons/personal_item.svg",
        "subCat": [
          {"title": "Wallets and Purses"},
          {"title": "Personal Identification Documents"},
          {"title": "Credit and Debit Cards"},
          {"title": "Keys"},
          {"title": "Jewelry"}
        ]
      },
      {
        "id": 3,
        "title": "Clothing and Accessories",
        "imageUrl": "assets/icons/clothe.svg",
        "subCat": [
          {"title": "Coats and Jackets"},
          {"title": "Hats and Caps"},
          {"title": "Scarves and Gloves"},
          {"title": "Shoes and Boots"},
          {"title": "Bags and Backpacks"},
          {"title": "Belts"}
        ]
      },
      {
        "id": 4,
        "title": "Books and Documents",
        "imageUrl": "assets/icons/books.svg",
        "subCat": [
          {"title": "Diaries and Planners"},
          {"title": "Notebooks"},
          {"title": "Official Documents"},
        ]
      },
      {
        "id": 5,
        "title": "Travel Items",
        "imageUrl": "assets/icons/travel_item.svg",
        "subCat": [
          {"title": "Luggage"},
          {"title": "Notebooks"},
          {"title": "Travel Bags"},
          {"title": "Travel Accessories"},
          {"title": "Travel Documents"},
        ]
      },
      {
        "id": 6,
        "title": "Animals",
        "imageUrl": "assets/icons/animal.svg",
        "subCat": [
          {"title": "Dogs"},
          {"title": "Cats"},
          {"title": "Goats"},
          {"title": "Other Pets"},
          {"title": "Pet Collars"},
          {"title": "Pet Carriers"},
          {"title": "Travel Documents"},
        ]
      },
      {
        "id": 7,
        "title": "Miscellaneous",
        "imageUrl": "assets/icons/miscelleanous.svg",
        "subCat": [
          {"title": "Umbrellas"},
          {"title": "Food Containers"},
          {"title": "Electronic Gadgets "},
          {"title": "Other Miscellaneous Items"}
        ]
      },
      {
        "id": 8,
        "title": "Health and Beauty",
        "imageUrl": "assets/icons/beauty.svg",
        "subCat": [
          {"title": "Makeup and Cosmetics"},
          {"title": "Hair Accessories"},
          {"title": "Personal Care Items"},
          {"title": "Medications and Health Products"}
        ]
      },
      {
        "id": 9,
        "title": "Human",
        "imageUrl": "assets/icons/human.svg",
        "subCat": [
          {"title": "Children"},
          {"title": "Adults"}
        ]
      },
      {
        "id": 10,
        "title": "Office and School Supplies",
        "imageUrl": "assets/icons/office.svg", // Update with correct asset
        "subCat": [
          {"title": "Pens, Pencils, and Markers"},
          {"title": "Notebooks and Binders"},
          {"title": "Calculators"},
          {"title": "USB Drives and External Hard Drives"},
          {"title": "School Projects and Artworks"}
        ]
      },

      // New Category: Sports and Recreation
      {
        "id": 11,
        "title": "Sports and Recreation",
        "imageUrl": "assets/icons/sports.svg", // Update with correct asset
        "subCat": [
          {"title": "Sporting Equipment"},
          {"title": "Gym Gear"},
          {"title": "Outdoor Gear"},
          {"title": "Bicycles and Skateboards"},
          {"title": "Water Sports Equipment"}
        ]
      },

      // New Category: Musical Instruments
      {
        "id": 12,
        "title": "Musical Instruments",
        "imageUrl":
            "assets/icons/musical_instrument.svg", // Update with correct asset
        "subCat": [
          {"title": "Guitars"},
          {"title": "Violins"},
          {"title": "Keyboards and Pianos"},
          {"title": "Wind Instruments"},
          {"title": "Percussion Instruments"}
        ]
      },
    ];
  }

  List<Map<String, dynamic>> getLocationList() {
    return [
      {
        "id": 1,
        "title": "Azad Kashmir",
        "subLocation": [
          {"title": "Bagh, Azad Kashmir", "microLocation": []},
          {"title": "Mirpur, Azad Kashmir"},
          {"title": "Muzaffarabad, Azad Kashmir"},
          {"title": "Kotli, Azad Kashmir"},
          {"title": "Bhimber, Azad Kashmir"},
          {"title": "Rawalakot, Azad Kashmir"},
          {"title": "Barnala, Azad Kashmir"},
          {"title": "Neelum, Azad Kashmir"},
          {"title": "Pallandri, Azad Kashmir"},
          {"title": "Poonch, Azad Kashmir"},
          {"title": "Sudhnoti, Azad Kashmir"},
          {"title": "Others, Azad Kashmir"},
        ]
      },
    ];
  }
}
