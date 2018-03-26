package co.serralvo.schedulenotifications;

/**
 * Store some notification data.
 */
public class NotificationSingleton {

    /**
     * NotificationSingleton instance.
     */
    private static NotificationSingleton sInstance;

    /**
     * Notification icon resource id.
     */
    private int mNotificationIcon;

    /**
     * Constructor.
     */
    private NotificationSingleton() {

    }

    /**
     * Return the NotificationSingleton instance.
     *
     * @return NotificationSingleton instance.
     */
    public static NotificationSingleton getInstance() {
        if (sInstance == null) {
            sInstance = new NotificationSingleton();
        }
        return sInstance;
    }

    /**
     * Return the Notification icon resource id.
     *
     * @return Notification icon resource id.
     */
    public int getNotificationIcon() {
        return mNotificationIcon;
    }

    /**
     * Set the Notification icon resource id.
     *
     * @param notificationIcon Notification icon resource id.
     */
    public void setNotificationIcon(int notificationIcon) {
        mNotificationIcon = notificationIcon;
    }
}
