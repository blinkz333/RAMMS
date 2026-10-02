import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class RAMMSApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view and WatchFaceDelegate
    function getInitialView() as [Views] or [Views, InputDelegates] {

        return [
            new RAMMSView(),
            new RAMMSDelegate()
        ];
    }

}

function getApp() as RAMMSApp {
    return Application.getApp() as RAMMSApp;
}