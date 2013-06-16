package com.example.implantproject;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Vibrator;
import android.util.Log;

public class NotificationBarAlarm extends BroadcastReceiver {

	NotificationManager notifyManager;
	static Vibrator vibr;

	@Override
	public void onReceive(Context context, Intent intent) {
		
		String soundAlram = intent.getExtras().getString("soundAlarm");
		
		notifyManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

		// This Activity will be started when the user clicks the notification
		// in the notification bar
		Intent notificationIntent = new Intent(context, NotificationView.class);

		PendingIntent contentIntent = PendingIntent.getActivity(context, 0, notificationIntent, 0);
		Notification notif = new Notification(R.drawable.icon512, "A new notification just popped in!", System.currentTimeMillis());

		// Play sound?
		// If you want you can play a sound when the notification shows up.
		// Place the MP3 file into the /raw folder.
		
		notif.sound = Uri.parse("android.resource://" + context.getPackageName() + "/" + soundAlram);

		notif.setLatestEventInfo(context, "Notification Title", "Notification Text", contentIntent);

		notifyManager.notify(1, notif);
	}
}