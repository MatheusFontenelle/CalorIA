module CalorIAFoodCatalog {

    using Toybox.Lang as Lang;

    // Catálogo inicial. Cada porção guarda seu próprio rótulo e valor calórico.
    const FOODS = [
        {
            :id => :banana,
            :storageId => "banana",
            :name => "Banana",
            :category => "Fruta",
            :portionOptions => [
                {
                    :label => "100g",
                    :calories => 105
                },
                {
                    :label => "150g",
                    :calories => 157
                },
                {
                    :label => "1u (40g)",
                    :calories => 42
                },
                {
                    :label => "2u (80g)",
                    :calories => 84
                }
            ]
        },
        {
            :id => :apple,
            :storageId => "apple",
            :name => "Maçã",
            :category => "Fruta",
            :portionOptions => [
                {
                    :label => "1 unidade",
                    :calories => 95
                },
                {
                    :label => "2 unidades",
                    :calories => 190
                }
            ]
        }
    ];

    function getFoods() as Lang.Array {
        return FOODS;
    }

    function getFoodsByCategory(category as Lang.String) as Lang.Array {
        var foodsInCategory = [] as Lang.Array;

        for (var index = 0; index < FOODS.size(); index += 1) {
            var food = FOODS[index] as Lang.Dictionary;

            if (food[:category] == category) {
                foodsInCategory.add(food);
            }
        }

        return foodsInCategory;
    }

    function getCategories() as Lang.Array {
        var categories = [] as Lang.Array;

        for (var index = 0; index < FOODS.size(); index += 1) {
            var food = FOODS[index] as Lang.Dictionary;
            var category = food[:category] as Lang.String;

            if (categories.indexOf(category) == -1) {
                categories.add(category);
            }
        }

        return categories;
    }

    function getFood(foodId as Lang.Symbol) as Lang.Dictionary? {
        for (var index = 0; index < FOODS.size(); index += 1) {
            var food = FOODS[index] as Lang.Dictionary;

            if (food[:id] == foodId) {
                return food;
            }
        }

        return null;
    }
}
