import Toybox.Lang;
import Toybox.WatchUi;

class CalorIAFoodMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

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
        var picker = new CalorIAPortionPicker(
            foodName,
            portions
        );

        // Substitui a lista pelo seletor; ao confirmar ou cancelar, volta à tela inicial.
        WatchUi.switchToView(
            picker,
            new CalorIAPortionDelegate(storageId, foodName),
            WatchUi.SLIDE_UP
        );
    }
}
