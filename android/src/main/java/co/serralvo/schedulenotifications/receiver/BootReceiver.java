package co.serralvo.schedulenotifications.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import co.serralvo.schedulenotifications.util.AlarmScheduler;

/**
 * Device boot receiver.
 */
public class BootReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals("android.intent.action.BOOT_COMPLETED")) {
            AlarmScheduler.initialize(context);
            AlarmScheduler.rescheduleNotifications(context);
        }
    }
}
