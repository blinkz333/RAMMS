import Toybox.ActivityMonitor;
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Weather;


class RAMMSView extends WatchUi.WatchFace {

    private var _background;
    private var _timeFont;
    private var _dataFont;
    private var _isAod;


    function initialize() {
        WatchFace.initialize();

        _background = null;
        _timeFont = null;
        _dataFont = null;
        _isAod = false;
    }


    // =================================================
    // LOAD RESOURCES
    // =================================================

    function onLayout(dc as Dc) as Void {

        _background = WatchUi.loadResource(
            Rez.Drawables.RammsBackground
        );

        _timeFont = WatchUi.loadResource(
            Rez.Fonts.TimeFont
        );

        _dataFont = WatchUi.loadResource(
            Rez.Fonts.DateFont
        );
    }


    function onShow() as Void {
    }


    // =================================================
    // UPDATE
    // =================================================

    function onUpdate(dc as Dc) as Void {

        dc.setColor(
            Graphics.COLOR_WHITE,
            Graphics.COLOR_BLACK
        );

        dc.clear();


        // -------------------------------------------------
        // AOD / LOW POWER
        // -------------------------------------------------

        if (_isAod) {
            drawAod(dc);
            return;
        }


        // -------------------------------------------------
        // MAIN WATCH FACE
        // -------------------------------------------------

        if (_background != null) {

            dc.drawBitmap(
                0,
                0,
                _background
            );
        }


        // -------------------------------------------------
        // TIME
        // -------------------------------------------------

        var clockTime = System.getClockTime();

        var displayHour = clockTime.hour;

        var timeFormat = 0;

        var savedTimeFormat =
            Application.Properties.getValue(
                "timeFormat"
            );

        if (savedTimeFormat instanceof Number) {
            timeFormat = savedTimeFormat;
        }


        // -------------------------------------------------
        // TIME FORMAT
        //
        // 0 = System Default
        // 1 = 12 Hour
        // 2 = 24 Hour
        // -------------------------------------------------

        var use24Hour = true;


        if (timeFormat == 1) {

            use24Hour = false;

        } else if (timeFormat == 2) {

            use24Hour = true;

        } else {

            use24Hour =
                System.getDeviceSettings().is24Hour;
        }


        if (!use24Hour) {

            displayHour =
                displayHour % 12;

            if (displayHour == 0) {
                displayHour = 12;
            }
        }


        var hourString =
            displayHour.format("%02d");

        var minuteString =
            clockTime.min.format("%02d");


        drawTime(
            dc,
            hourString,
            minuteString,
            clockTime.sec
        );


        // -------------------------------------------------
        // DATE
        // -------------------------------------------------

        drawDateModule(dc);


        // -------------------------------------------------
        // WEATHER
        // -------------------------------------------------

        drawWeatherModule(dc);


        // -------------------------------------------------
        // STATUS
        // -------------------------------------------------

        drawStatusModules(dc);


        // -------------------------------------------------
        // STEP GOAL PROGRESS
        // -------------------------------------------------

        drawStepGoalProgress(dc);
    }


    // =================================================
    // TIME
    // =================================================

