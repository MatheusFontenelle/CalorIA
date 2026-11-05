import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CalorIAMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            getApp().resetCalories(); // Reseta o total de calorias - step 7
        } else if (item == :item_2) {
            getApp().addFood(:apple); // Adiciona a maça ao total - step 5
        } else if (item == :item_3) {
            var portions = getApp().getFoodPortionOptions(:banana);
            var picker = new CalorIAPortionPicker("Banana", portions); // Cria o Picker de porções - step 13

            WatchUi.pushView(
                picker,
                new CalorIAPortionDelegate(),
                WatchUi.SLIDE_IMMEDIATE);; // Adiciona a banana ao total - step 6
        }
    }

}