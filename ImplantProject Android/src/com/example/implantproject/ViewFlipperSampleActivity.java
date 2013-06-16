package com.example.implantproject;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.GestureDetector;
import android.view.GestureDetector.OnGestureListener;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.animation.AnimationUtils;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.ViewFlipper;

public class ViewFlipperSampleActivity extends Activity {

	SharedPreferences prefs;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.mdisclaimer);
		
		WebView webview = (WebView) findViewById(R.id.mwebview);
		webview.getSettings().setJavaScriptEnabled(true); 
		//webview.loadUrl("https://docs.google.com/gview?embedded=true&url=http://www.cgapp.net.au/privacy-policy.pdf");
		webview.loadUrl("file:///android_asset/terms.html");

		prefs = PreferenceManager.getDefaultSharedPreferences(this);
		if (prefs.getBoolean("firsttime", true)) {
			Intent i = new Intent(ViewFlipperSampleActivity.this,
					TermConditionActivity.class);
			startActivity(i);
		}

		CheckBox acceptButton = (CheckBox) findViewById(R.id.mcheckBox1);
		acceptButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				finish();
			}
		});

	}
}