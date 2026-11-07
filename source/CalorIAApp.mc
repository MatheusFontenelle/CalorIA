import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

class CalorIAApp extends Application.AppBase {
    var todayEntries = [] as Array<Dictionary>;

    function resetCalories() as Void {
        todayEntries = [];
        saveTodayEntries();
        WatchUi.requestUpdate();
    }

    //essa função retorna uma chave única para o dia atual no formato "dia-mês-ano", que é usada para identificar e armazenar as entradas de alimentos consumidos no dia específico. A função utiliza a classe Gregorian do módulo Time para obter informações sobre a data atual.
    function getTodayKey() as String {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);

        return (
            today.day.toString() +
            "-" +
            today.month.toString() +
            "-" +
            today.year.toString()
        );
    }

    //essa funçao adiciona uma nova entrada de alimento ao array todayEntries, que representa os alimentos consumidos no dia atual. Cada entrada contém o ID do alimento, o nome do alimento, o rótulo da porção e o valor calórico correspondente. Após adicionar a entrada, a função salva as entradas do dia atual no armazenamento do aplicativo e solicita uma atualização da interface do usuário para refletir a mudança.
    function addFoodEntry(
        foodId as String,
        foodName as String,
        portionLabel as String,
        calories as Number
    ) as Void {
        var entry = {
            "foodId" => foodId,
            "foodName" => foodName,
            "portionLabel" => portionLabel,
            "calories" => calories,
        };

        todayEntries.add(entry);
        saveTodayEntries();
        WatchUi.requestUpdate();
    }

    //essa função remove a última entrada de alimento do dia, se houver alguma, e atualiza a tela para refletir a mudança.
    function undoLastFoodEntry() as Void {
        var entryCount = todayEntries.size();

        if (entryCount == 0) {
            return;
        }

        todayEntries = todayEntries.slice(0, entryCount - 1);
        saveTodayEntries();
        WatchUi.requestUpdate();
    }

    //essa função retorna o número de entradas de alimentos registradas no dia atual, permitindo que o aplicativo saiba quantos alimentos foram consumidos até o momento.
    function getTodayEntryCount() as Number {
        return todayEntries.size();
    }

    //essa função calcula o total de calorias consumidas no dia atual, somando os valores calóricos de todas as entradas de alimentos armazenadas no array todayEntries. A função retorna o total de calorias como um número.
    function getTotalCalories() as Number {
        var total = 0;
        var entries = todayEntries as Array<Dictionary>;

        for (var index = 0; index < entries.size(); index++) {
            var entry = entries[index] as Dictionary;
            var calories = entry["calories"];

            if (calories != null) {
                total += calories as Number;
            }
        }

        return total;
    }

    function getTodayEntries() as Array {
        return todayEntries.slice(0, todayEntries.size());
    }

    //essa função salva as entradas de alimentos do dia atual no armazenamento do aplicativo, associando-as a uma chave específica que representa o dia atual. Além disso, a função também armazena a data da última vez que as entradas foram salvas, permitindo que o aplicativo recupere corretamente os dados ao ser reiniciado ou quando o usuário abrir o aplicativo em outro momento.
    function saveTodayEntries() as Void {
        Application.Storage.setValue("todayEntries", todayEntries);
        Application.Storage.setValue("lastSavedDate", getTodayKey());
    }

    function initialize() {
        AppBase.initialize();
    }

    //essa função é chamada quando o aplicativo é iniciado. Ela verifica se há entradas de alimentos salvas para o dia atual e, se houver, as carrega para o array todayEntries. Caso contrário, a função inicializa o array como vazio e salva as entradas do dia atual no armazenamento do aplicativo. Além disso, a função também lida com a migração de dados antigos, garantindo que os registros anteriores sejam preservados.
    function onStart(state as Dictionary?) as Void {
        var todayKey = getTodayKey();
        var savedDate = Application.Storage.getValue("lastSavedDate");

        if (savedDate != null && savedDate.toString() == todayKey) {
            var savedEntries = Application.Storage.getValue("todayEntries");

            if (savedEntries != null) {
                todayEntries = savedEntries as Array<Dictionary>;
            } else {
                // Migra o total antigo para uma entrada única sem perder o valor do dia.
                todayEntries = [] as Array<Dictionary>;
                var savedCalories =
                    Application.Storage.getValue("totalCalories");

                if (savedCalories != null && (savedCalories as Number) > 0) {
                    var legacyEntry =
                        ({
                            "foodId" => "legacy",
                            "foodName" => "Total anterior",
                            "portionLabel" => "Registro antes do histórico",
                            "calories" => savedCalories as Number,
                        }) as Dictionary;
                    todayEntries.add(legacyEntry);
                }

                saveTodayEntries();
            }
        } else {
            todayEntries = [];
            saveTodayEntries();
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {}

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [new CalorIAView(), new CalorIADelegate()];
    }
}

function getApp() as CalorIAApp {
    return Application.getApp() as CalorIAApp;
}
