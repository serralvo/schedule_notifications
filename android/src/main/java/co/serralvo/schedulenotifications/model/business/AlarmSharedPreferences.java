package co.serralvo.schedulenotifications.model.business;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import co.serralvo.schedulenotifications.util.DateConverter;

import static android.content.Context.MODE_PRIVATE;

/**
 * Class responsible for managing alarm data.
 */
public class AlarmSharedPreferences {

    /**
     * Preferences filename.
     */
    private static final String PREFS_NAME = "ScheduleNotificationsPreferences";

    /**
     * Key to store the notification title.
     */
    private static final String TITLE_KEY = "title";

    /**
     * Key to store the date.
     */
    private static final String DATE_KEY = "date";

    /**
     * Key to store the days to schedule an alarm.
     */
    private static final String DAYS_KEY = "days";

    /**
     * Key to store the icon resource ID.
     */
    private static final String ICON_KEY = "icon";

    /**
     * Save the alarm data.
     *
     * @param context The context.
     * @param title Notification title.
     * @param date Initial alarm date.
     * @param repeatAt Days to repeat the schedule.
     */
    public static void saveAlarm(Context context, String title, String date, List<Integer> repeatAt) {

        Set<String> days = new HashSet<>();
        for (Integer day : repeatAt) {
            days.add(day.toString());
        }

        SharedPreferences.Editor editor = getPreferences(context).edit();
        editor.putString(TITLE_KEY, title);
        editor.putString(DATE_KEY, date);
        editor.putStringSet(DAYS_KEY, days);
        editor.apply();
    }

    /**
     * Save the icon resource ID.
     *
     * @param context The context.
     * @param iconId Icon resource ID.
     */
    public static void saveIcon(Context context, int iconId) {
        SharedPreferences.Editor editor = getPreferences(context).edit();
        editor.putInt(ICON_KEY, iconId);
        editor.apply();
    }

    /**
     * Return the notification title.
     *
     * @param context The context.
     *
     * @return Notification title.
     */
    public static String getTitle(Context context) {
        return getPreferences(context).getString(TITLE_KEY, "");
    }

    /**
     * Return the initial alarm date.
     *
     * @param context The context.
     *
     * @return The initial alarm date.
     */
    public static Date getDate(Context context) {
        return DateConverter.convertToDate(getPreferences(context).getString(DATE_KEY, ""));
    }

    /**
     * Return the days to repeat the schedule.
     *
     * @param context The context.
     *
     * @return The days to repeat the schedule.
     */
    public static List<Integer> getDaysToRepeat(Context context) {
        List<Integer> days = new ArrayList<>();
        Set<String> daysStr = getPreferences(context).getStringSet(DAYS_KEY, null);
        if (daysStr != null && !daysStr.isEmpty()) {
            for (String day : daysStr) {
                days.add(Integer.valueOf(day));
            }
        }
        return days;
    }

    /**
     * Return the notification icon resource ID.
     *
     * @param context The context.
     *
     * @return The notification icon resource ID.
     */
    public static int getIcon(Context context) {
        return getPreferences(context).getInt(ICON_KEY, 0);
    }

    /**
     * Clear the preferences.
     *
     * @param context The context.
     */
    public static void clear(Context context) {
        SharedPreferences.Editor editor = getPreferences(context).edit();
        editor.clear();
        editor.apply();
    }

    /**
     * Return the preferences.
     *
     * @param context The context.
     *
     * @return The preferences.
     */
    private static SharedPreferences getPreferences(Context context) {
        return context.getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
    }
}