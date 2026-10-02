import Toybox.Complications;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;


class RAMMSDelegate extends WatchUi.WatchFaceDelegate {

    function initialize() {
        WatchFaceDelegate.initialize();
    }


    // =================================================
    // TOUCH AND HOLD
    // =================================================

    function onPress(
        clickEvent as WatchUi.ClickEvent
    ) as Boolean {

        var coordinates =
            clickEvent.getCoordinates();

        var x = coordinates[0];
        var y = coordinates[1];


        // -------------------------------------------------
        // WEATHER HIT AREA
        //
        // Weather visual center:
        // X = 338
        // Icon Y = 98
        // Temperature Y = 108
        // -------------------------------------------------

        if (
            x >= 290 &&
            x <= 390 &&
            y >= 65 &&
            y <= 135
        ) {

            openWeather();

            return true;
        }


        // -------------------------------------------------
        // VITAL / HEART RATE HIT AREA
        //
        // Visual center:
        // X = 118
        // Label Y = 292
        // Value Y = 316
        // -------------------------------------------------

        if (
            x >= 70 &&
            x <= 165 &&
            y >= 275 &&
            y <= 345
        ) {

            openHeartRate();

            return true;
        }


        // -------------------------------------------------
        // STEP HIT AREA
        //
        // Visual center:
        // X = 227
        // Label Y = 292
        // Value Y = 312
        // -------------------------------------------------

        if (
            x >= 180 &&
            x <= 275 &&
            y >= 275 &&
            y <= 345
        ) {

            openSteps();

            return true;
        }


        return false;
    }


    // =================================================
    // OPEN HEART RATE
    // =================================================

    function openHeartRate() as Void {

        var heartRateId =
            new Complications.Id(
                Complications.COMPLICATION_TYPE_HEART_RATE
            );

        Complications.exitTo(
            heartRateId
        );
    }


    // =================================================
    // OPEN STEPS
    // =================================================

    function openSteps() as Void {

        var stepsId =
            new Complications.Id(
                Complications.COMPLICATION_TYPE_STEPS
            );

        Complications.exitTo(
            stepsId
        );
    }


    // =================================================
    // OPEN CURRENT WEATHER
    // =================================================

    function openWeather() as Void {

        var weatherId =
            new Complications.Id(
                Complications.COMPLICATION_TYPE_CURRENT_WEATHER
            );

        Complications.exitTo(
            weatherId
        );
    }

}