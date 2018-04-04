package co.serralvo.schedulenotifications.util;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import co.serralvo.schedulenotifications.model.business.AlarmSharedPreferences;
import co.serralvo.schedulenotifications.receiver.AlarmReceiver;

/**
 * Utility class to schedule an alarm.
 */
public class AlarmScheduler {

    /**
     * TAG to show on log.
     */
    private static final String LOG_TAG = AlarmScheduler.class.getSimpleName();

    /**
     * Alarm manager.
     */
    private static AlarmManager sAlarmManager;

    /**
     * Schedule a notification.
     *
     * @param arguments Method arguments.
     * @param context The context.
     */
    public static void scheduleNotification(List<Object> arguments, Context context) {
        String title = (String) arguments.get(0);
        String when = (String) arguments.get(1);
        List<Integer> repeatAt = (List<Integer>) arguments.get(2);

        Date date = DateConverter.convertToDate(when);

        AlarmSharedPreferences.saveAlarm(context, title, when, repeatAt);

        scheduleNotification(title, date, repeatAt, context);
    }

    /**
     * Reschedule notifications.
     *
     * @param context The context.
     */
    public static void rescheduleNotifications(Context context) {
        Log.i(LOG_TAG, "Rescheduling alarms");
        String title = AlarmSharedPreferences.getTitle(context);
        Date date = AlarmSharedPreferences.getDate(context);
        List<Integer> repeatAt = AlarmSharedPreferences.getDaysToRepeat(context);
        scheduleNotification(title, date, repeatAt, context);
    }

    /**
     * Unschedule notifications.
     *
     * @param context The context.
     */
    public static void unscheduleNotifications(Context context) {
        Log.i(LOG_TAG, "Unscheduling alarms");

        for (int day = 0; day <= 7; day++) {
            Intent intent = new Intent(context, AlarmReceiver.class);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, day, intent, 0);
            pendingIntent.cancel();
            sAlarmManager.cancel(pendingIntent);
        }

        AlarmSharedPreferences.clear(context);
    }

    /**
     * Schedule a notification.
     *
     * @param title Notification title.
     * @param date Date to schedule.
     * @param repeatAt Days to repeat the alarm.
     * @param context The context.
     */
    private static void scheduleNotification(String title, Date date, List<Integer> repeatAt, Context context) {
        sAlarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        if (repeatAt.size() > 0) {
            scheduleRepeatNotification(date, title, repeatAt, context);
        } else {
            scheduleOneShotNotification(date, title, context);
        }
    }

    /**
     * Schedule one shot notification.
     *
     * @param when Date to schedule.
     * @param title Notification title.
     * @param context The context.
     */
    private static void scheduleOneShotNotification(Date when, String title, Context context) {
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
            Log.i(LOG_TAG, "Scheduling alarm: " + scheduleDate);
            sAlarmManager.set(AlarmManager.RTC_WAKEUP, scheduleDate.getTime(), getNotificationIntent(title, 0, context));
        }
    }

    /**
     * Schedule repeat notification.
     *
     * @param when Date to schedule.
     * @param title Notification title.
     * @param repeatAt Days to repeat notification.
     * @param context The context.
     */
    private static void scheduleRepeatNotification(Date when, String title, List<Integer> repeatAt, Context context) {
        Calendar calendar = Calendar.getInstance();
        for (int day : repeatAt) {
            calendar.setTime(when);
            calendar.setFirstDayOfWeek(calendar.get(Calendar.DAY_OF_WEEK));
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.DAY_OF_WEEK, day + 1);
            Date scheduleDate = calendar.getTime();
            Log.i(LOG_TAG, "Scheduling alarm: " + scheduleDate);
            sAlarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, scheduleDate.getTime(),
                    AlarmManager.INTERVAL_DAY * 7, getNotificationIntent(title, day, context));
        }
    }

    /**
     * Get the notification intent.
     *
     * @param title Notification title
     * @param requestCode Notification request code.
     * @param context The context.
     * @return Notification Intent.
     */
    private static PendingIntent getNotificationIntent(String title, int requestCode, Context context) {
        Intent intent = new Intent(context, AlarmReceiver.class);
        return PendingIntent.getBroadcast(context, requestCode, intent, 0);
    }
}
