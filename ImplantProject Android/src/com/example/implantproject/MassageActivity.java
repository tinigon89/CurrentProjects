package com.example.implantproject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.example.implantproject.ItemDbAdapter;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.Dialog;
import android.app.PendingIntent;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import android.widget.TextView;

import android.widget.ToggleButton;

public class MassageActivity extends Activity implements OnClickListener,
		OnItemClickListener {

	private TextView tv;
	private TextView armCircle;
	private TextView armStretch;
	private ImageView instruction;
	private static ItemDbAdapter mDbHelper;

	private ToggleButton toggle;
	private int counter = 0;
	Context context = this;
	private Intent i;
	private TextView home;
	private TextView tvvideo;
	private SharedPreferences sharedPreferences;
	private ListView lv = null;
	private String type;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.message);
		/*
		 * tv = (TextView) findViewById(R.id.shoulderroll);
		 * tv.setOnClickListener(this); armCircle = (TextView)
		 * findViewById(R.id.armcircle); armCircle.setOnClickListener(this);
		 * armStretch = (TextView) findViewById(R.id.armstretch);
		 * armStretch.setOnClickListener(this);
		 */
		
		type = getIntent().getExtras().getString("type");
		
		tv = (TextView) findViewById(R.id.textView6);
		if(type.equals("0")){
			tv.setText("Phase 1");
		}
		if(type.equals("1")){
			tv.setText("Phase 2");
		}
		
		mDbHelper = new ItemDbAdapter(this);
		mDbHelper.open();
		
		Cursor mCur = mDbHelper.fetchAllCgs("0");
		int countCursor = mCur.getCount();
		if(countCursor == 0){
			mDbHelper.createCg(0, "Shoulder Roll", "", "", "0");
			mDbHelper.createCg(0, "Arm Circle", "", "", "0");
			mDbHelper.createCg(0, "Arm Stretch", "", "", "0");
			mDbHelper.createCg(0, "Exercise 1", "", "", "1");
			mDbHelper.createCg(0, "Exercise 2", "", "", "1");
			mDbHelper.createCg(0, "Exercise 3", "", "", "1");
			mDbHelper.createCg(0, "Exercise 4", "", "", "1");
		}
		
		lv = (ListView) findViewById(R.id.listview);
		Cursor mCursor = mDbHelper.fetchAllCgs(type);
		mCursor.moveToFirst();
		List<HashMap<String, String>> fillMaps = new ArrayList<HashMap<String, String>>();
		for (int i = 0; i < mCursor.getCount(); i++) {
			HashMap<String, String> map = new HashMap<String, String>();
        	map.put("item_title", mCursor.getString(1));
        	fillMaps.add(map);
			
			mCursor.moveToNext();
		}

		String[] from = new String[] { "item_title" };
		int[] to = new int[] { R.id.item_title };

		SimpleAdapter adapter = new SimpleAdapter(this, fillMaps,
				R.layout.list_row, from, to);
		lv.setAdapter(adapter);
		lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int position, long arg3) {
				TextView mTitle = (TextView) arg1.findViewById(R.id.item_title);
				Intent it = new Intent(context, SettingActivity.class);
		        it.putExtra("screen_name", mTitle.getText().toString());
		        it.putExtra("type", type);
		        startActivity(it);
		        SavePreferences("Title", mTitle.getText().toString());
			}
		});

		instruction = (ImageView) findViewById(R.id.imageButton1);
		instruction.setOnClickListener(this);

		toggle = (ToggleButton) findViewById(R.id.toggleButton1);
		toggle.setOnClickListener(this);
		home = (TextView) findViewById(R.id.home);
		home.setOnClickListener(this);
		tvvideo = (TextView) findViewById(R.id.tvvideoview);
		tvvideo.setOnClickListener(this);
		sharedPreferences = getSharedPreferences("MY_SHARED_PREF", MODE_PRIVATE);
		
		String toggleButton = "";
		if(type.equals("0")){
			toggleButton = sharedPreferences.getString("toggleButton1", "");
			if (toggleButton.equals("on")) {
				toggle.setChecked(true);
				counter = 1;
			}
			if (toggleButton.equals("off")) {
				toggle.setChecked(false);
				counter = 0;
			}
			/*if (toggle.isChecked()) {
				SavePreferences("toggleButton1", "on");
			}*/
		}
		if(type.equals("1")){
			toggleButton = sharedPreferences.getString("toggleButton2", "");
			if (toggleButton.equals("on")) {
				toggle.setChecked(true);
				counter = 1;
			}
			if (toggleButton.equals("off")) {
				toggle.setChecked(false);
				counter = 0;
			}
			/*if (toggle.isChecked()) {
				SavePreferences("toggleButton2", "on");
			}*/
		}

		Button btnAdd = (Button) findViewById(R.id.add_item);
		btnAdd.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent i = new Intent(MassageActivity.this, AddItemActivity.class);
				i.putExtra("type", type);
				startActivity(i);
				finish();
			}
		});
	}
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}

	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch (v.getId()) {
		case R.id.toggleButton1:
			if (counter == 0) {
				counter = 1;
				if(type.equals("0")){
					SavePreferences("toggleButton1", "on");
				}
				if(type.equals("1")){
					SavePreferences("toggleButton2", "on");
				}
			} else {
				counter = 0;
				AlarmManager alarmManager = (AlarmManager) context
						.getSystemService(Context.ALARM_SERVICE);
				Intent updateServiceIntent = new Intent(context,
						NotificationBarAlarm.class);
				PendingIntent pendingUpdateIntent = PendingIntent.getService(
						context, 0, updateServiceIntent, 0);
				try {
					alarmManager.cancel(pendingUpdateIntent);
				} catch (Exception e) {
					// Log.e(TAG, "AlarmManager update was not canceled. " +
					// e.toString());
				}
				if(type.equals("0")){
					SavePreferences("toggleButton1", "off");
				}
				if(type.equals("1")){
					SavePreferences("toggleButton2", "off");
				}
			}
			break;
		case R.id.tvvideoview:
			i = new Intent(MassageActivity.this, VideoActivity.class);
			if(type.equals("0")){
				i.putExtra("Videoname", R.raw.phase111);
			}
			if(type.equals("1")){
				i.putExtra("Videoname", R.raw.phase222);
			}
			startActivity(i);
			break;
		case R.id.home:
			// startActivity(new Intent(MassageActivity.this,
			// MainActivity.class));
			finish();
			break;

		/*
		 * case R.id.shoulderroll: SavePreferences("Title", "Shoulder Roll"); i
		 * = new Intent(MassageActivity.this, SettingActivity.class);
		 * i.putExtra("alarmbutton_phase1", counter); i.putExtra("screen_name",
		 * "shoulderroll"); startActivity(i); break; case R.id.armcircle:
		 * SavePreferences("Title", "Arm Circle"); //i = new
		 * Intent(MassageActivity.this, armCircleSettingActivity.class); i = new
		 * Intent(MassageActivity.this, SettingActivity.class);
		 * i.putExtra("alarmbutton_phase1", counter); i.putExtra("screen_name",
		 * "armcircle"); startActivity(i);
		 * 
		 * break; case R.id.armstretch: SavePreferences("Title", "Arm Stretch");
		 * i = new Intent(MassageActivity.this, SettingActivity.class);
		 * i.putExtra("alarmbutton_phase1", counter); i.putExtra("screen_name",
		 * "armstretch"); startActivity(i);
		 * 
		 * break;
		 */
		case R.id.imageButton1:
			final Dialog dialog = new Dialog(context);
			if(type.equals("0")){
				dialog.setContentView(R.layout.disclaimerdialog);
			}
			if(type.equals("1")){
				dialog.setContentView(R.layout.disclaimerdialog2);
			}

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

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		// TODO Auto-generated method stub

	}
}
