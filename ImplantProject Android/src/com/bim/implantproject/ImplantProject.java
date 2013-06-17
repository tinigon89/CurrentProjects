package com.bim.implantproject;

import com.bim.implantproject.MainActivity;
import com.bim.implantproject.R;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;

public class ImplantProject extends Activity {
	Context context;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.opening);
		context = this;
	}
	
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			nextActivity();
		}
		
		private void nextActivity() {
			Intent intent = new Intent(context, MainActivity.class);
			context.startActivity(intent);
			finish();
		}
	};
	
	@Override
	public void onStart() {
		super.onStart();

		threadStart();
	}
	
	private void threadStart() {
		Thread background = new Thread(new Runnable() {
			@Override
			public void run() {
				handler.sendMessageDelayed(handler.obtainMessage(), 2000);
			}
		});

		background.start();
	}
	
	@Override
	public void onStop() {
		super.onStop();
		
	}
}
