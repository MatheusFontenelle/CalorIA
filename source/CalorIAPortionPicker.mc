import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//Classe para criar o Picker de porções - step 13
class CalorIAPortionFactory extends WatchUi.PickerFactory {

    var options as Array;

    function initialize(options as Array) {
        PickerFactory.initialize();
        self.options = options;
    }

    function getSize() as Number {
        return options.size();
    }

    function getValue(index as Number) as Object? {
        return options[index];
    }

    function getDrawable(index as Number, selected as Boolean) as WatchUi.Drawable? {
        var option = options[index] as Dictionary;
        var label = option[:label] as String;

        return new WatchUi.Text({
            :text => label,
            :font => Graphics.FONT_LARGE,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }
}

//Classe para mostrar o Picker de porções - step 14
class CalorIAPortionPicker extends WatchUi.Picker {

    function initialize(titleText as String, portionOptions as Array) {
        var title = new WatchUi.Text({
            :text => titleText,
            :font => Graphics.FONT_MEDIUM,
            :color => Graphics.COLOR_WHITE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_BOTTOM
        });

        var factory = new CalorIAPortionFactory(portionOptions);
        
        Picker.initialize({
            :title => title,
            :pattern => [factory],
            :defaults => [0]
        });
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        Picker.onUpdate(dc);
    }
}

//Classe para lidar com a seleção do Picker de porções - step 15
class CalorIAPortionDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onAccept(values as Array) as Boolean {
        var selectedOption = values[0] as Dictionary;
        var caloriesValue = selectedOption[:calories];
        var label = selectedOption[:label] as String;

        if (caloriesValue != null) {
            var calories = caloriesValue as Number;

            System.println(
                "Porcao escolhida: " + label + " - " + calories.toString() + " kcal"
            );

            getApp().addCalories(calories);
    }

    WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    return true;
}
}