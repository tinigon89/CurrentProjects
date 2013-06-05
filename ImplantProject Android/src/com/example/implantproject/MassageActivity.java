package com.example.implantproject;

import android.app.Activity;
import android.app.Dialog;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

import android.widget.Button;
import android.widget.ImageView;

import android.widget.TextView;

import android.widget.ToggleButton;

public class MassageActivity extends Activity implements OnClickListener {

	private TextView tv;
	private TextView armCircle;
	private TextView armStretch;
	private ImageView instruction;

	private ToggleButton toggle;
	private int counter = 0;
	Context context = this;
	private Intent i;
	private TextView home;
	private TextView tvvideo;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.message);
		tv = (TextView) findViewById(R.id.shoulderroll);
		tv.setOnClickListener(this);
		armCircle = (TextView) findViewById(R.id.armcircle);
		armCircle.setOnClickListener(this);
		armStretch = (TextView) findViewById(R.id.armstretch);
		armStretch.setOnClickListener(this);
		instruction = (ImageView) findViewById(R.id.imageButton1);
		instruction.setOnClickListener(this);

		toggle = (ToggleButton) findViewById(R.id.toggleButton1);
		toggle.setOnClickListener(this);
		home = (TextView) findViewById(R.id.home);
		home.setOnClickListener(this);
		tvvideo = (TextView) findViewById(R.id.tvvideoview);
		tvvideo.setOnClickListener(this);
	}

	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.toggleButton1:
			if(counter == 0){
				counter = 1;
			} else {
				counter = 0;
			}
			break;
		case R.id.tvvideoview:
			i = new Intent(MassageActivity.this, VideoActivity.class);
			i.putExtra("Videoname", R.raw.u0026amp);
			startActivity(i);
			break;
		case R.id.home:
			startActivity(new Intent(MassageActivity.this, MainActivity.class));
			break;

		case R.id.shoulderroll:
			SavePreferences("Title", "Shoulder Roll");
			i = new Intent(MassageActivity.this, SettingActivity.class);
			i.putExtra("alarmbutton_phase1", counter);
			i.putExtra("screen_name", "shoulderroll");
			startActivity(i);
			break;
		case R.id.armcircle:
			SavePreferences("Title", "Arm Circle");
			//i = new Intent(MassageActivity.this, armCircleSettingActivity.class);
			i = new Intent(MassageActivity.this, SettingActivity.class);
			i.putExtra("alarmbutton_phase1", counter);
			i.putExtra("screen_name", "armcircle");
			startActivity(i);

			break;
		case R.id.armstretch:
			SavePreferences("Title", "Arm Stretch");
			i = new Intent(MassageActivity.this, SettingActivity.class);
			i.putExtra("alarmbutton_phase1", counter);
			i.putExtra("screen_name", "armstretch");
			startActivity(i);

			break;
		case R.id.imageButton1:
			final Dialog dialog = new Dialog(context);
			dialog.setContentView(R.layout.disclaimerdialog);

			dialog.setTitle("...");

			Button dialogButton = (Button) dialog.findViewById(R.id.button1);
			dialogButton.setOnClickListener(new View.OnClickListener() {

				public void onClick(View v) {
					// TODO Auto-generated method stub

					dialog.dismiss();
				}
			});
			dialog.show();

			/*
			 * Uri file=
			 * Uri.parse("file:///android_asset/RapidReturnExercises.pdf");
			 * String mimeType =
			 * MimeTypeMap.getSingleton().getMimeTypeFromExtension
			 * (MimeTypeMap.getFileExtensionFromUrl(file.toString()));
			 * 
			 * try{ Intent i; i = new Intent(Intent.ACTION_VIEW);
			 * i.setDataAndType(file,mimeType); startActivity(i);
			 * 
			 * }catch (ActivityNotFoundException e) { Toast.makeText(this,
			 * "No Application Available to fiew this file type",
			 * Toast.LENGTH_SHORT).show();
			 */
			// }

			break;
		}

	}

	private void SavePreferences(String key, String value) {
		SharedPreferences sharedPreferences = getSharedPreferences(
				"MY_SHARED_PREF", MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putString(key, value);
		editor.commit();
	}
}
