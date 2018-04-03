package co.serralvo.schedulenotifications;

import android.content.Context;

import java.util.List;

import co.serralvo.schedulenotifications.util.AlarmScheduler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ScheduleNotificationsPlugin
 */
public class ScheduleNotificationsPlugin implements MethodCallHandler {

    /**
     * Schedule notification method name.
     */
    private static final String SCHEDULE_NOTIFICATION_METHOD_NAME = "scheduleNotification";

    /**
     * Unschedule notification method name.
     */
    private static final String UNSCHEDULE_NOTIFICATION_METHOD_NAME = "unscheduleNotifications";

    /**
     * Set notification icon.
     */
    private static final String SET_NOTIFICATION_ICON_METHOD_NAME = "setNotificationIcon";

    /**
     * Receiver of registrations from a single plugin.
     */
    private static Registrar mRegistrar;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        mRegistrar = registrar;
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "schedule_notifications");
        channel.setMethodCallHandler(new ScheduleNotificationsPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case SCHEDULE_NOTIFICATION_METHOD_NAME:
                if (call.arguments != null && call.arguments instanceof List) {
                    AlarmScheduler.scheduleNotification((List<Object>) call.arguments, getActiveContext());
                }
                break;
            case UNSCHEDULE_NOTIFICATION_METHOD_NAME:
                AlarmScheduler.unscheduleNotifications(getActiveContext());
                break;
            case SET_NOTIFICATION_ICON_METHOD_NAME:
                if (call.arguments != null && call.arguments instanceof List) {
                    setNotificationIcon((List<Object>) call.arguments);
                }
                break;
            default:
                result.notImplemented();
        }
    }

    /**
     * Return the active context.
     *
     * @return The context.
     */
    private Context getActiveContext() {
        return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
    }

    /**
     * Set the notification icon resource id.
     *
     * @param arguments Icon resource id.
     */
    private void setNotificationIcon(List<Object> arguments) {
        NotificationSingleton.getInstance().setNotificationIcon((int) arguments.get(0));
    }
}