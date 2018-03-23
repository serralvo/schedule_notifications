package co.serralvo.schedulenotifications;

import android.content.Context;
import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
     * TAG to show on log.
     */
    private static final String LOG_TAG = ScheduleNotificationsPlugin.class.getSimpleName();

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
        if (call.method.equals("scheduleNotification")) {

            if (call.arguments != null && call.arguments instanceof List) {
                scheduleNotification((List<Object>) call.arguments);
            }

            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
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
     * Schedule a notification.
     *
     * @param arguments Method arguments.
     */
    private void scheduleNotification(List<Object> arguments) {
        String title = (String) arguments.get(0);
        String when = (String) arguments.get(1);
        List<Integer> repeatAt = (List<Integer>) arguments.get(2);
    }

    /**
     * Convert a date string to Date object.
     * <p>
     * Format: "yyyy-MM-dd HH:mm:ss".
     *
     * @param dateStr Date string to convert.
     * @return Date converted.
     */
    private Date convertToDate(String dateStr) {
        Date date = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            date = format.parse(dateStr);
            System.out.println(date);
        } catch (ParseException ex) {
            Log.e(LOG_TAG, "Error on convert date: ", ex);
        }
        return date;
    }
}