    function drawTime(
        dc as Dc,
        hourString as String,
        minuteString as String,
        seconds as Number
    ) as Void {

        var centerX = 227;
        var timeY = 150;

        var colonX = 227;
        var colonY = 137;

        var digitGap = 10;
        var centerGap = 24;

        var timeColor = 0xC9C3B8;


        var h1 = hourString.substring(0, 1);
        var h2 = hourString.substring(1, 2);

        var m1 = minuteString.substring(0, 1);
        var m2 = minuteString.substring(1, 2);


        var h1Width =
            dc.getTextWidthInPixels(
                h1,
                _timeFont
            );

        var h2Width =
            dc.getTextWidthInPixels(
                h2,
                _timeFont
            );

        var m1Width =
            dc.getTextWidthInPixels(
                m1,
                _timeFont
            );

        var m2Width =
            dc.getTextWidthInPixels(
                m2,
                _timeFont
            );


        var hourWidth =
            h1Width +
            digitGap +
            h2Width;


        dc.setColor(
            timeColor,
            Graphics.COLOR_TRANSPARENT
        );


        var hourX =
            centerX -
            centerGap -
            hourWidth;


        dc.drawText(
            hourX,
            timeY,
            _timeFont,
            h1,
            Graphics.TEXT_JUSTIFY_LEFT
        );


        hourX += h1Width + digitGap;


        dc.drawText(
            hourX,
            timeY,
            _timeFont,
            h2,
            Graphics.TEXT_JUSTIFY_LEFT
        );


        var minuteX =
            centerX +
            centerGap;


        dc.drawText(
            minuteX,
            timeY,
            _timeFont,
            m1,
            Graphics.TEXT_JUSTIFY_LEFT
        );


        minuteX += m1Width + digitGap;


        dc.drawText(
            minuteX,
            timeY,
            _timeFont,
            m2,
            Graphics.TEXT_JUSTIFY_LEFT
        );


        if ((seconds % 2) == 0) {

            drawGlowColon(
                dc,
                colonX,
                colonY
            );
        }
    }


    // =================================================
    // WHITE-HOT RED COLON
    // =================================================

