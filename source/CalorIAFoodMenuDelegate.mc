import Toybox.Lang;
import Toybox.WatchUi;

class CalorIAFoodMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        MenuInputDelegate.initialize();
    }

    //essa função é chamada quando um item do menu é selecionado. Ela recebe o ID do alimento selecionado como parâmetro e busca as informações correspondentes no catálogo de alimentos. Em seguida, cria um seletor de porções (CalorIAPortionPicker) com as opções disponíveis para o alimento selecionado e substitui a lista de alimentos pelo seletor. Ao confirmar ou cancelar a seleção da porção, a tela volta à tela inicial.
    function onMenuItem(foodId as Symbol) as Void {
        var food = CalorIAFoodCatalog.getFood(foodId);

        if (food == null) {
            return;
        }

        var foodData = food as Dictionary;
        var portionOptions = foodData[:portionOptions];

        if (portionOptions == null) {
            return;
        }

        var portions = portionOptions as Array;
        if (portions.size() == 0) {
            return;
        }

        var storageId = foodData[:storageId] as String;
        var foodName = foodData[:name] as String;
        var picker = new CalorIAPortionPicker(foodName, portions);

        // Substitui a lista pelo seletor; ao confirmar ou cancelar, volta à tela inicial.
        WatchUi.switchToView(
            picker,
            new CalorIAPortionDelegate(storageId, foodName),
            WatchUi.SLIDE_UP
        );
    }
}

class CalorIAResetConfirmationDelegate extends WatchUi.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response as WatchUi.Confirm) as Boolean {
        if (response == WatchUi.CONFIRM_YES) {
            getApp().resetCalories();
        }

        return true;
    }
}
