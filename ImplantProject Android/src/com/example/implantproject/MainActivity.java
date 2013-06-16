package com.example.implantproject;

import java.io.File;
import android.app.Activity;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.MimeTypeMap;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity implements OnClickListener {

	int Flag = 1;
	static int count = 1;
	private TextView disclaimer;
	Context context = this;
	
	SharedPreferences prefs;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.phase);
		
		TextView b = (TextView) findViewById(R.id.textView1);
		b.setOnClickListener(this);
		TextView b1 = (TextView) findViewById(R.id.textView4);
		b1.setOnClickListener(this);
		disclaimer = (TextView) findViewById(R.id.textView3);
		disclaimer.setOnClickListener(this);
		
		prefs = PreferenceManager.getDefaultSharedPreferences(this);
		if (prefs.getBoolean("firsttime", true)) {
			Intent i = new Intent(MainActivity.this, ViewFlipperSampleActivity.class);
			startActivity(i);
		}

	}

	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.textView1:
			Intent i = new Intent(MainActivity.this, MassageActivity.class);
			i.putExtra("type", "0");
			startActivity(i);
			break;
		case R.id.textView4:
			Intent it = new Intent(MainActivity.this, MassageActivity.class);
			it.putExtra("type", "1");
			startActivity(it);
			break;

		case R.id.textView3:

			startActivity(new Intent(MainActivity.this,
					ViewFlipperSampleActivity.class));

			/*
			 * Uri file= Uri.parse("file:///android_asset/TermOfUser.pdf");
			 * String mimeType =
			 * MimeTypeMap.getSingleton().getMimeTypeFromExtension
			 * (MimeTypeMap.getFileExtensionFromUrl(file.toString()));
			 * 
			 * try{ Intent i; i = new Intent(Intent.ACTION_VIEW);
			 * i.setDataAndType(file,mimeType); startActivity(i);
			 * 
			 * }catch (ActivityNotFoundException e) { Toast.makeText(this,
			 * "No Application Available to view this file type",
			 * Toast.LENGTH_SHORT).show(); }
			 */

			break;
		}
	}
}
