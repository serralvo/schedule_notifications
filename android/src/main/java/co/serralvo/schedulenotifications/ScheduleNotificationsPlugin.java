package co.serralvo.schedulenotifications;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
     * Schedule notification method name.
     */
    private static final String SCHEDULE_NOTIFICATION_METHOD_NAME = "scheduleNotification";

    /**
     * Receiver of registrations from a single plugin.
     */
    private static Registrar mRegistrar;

    /**
     * Alarm manager.
     */
    private AlarmManager mAlarmManager;

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
        mAlarmManager = (AlarmManager) getActiveContext().getSystemService(Context.ALARM_SERVICE);

        if (call.method.equals(SCHEDULE_NOTIFICATION_METHOD_NAME)) {
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

        Date date = convertToDate(when);

        if (repeatAt.size() > 0) {
            scheduleRepeatNotification(date, title);
        } else {
            scheduleOneShotNotification(date, title);
        }
    }

    /**
     * Schedule one shot notification.
     *
     * @param when Date to schedule.
     * @param title Notification title.
     */
    private void scheduleOneShotNotification(Date when, String title) {
        if (when != null) {
            Date now = new Date();
            Date scheduleDate;
            if (when.getTime() > now.getTime()) {
                scheduleDate = when;
            } else {
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(when);
                calendar.add(Calendar.DATE, 1);
                scheduleDate = calendar.getTime();
            }
            mAlarmManager.set(AlarmManager.RTC_WAKEUP, scheduleDate.getTime(), getNotificationIntent(title));
        }
    }

    /**
     * Schedule repeat notification.
     *
     * @param when Date to schedule.
     * @param title Notification title.
     */
    private void scheduleRepeatNotification(Date when, String title) {
        // TODO: implement method.
    }

    /**
     * Get the notification intent.
     *
     * @param title Notification title
     *
     * @return Notification Intent.
     */
    private PendingIntent getNotificationIntent(String title) {
        Intent intent = new Intent(getActiveContext(), AlarmReceiver.class);
        intent.putExtra(IntentConstants.TITLE_PARAM, title);
        return PendingIntent.getBroadcast(getActiveContext(), 0, intent, 0);
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