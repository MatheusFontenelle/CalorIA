import Toybox.Lang;
import Toybox.WatchUi;

class CalorIAMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        MenuInputDelegate.initialize();
    }

    //essa função é chamada quando o usuário seleciona um item do menu. Dependendo do item selecionado, a função executa diferentes ações, como abrir o menu de alimentos, abrir o menu de histórico, resetar as calorias do dia ou desfazer a última entrada de alimento. A função utiliza a classe WatchUi para gerenciar a interface do usuário e interagir com o aplicativo principal.
    function onMenuItem(item as Symbol) as Void {
        if (item == :add_food) {
            openCategoryMenu();
        } else if (item == :view_history) {
            openHistoryMenu();
        } else if (item == :reset_day) {
            self.openResetConfirmation();
        } else if (item == :undo_last) {
            getApp().undoLastFoodEntry();
        }
    }

    function openResetConfirmation() as Void {
        var confirmation = new WatchUi.Confirmation(
            "Zerar hoje?"
        );

        WatchUi.pushView(
            confirmation,
            new CalorIAResetConfirmationDelegate(),
            WatchUi.SLIDE_UP
        );
    }

    //essa função abre o menu de alimentos, exibindo uma lista de alimentos disponíveis para o usuário selecionar. Cada alimento é representado por seu nome e um identificador simbólico. A função utiliza a classe WatchUi para criar e exibir o menu, permitindo que o usuário escolha um alimento para adicionar ao registro diário de consumo.
    function openCategoryMenu() as Void {
        var categoryMenu = new WatchUi.Menu2({ :title => "Categorias" });
        var categories = CalorIAFoodCatalog.getCategories() as Array;

        for (var index = 0; index < categories.size(); index += 1) {
            var category = categories[index] as String;
            var foodCount =
                CalorIAFoodCatalog.getFoodsByCategory(category).size();
            var countLabel = "itens";

            if (foodCount == 1) {
                countLabel = "item";
            }

            var subLabel = foodCount.toString() + " " + countLabel;

            categoryMenu.addItem(
                new WatchUi.MenuItem(category, subLabel, category, {})
            );
        }

        WatchUi.switchToView(
            categoryMenu,
            new CalorIACategoryMenuDelegate(),
            WatchUi.SLIDE_UP
        );
    }

    //essa função abre o menu de histórico de entradas de alimentos do dia atual, exibindo cada entrada com o nome do alimento, o rótulo da porção e o valor calórico correspondente. Se não houver registros para o dia, a função exibe uma mensagem indicando que não há registros. A função utiliza a classe WatchUi para criar e exibir o menu, permitindo que o usuário visualize seu histórico de consumo de alimentos.
    function openHistoryMenu() as Void {
        var historyMenu = new WatchUi.Menu2({ :title => "Hoje" });
        var entries = getApp().getTodayEntries() as Array<Dictionary>;

        if (entries.size() == 0) {
            historyMenu.addItem(
                new WatchUi.MenuItem(
                    "Sem registros",
                    "",
                    :empty_history,
                    {}
                )
            );
        } else {
            for (var index = 0; index < entries.size(); index += 1) {
                var entry = entries[index] as Dictionary;
                var foodName = entry["foodName"] as String;
                var portionLabel = entry["portionLabel"] as String;
                var calories = entry["calories"] as Number;
                var label =
                    portionLabel + " - " + calories.toString() + " kcal ";

                historyMenu.addItem(
                    new WatchUi.MenuItem(foodName, label, index, {})
                );
            }
        }

        WatchUi.pushView(
            historyMenu,
            new CalorIAHistoryMenuDelegate(),
            WatchUi.SLIDE_UP
        );
    }
}

class CalorIAHistoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

//essa classe é responsável por lidar com a seleção de categorias no menu de categorias. Quando o usuário seleciona uma categoria, a função onSelect é chamada, que busca os alimentos correspondentes à categoria selecionada e cria um novo menu de alimentos. Em seguida, o menu de alimentos é exibido na tela, permitindo que o usuário escolha um alimento específico para adicionar ao registro diário de consumo.
class CalorIACategoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var category = item.getId() as String;
        var foods = CalorIAFoodCatalog.getFoodsByCategory(category) as Array;
        var foodMenu = new WatchUi.Menu();

        foodMenu.setTitle(category);

        for (var index = 0; index < foods.size(); index += 1) {
            var food = foods[index] as Dictionary;

            foodMenu.addItem(food[:name] as String, food[:id] as Symbol);
        }

        WatchUi.switchToView(
            foodMenu,
            new CalorIAFoodMenuDelegate(),
            WatchUi.SLIDE_UP
        );
    }
}
