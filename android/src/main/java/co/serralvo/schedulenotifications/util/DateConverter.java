package co.serralvo.schedulenotifications.util;

import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility class to convert a Date.
 */
public class DateConverter {

    /**
     * TAG to show on log.
     */
    private static final String LOG_TAG = DateConverter.class.getSimpleName();

    /**
     * Convert a date string to Date object.
     * <p>
     * Format: "yyyy-MM-dd HH:mm:ss".
     *
     * @param dateStr Date string to convert.
     * @return Date converted.
     */
    public static Date convertToDate(String dateStr) {
        Date date = null;
        if (dateStr != null && !dateStr.isEmpty()) {
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            try {
                date = format.parse(dateStr);
                System.out.println(date);
            } catch (ParseException ex) {
                Log.e(LOG_TAG, "Error on convert date: ", ex);
            }
        }
        return date;
    }

}
