package com.bim.implantproject;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Bundle;
import android.os.Vibrator;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import com.bim.implantproject.R;

public class NotificationView extends Activity implements OnClickListener {
	private SoundManager mSoundManager= SettingActivity.mSoundManager;
	NotificationManager nm;
	private Vibrator vibe = SettingActivity.vibe;
	public void onCreate(Bundle savedInstanceState)
	{
	super.onCreate(savedInstanceState);
	 setContentView(R.layout.notification);
	 Button b = (Button)findViewById(R.id.button1);
	 b.setOnClickListener(this);
	 
	//---look up the notification manager service---
	 nm = (NotificationManager)
	getSystemService(NOTIFICATION_SERVICE);
	//---cancel the notification that we started
	
	}

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
		case R.id.button1:
			nm.cancel(getIntent().getExtras().getInt("notificationID"));
			int streamID = getIntent().getExtras().getInt("streamID", 0);
			Log.d("stream", streamID+"");
			mSoundManager.stop(streamID);
			vibe.cancel();
			this.finish();
			break;
		}
	}
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		
		NotificationManager nMgr = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		nMgr.cancelAll();
	}
}
