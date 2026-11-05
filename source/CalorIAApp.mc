import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class CalorIAApp extends Application.AppBase {

    var totalCalories = 0;

//Adição dos alimentos e suas calorias correspondentes - step 4
    var foodCalories = {
        :banana => {
            :name => "Banana",
            :category => "Fruta",
            :calories => 105,
            :portion => "1 unidade",

            :portionOptions => [
                {
                    :label => "100g", //Cada porção do alimento e sua devida caloria - step 15
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

        :apple => {
            :name => "Maçã",
            :category => "Fruta",
            :calories => 95,
            :portion => "1 unidade",
            :portionOptions => [
                "100g", "150g", "1 unidade", "2 unidades"
            ]
        }
    };

    function getFoodPortionOptions(food as Symbol) as Array? {
        var foods = foodCalories as Dictionary;
        var foodData = foods[food];

        if (foodData != null) {
            var data = foodData as Dictionary;
            return data[:portionOptions] as Array?;
        }

        return null;
    }

    //Uma função para adicionar calorias de um alimento específico ao total - step 3
    function addFood(food as Symbol) as Void {
        var foods = foodCalories as Dictionary;
        var foodData = foods[food];

        if (foodData != null) {
            var data = foodData as Dictionary;
            var calories = data[:calories];

            addCalories(calories as Number);
        }
    }


    function resetCalories() as Void {
        totalCalories = 0;
        Application.Storage.setValue("totalCalories", totalCalories); // Salva o valor atualizado do total de calorias
        WatchUi.requestUpdate(); // Solicita uma atualização da interface do usuário
    }

//Função para obter a chave do dia atual para armazenamento - step 11
    function getTodayKey() as String {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        return today.day.toString() + "-" + today.month.toString() + "-" + today.year.toString();
    }

//Adição de uma função para adicionar calorias ao total e atualizar a interface do usuário - step 1
    function addCalories(value as Number) as Void {
        totalCalories += value;

        Application.Storage.setValue("totalCalories", totalCalories);  // Salva o valor atualizado do total de calorias - step 5

        WatchUi.requestUpdate();
    }


//Função para obter o total de calorias - step 2
    function getTotalCalories() as Number {
        return totalCalories;
    }

    function initialize() {
        AppBase.initialize();
    }

    // A cada dia novo, o total de calorias é resetado para 0. Caso contrário, o valor salvo do total de calorias é recuperado - step 13
    function onStart(state as Dictionary?) as Void {
        var todayKey = getTodayKey();
        var savedDate = Application.Storage.getValue("lastSavedDate");

        var isNewDay = true;

        if (savedDate != null && savedDate.toString() == todayKey) {
            isNewDay = false;
        }

        if (isNewDay){
            totalCalories = 0;

            Application.Storage.setValue("totalCalories", totalCalories);
            Application.Storage.setValue("lastSavedDate", todayKey);
        } else {
            var savedCalories = Application.Storage.getValue("totalCalories");

// Recupera o valor salvo do total de calorias, se existir - step 4
            if (savedCalories != null) {
            totalCalories = savedCalories as Number;
            }
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new CalorIAView(), new CalorIADelegate() ];
    }

}

function getApp() as CalorIAApp {
    return Application.getApp() as CalorIAApp;
}