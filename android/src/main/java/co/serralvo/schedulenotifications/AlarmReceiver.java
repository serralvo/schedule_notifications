package co.serralvo.schedulenotifications;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
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
        int icon = intent.getIntExtra(IntentConstants.ICON_PARAM, 0);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager mNotificationManager =
                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            mNotificationManager.createNotificationChannel(channel);
        }

        Intent actionIntent = context.getPackageManager()
                    .getLaunchIntentForPackage(context.getPackageName());
        PendingIntent actionPendingIntent = PendingIntent.getActivity(context, 0,
                    actionIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(icon)
                .setContentTitle(title)
                .setContentIntent(actionPendingIntent)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build());
    }
}