    function drawGlowColon(
        dc as Dc,
        colonX as Number,
        colonY as Number
    ) as Void {

        dc.setColor(
            0x300000,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            colonX - 7,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX + 7,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY - 6,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY + 6,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX - 5,
            colonY - 4,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX + 5,
            colonY - 4,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX - 5,
            colonY + 4,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX + 5,
            colonY + 4,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0x800000,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            colonX - 4,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX + 4,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY - 4,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY + 4,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0xE00000,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            colonX - 2,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX + 2,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY - 2,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY + 2,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0xFF5050,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            colonX - 1,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX + 1,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY - 1,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.drawText(
            colonX,
            colonY + 1,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0xFFFFFF,
            Graphics.COLOR_TRANSPARENT
        );

        dc.drawText(
            colonX,
            colonY,
            _timeFont,
            ":",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }


    // =================================================
    // DATE MODULE
    // =================================================

    function drawDateModule(dc as Dc) as Void {

        var dateInfo =
            Gregorian.info(
                Time.now(),
                Time.FORMAT_SHORT
            );


        var dateX = 115;
        var dayX = 124;

        var dayY = 90;
        var dateY = 108;


        var dayNames = [
            "SUN",
            "MON",
            "TUE",
            "WED",
            "THU",
            "FRI",
            "SAT"
        ];


        var dayText =
            dayNames[
                dateInfo.day_of_week - 1
            ];


        var monthNames = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
        ];


        var monthText =
            monthNames[
                dateInfo.month - 1
            ];


        var dateText =
            dateInfo.day.format("%02d") +
            " " +
            monthText;


        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            dayX,
            dayY,
            _dataFont,
            dayText,
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            dateX,
            dateY,
            _dataFont,
            dateText,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }


    // =================================================
    // WEATHER MODULE
    // =================================================

    function drawWeatherModule(dc as Dc) as Void {

        var weatherX = 338;
        var iconY = 98;
        var temperatureY = 108;

        var temperatureX = weatherX + 4;


        var temperatureText = "--°";
        var condition = Weather.CONDITION_UNKNOWN;


        var conditions =
            Weather.getCurrentConditions();


        if (conditions != null) {

            if (conditions.temperature != null) {

                temperatureText =
                    conditions.temperature.format("%.0f") +
                    "°";
            }


            if (conditions.condition != null) {

                condition =
                    conditions.condition;
            }
        }


        drawWeatherIcon(
            dc,
            weatherX,
            iconY,
            condition
        );


        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            temperatureX,
            temperatureY,
            _dataFont,
            temperatureText,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }


    // =================================================
    // WEATHER ICON ROUTER
    // =================================================

    function drawWeatherIcon(
        dc as Dc,
        x as Number,
        y as Number,
        condition as Number
    ) as Void {

        dc.setPenWidth(3);


        if (
            condition == Weather.CONDITION_CLEAR ||
            condition == Weather.CONDITION_FAIR ||
            condition == Weather.CONDITION_MOSTLY_CLEAR ||
            condition == Weather.CONDITION_PARTLY_CLEAR
        ) {

            drawSunIcon(dc, x, y);
            return;
        }


        if (
            condition == Weather.CONDITION_THUNDERSTORMS ||
            condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS ||
            condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS
        ) {

            drawThunderIcon(dc, x, y);
            return;
        }


        if (
            condition == Weather.CONDITION_SNOW ||
            condition == Weather.CONDITION_LIGHT_SNOW ||
            condition == Weather.CONDITION_HEAVY_SNOW ||
            condition == Weather.CONDITION_CHANCE_OF_SNOW ||
            condition == Weather.CONDITION_FLURRIES ||
            condition == Weather.CONDITION_ICE ||
            condition == Weather.CONDITION_ICE_SNOW
        ) {

            drawSnowIcon(dc, x, y);
            return;
        }


        if (
            condition == Weather.CONDITION_RAIN ||
            condition == Weather.CONDITION_LIGHT_RAIN ||
            condition == Weather.CONDITION_HEAVY_RAIN ||
            condition == Weather.CONDITION_SCATTERED_SHOWERS ||
            condition == Weather.CONDITION_LIGHT_SHOWERS ||
            condition == Weather.CONDITION_SHOWERS ||
            condition == Weather.CONDITION_HEAVY_SHOWERS ||
            condition == Weather.CONDITION_CHANCE_OF_SHOWERS ||
            condition == Weather.CONDITION_DRIZZLE ||
            condition == Weather.CONDITION_FREEZING_RAIN
        ) {

            drawRainIcon(dc, x, y);
            return;
        }


        if (
            condition == Weather.CONDITION_PARTLY_CLOUDY ||
            condition == Weather.CONDITION_THIN_CLOUDS
        ) {

            drawPartlyCloudyIcon(dc, x, y);
            return;
        }


        drawCloudIcon(dc, x, y);
    }


    // =================================================
    // SUN
    // =================================================

    function drawSunIcon(
        dc as Dc,
        x as Number,
        y as Number
    ) as Void {

        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawCircle(x, y, 6);


        dc.drawLine(x, y - 12, x, y - 9);
        dc.drawLine(x, y + 9, x, y + 12);

        dc.drawLine(x - 12, y, x - 9, y);
        dc.drawLine(x + 9, y, x + 12, y);


        dc.drawLine(x - 8, y - 8, x - 6, y - 6);
        dc.drawLine(x + 6, y - 6, x + 8, y - 8);

        dc.drawLine(x - 8, y + 8, x - 6, y + 6);
        dc.drawLine(x + 6, y + 6, x + 8, y + 8);


        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.fillCircle(x, y, 3);
    }


    // =================================================
    // CLOUD
    // =================================================

    function drawCloudIcon(
        dc as Dc,
        x as Number,
        y as Number
    ) as Void {

        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.fillCircle(x - 7, y + 2, 5);
        dc.fillCircle(x, y - 2, 7);
        dc.fillCircle(x + 8, y + 2, 5);


        dc.fillRectangle(
            x - 11,
            y + 1,
            23,
            6
        );
    }


    // =================================================
    // PARTLY CLOUDY
    // =================================================

    function drawPartlyCloudyIcon(
        dc as Dc,
        x as Number,
        y as Number
    ) as Void {

        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.fillCircle(
            x - 7,
            y - 6,
            5
        );


        dc.drawLine(x - 7, y - 14, x - 7, y - 11);
        dc.drawLine(x - 15, y - 6, x - 12, y - 6);
        dc.drawLine(x - 13, y - 12, x - 11, y - 10);


        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.fillCircle(x - 5, y + 2, 5);
        dc.fillCircle(x + 2, y - 1, 7);
        dc.fillCircle(x + 9, y + 2, 5);


        dc.fillRectangle(
            x - 9,
            y + 1,
            23,
            6
        );
    }


    // =================================================
    // RAIN
    // =================================================

    function drawRainIcon(
        dc as Dc,
        x as Number,
        y as Number
    ) as Void {

        drawCloudIcon(
            dc,
            x,
            y - 4
        );


        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.setPenWidth(3);


        dc.drawLine(x - 7, y + 5, x - 10, y + 11);
        dc.drawLine(x, y + 5, x - 3, y + 11);
        dc.drawLine(x + 7, y + 5, x + 4, y + 11);
    }


    // =================================================
    // THUNDER
    // =================================================

    function drawThunderIcon(
        dc as Dc,
        x as Number,
        y as Number
    ) as Void {

        drawCloudIcon(
            dc,
            x,
            y - 5
        );


        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.setPenWidth(3);


        dc.drawLine(x + 2, y + 3, x - 3, y + 10);
        dc.drawLine(x - 3, y + 10, x + 2, y + 10);
        dc.drawLine(x + 2, y + 10, x - 3, y + 17);
    }


    // =================================================
    // SNOW
    // =================================================

    function drawSnowIcon(
        dc as Dc,
        x as Number,
        y as Number
    ) as Void {

        drawCloudIcon(
            dc,
            x,
            y - 5
        );


        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.setPenWidth(2);


        dc.drawLine(x - 7, y + 5, x - 7, y + 13);
        dc.drawLine(x - 11, y + 9, x - 3, y + 9);
        dc.drawLine(x - 10, y + 6, x - 4, y + 12);
        dc.drawLine(x - 4, y + 6, x - 10, y + 12);


        dc.drawLine(x + 7, y + 5, x + 7, y + 13);
        dc.drawLine(x + 3, y + 9, x + 11, y + 9);
        dc.drawLine(x + 4, y + 6, x + 10, y + 12);
        dc.drawLine(x + 10, y + 6, x + 4, y + 12);
    }
        // =================================================
    // STATUS MODULES
    // =================================================

    function drawStatusModules(dc as Dc) as Void {

        var info = System.getSystemStats();
        var activity = ActivityMonitor.getInfo();


        var heartRate = "--";


        var heartRateIterator =
            SensorHistory.getHeartRateHistory({
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            });


        if (heartRateIterator != null) {

            var sample =
                heartRateIterator.next();


            if (
                sample != null &&
                sample.data != null
            ) {

                heartRate =
                    sample.data.format("%d");
            }
        }


        var leftX = 118;
        var centerX = 227;
        var rightX = 338;

        var labelY = 292;

        var valueY = 316;
        var valueYCenter = 312;


        drawStatusModule(
            dc,
            leftX,
            labelY,
            valueY,
            "VITAL",
            heartRate
        );


        drawStepModule(
            dc,
            centerX,
            labelY,
            valueYCenter,
            activity.steps
        );


        drawBatteryModule(
            dc,
            rightX,
            labelY,
            valueY,
            info.battery
        );
    }


    // =================================================
    // SINGLE STATUS MODULE
    // =================================================

    function drawStatusModule(
        dc as Dc,
        x as Number,
        labelY as Number,
        valueY as Number,
        label as String,
        value as String
    ) as Void {

        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            x,
            labelY,
            _dataFont,
            label,
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            x,
            valueY,
            _dataFont,
            value,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }


    // =================================================
    // STEP MODULE
    // =================================================

    function drawStepModule(
        dc as Dc,
        x as Number,
        labelY as Number,
        valueY as Number,
        steps as Number
    ) as Void {

        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            x,
            labelY,
            _dataFont,
            "STEP",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        if (steps >= 10000) {

            var stepK =
                steps / 1000.0;

            var numberText;


            if ((steps % 1000) == 0) {

                numberText =
                    stepK.format("%.0f");

            } else {

                numberText =
                    stepK.format("%.1f");
            }


            var suffixText = "K";


            var numberWidth =
                dc.getTextWidthInPixels(
                    numberText,
                    _dataFont
                );


            var suffixWidth =
                dc.getTextWidthInPixels(
                    suffixText,
                    _dataFont
                );


            var suffixGap = 2;


            var totalWidth =
                numberWidth +
                suffixGap +
                suffixWidth;


            var startX =
                x -
                (totalWidth / 2);


            dc.setColor(
                0xC9C3B8,
                Graphics.COLOR_TRANSPARENT
            );


            dc.drawText(
                startX,
                valueY,
                _dataFont,
                numberText,
                Graphics.TEXT_JUSTIFY_LEFT
            );


            dc.setColor(
                0xB02020,
                Graphics.COLOR_TRANSPARENT
            );


            dc.drawText(
                startX +
                numberWidth +
                suffixGap,
                valueY,
                _dataFont,
                suffixText,
                Graphics.TEXT_JUSTIFY_LEFT
            );


            return;
        }


        if (steps >= 1000) {

            var thousands =
                (steps / 1000).toNumber();

            var remainder =
                steps % 1000;


            var leftText =
                thousands.format("%d");

            var commaText = ",";

            var rightText =
                remainder.format("%03d");


            var leftWidth =
                dc.getTextWidthInPixels(
                    leftText,
                    _dataFont
                );


            var commaWidth =
                dc.getTextWidthInPixels(
                    commaText,
                    _dataFont
                );


            var rightWidth =
                dc.getTextWidthInPixels(
                    rightText,
                    _dataFont
                );


            var commaGapLeft = 2;
            var commaGapRight = 2;


            var totalWidth =
                leftWidth +
                commaGapLeft +
                commaWidth +
                commaGapRight +
                rightWidth;


            var startX =
                x -
                (totalWidth / 2);


            dc.setColor(
                0xC9C3B8,
                Graphics.COLOR_TRANSPARENT
            );


            dc.drawText(
                startX,
                valueY,
                _dataFont,
                leftText,
                Graphics.TEXT_JUSTIFY_LEFT
            );


            var commaX =
                startX +
                leftWidth +
                commaGapLeft;


            dc.setColor(
                0xB02020,
                Graphics.COLOR_TRANSPARENT
            );


            dc.drawText(
                commaX,
                valueY,
                _dataFont,
                commaText,
                Graphics.TEXT_JUSTIFY_LEFT
            );


            var rightX =
                commaX +
                commaWidth +
                commaGapRight;


            dc.setColor(
                0xC9C3B8,
                Graphics.COLOR_TRANSPARENT
            );


            dc.drawText(
                rightX,
                valueY,
                _dataFont,
                rightText,
                Graphics.TEXT_JUSTIFY_LEFT
            );


            return;
        }


        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            x,
            valueY,
            _dataFont,
            steps.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }


    // =================================================
    // STEP GOAL PROGRESS
    // BLACK TRACK + SOLID RED
    // =================================================

    function drawStepGoalProgress(dc as Dc) as Void {

        var activity = ActivityMonitor.getInfo();

        var steps = activity.steps;


        var stepGoal = 5000;


        var savedStepGoal =
            Application.Properties.getValue(
                "stepGoal"
            );


        if (savedStepGoal instanceof Number) {
            stepGoal = savedStepGoal;
        }


        // -------------------------------------------------
        // POSITION / SIZE
        // -------------------------------------------------

        var barX = 155;
        var barY = 261;

        var barWidth = 146;
        var barHeight = 8;


        var progress =
            steps.toFloat() /
            stepGoal.toFloat();


        if (progress < 0.0) {
            progress = 0.0;
        }


        if (progress > 1.0) {
            progress = 1.0;
        }


        var fillWidth =
            (barWidth * progress).toNumber();


        // -------------------------------------------------
        // EMPTY TRACK
        // -------------------------------------------------

        dc.setColor(
            0x000000,
            Graphics.COLOR_TRANSPARENT
        );


        dc.fillRectangle(
            barX,
            barY,
            barWidth,
            barHeight
        );


        if (fillWidth > 0) {

            // ---------------------------------------------
            // SUBTLE DARK RED GLOW
            // ---------------------------------------------

            dc.setColor(
                0x500808,
                Graphics.COLOR_TRANSPARENT
            );


            dc.fillRectangle(
                barX,
                barY - 1,
                fillWidth,
                barHeight + 2
            );


            // ---------------------------------------------
            // MAIN INDUSTRIAL RED
            // ---------------------------------------------

            dc.setColor(
                0xB02020,
                Graphics.COLOR_TRANSPARENT
            );


            dc.fillRectangle(
                barX,
                barY,
                fillWidth,
                barHeight
            );


            // ---------------------------------------------
            // RED GLOSS
            // Bright red only — NO white core
            // ---------------------------------------------

            dc.setColor(
                0xE04040,
                Graphics.COLOR_TRANSPARENT
            );


            dc.fillRectangle(
                barX,
                barY + 1,
                fillWidth,
                2
            );


            // ---------------------------------------------
            // LOWER SHADE
            // Gives the bar a little depth
            // ---------------------------------------------

            dc.setColor(
                0x801010,
                Graphics.COLOR_TRANSPARENT
            );


            dc.fillRectangle(
                barX,
                barY + barHeight - 2,
                fillWidth,
                2
            );
        }
    }


    // =================================================
    // BATTERY MODULE
    // =================================================

    function drawBatteryModule(
        dc as Dc,
        x as Number,
        labelY as Number,
        valueY as Number,
        batteryValue as Float
    ) as Void {

        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            x,
            labelY,
            _dataFont,
            "BATT",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        var numberText =
            batteryValue.format("%.0f");

        var percentText = "%";


        var numberWidth =
            dc.getTextWidthInPixels(
                numberText,
                _dataFont
            );


        var percentWidth =
            dc.getTextWidthInPixels(
                percentText,
                _dataFont
            );


        var percentGap = 5;


        var totalWidth =
            numberWidth +
            percentGap +
            percentWidth;


        var startX =
            x -
            (totalWidth / 2);


        dc.setColor(
            0xC9C3B8,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            startX,
            valueY,
            _dataFont,
            numberText,
            Graphics.TEXT_JUSTIFY_LEFT
        );


        dc.setColor(
            0xB02020,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            startX +
            numberWidth +
            percentGap,
            valueY,
            _dataFont,
            percentText,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }


    function onHide() as Void {
    }


    // =================================================
    // AOD / LOW POWER
    // =================================================

    function drawAod(dc as Dc) as Void {

        // -------------------------------------------------
        // PURE BLACK BACKGROUND
        // -------------------------------------------------

        dc.setColor(
            0x000000,
            0x000000
        );


        dc.clear();


        // -------------------------------------------------
        // TIME + TIME FORMAT
        // -------------------------------------------------

        var clockTime =
            System.getClockTime();


        var displayHour =
            clockTime.hour;


        var timeFormat = 0;


        var savedTimeFormat =
            Application.Properties.getValue(
                "timeFormat"
            );


        if (savedTimeFormat instanceof Number) {
            timeFormat = savedTimeFormat;
        }


        var use24Hour = true;


        if (timeFormat == 1) {

            use24Hour = false;

        } else if (timeFormat == 2) {

            use24Hour = true;

        } else {

            use24Hour =
                System.getDeviceSettings().is24Hour;
        }


        if (!use24Hour) {

            displayHour =
                displayHour % 12;


            if (displayHour == 0) {
                displayHour = 12;
            }
        }


        var timeText =
            displayHour.format("%02d") +
            ":" +
            clockTime.min.format("%02d");


        // -------------------------------------------------
        // DATE
        // -------------------------------------------------

        var dateInfo =
            Gregorian.info(
                Time.now(),
                Time.FORMAT_SHORT
            );


        var dayNames = [
            "SUN",
            "MON",
            "TUE",
            "WED",
            "THU",
            "FRI",
            "SAT"
        ];


        var monthNames = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
        ];


        var dayText =
            dayNames[
                dateInfo.day_of_week - 1
            ];


        var dateText =
            dateInfo.day.format("%02d") +
            " " +
            monthNames[
                dateInfo.month - 1
            ];


        // -------------------------------------------------
        // AOD DATE
        // -------------------------------------------------

        dc.setColor(
            0x701818,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            227,
            81,
            _dataFont,
            dayText,
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.setColor(
            0x77736D,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            227,
            101,
            _dataFont,
            dateText,
            Graphics.TEXT_JUSTIFY_CENTER
        );


        // -------------------------------------------------
        // AOD TIME
        //
        // No glow
        // No blinking
        // Dim aged steel
        // -------------------------------------------------

        dc.setColor(
            0x8A867F,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            227,
            143,
            _timeFont,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER
        );
                // -------------------------------------------------
        // LIVE STATUS DATA
        // -------------------------------------------------

        var info =
            System.getSystemStats();


        var activity =
            ActivityMonitor.getInfo();


        var heartRate = "--";


        var heartRateIterator =
            SensorHistory.getHeartRateHistory({
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            });


        if (heartRateIterator != null) {

            var sample =
                heartRateIterator.next();


            if (
                sample != null &&
                sample.data != null
            ) {

                heartRate =
                    sample.data.format("%d");
            }
        }


        // -------------------------------------------------
        // AOD STEP FORMAT
        // -------------------------------------------------

        var steps =
            activity.steps;


        var stepText;


        if (steps >= 10000) {

            var stepK =
                steps / 1000.0;


            if ((steps % 1000) == 0) {

                stepText =
                    stepK.format("%.0f") +
                    "K";

            } else {

                stepText =
                    stepK.format("%.1f") +
                    "K";
            }


        } else if (steps >= 1000) {

            var thousands =
                (steps / 1000).toNumber();

            var remainder =
                steps % 1000;


            stepText =
                thousands.format("%d") +
                "," +
                remainder.format("%03d");


        } else {

            stepText =
                steps.format("%d");
        }


        var batteryText =
            info.battery.format("%.0f") +
            "%";


        // -------------------------------------------------
        // STATUS POSITIONS
        // -------------------------------------------------

        var leftX = 118;
        var centerX = 227;
        var rightX = 338;

        var labelY = 276;
        var valueY = 300;


        // -------------------------------------------------
        // STATUS LABELS
        // DIM INDUSTRIAL RED
        // -------------------------------------------------

        dc.setColor(
            0x701818,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            leftX,
            labelY,
            _dataFont,
            "VITAL",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.drawText(
            centerX,
            labelY,
            _dataFont,
            "STEP",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.drawText(
            rightX,
            labelY,
            _dataFont,
            "BATT",
            Graphics.TEXT_JUSTIFY_CENTER
        );


        // -------------------------------------------------
        // STATUS VALUES
        // DIM AGED STEEL
        // -------------------------------------------------

        dc.setColor(
            0x77736D,
            Graphics.COLOR_TRANSPARENT
        );


        dc.drawText(
            leftX,
            valueY,
            _dataFont,
            heartRate,
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.drawText(
            centerX,
            valueY,
            _dataFont,
            stepText,
            Graphics.TEXT_JUSTIFY_CENTER
        );


        dc.drawText(
            rightX,
            valueY,
            _dataFont,
            batteryText,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }


    // =================================================
    // EXIT AOD
    // =================================================

    function onExitSleep() as Void {

        _isAod = false;


        WatchUi.requestUpdate();
    }


    // =================================================
    // ENTER AOD
    // =================================================

    function onEnterSleep() as Void {

        _isAod = true;


        WatchUi.requestUpdate();
    }

}