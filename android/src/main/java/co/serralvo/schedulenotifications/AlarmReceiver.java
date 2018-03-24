package co.serralvo.schedulenotifications;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;

/**
 * Alarm notification receiver.
 */
public class AlarmReceiver extends BroadcastReceiver {

    /**
     * Notification channel ID.
     */
    private static final String CHANNEL_ID = "schedule_notification_channel_id";

    /**
     * Notification channel name.
     */
    private static final String CHANNEL_NAME = "Alarm Notification";

    /**
     * Notification ID.
     */
    private static final int NOTIFICATION_ID = 1234;

    @Override
    public void onReceive(Context context, Intent intent) {
        String title = intent.getStringExtra(IntentConstants.TITLE_PARAM);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager mNotificationManager =
                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            mNotificationManager.createNotificationChannel(channel);
        }

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context, CHANNEL_ID)
                // TODO: get the app icon.
                .setSmallIcon(2131296256)
                .setContentTitle(title)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
        // TODO: implement click.

        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build());
    }
}
