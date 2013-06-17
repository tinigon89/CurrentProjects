package com.bim.implantproject;

import android.app.Activity;
import android.app.Dialog;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Vibrator;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;
import com.bim.implantproject.R;

public class armCircleSettingActivity extends Activity implements OnClickListener,
		OnItemSelectedListener {
	private Spinner spinner1;
	private EditText StrtDayEditView;
	static Vibrator vibe;
	private EditText endtime;
	private int strtDay;
	private int enddayLeft;
	static public SoundManager mSoundManager;
	private TextView minus;
	private TextView frequency;
	private TextView endplus;
	private TextView endminus;
	
	private ImageButton left;
	private ImageButton right;
	private TextView oneHour;
	private TextView twoHour;
	private TextView threeHour;
	private TextView fourHour;
	private TextView fiveHour;
	private TextView sixHour;
	private TextView sevenHour;
	private TextView eightHour;
	private TextView nineHour;
	private TextView tenHour;
	private TextView elevenHour;
	private TextView tewlvHour;
	private int endDay=0;
	int notificationID = 1;
	static private int freLeft;
	private TextView cancel;
	int Flag = 1;
	Context context = this;
	private int streamID;
	static int count = 1;
	int vibrator = 0;
	private SharedPreferences sharedPreferences;
	ScrollView scroll;
	
	long[] pattern = { 0, 200, 500 };
	private TextView done;
	private TextView dfrequency;
	int toggle = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		TextView b = (TextView) findViewById(R.id.imageButton1);
		b.setOnClickListener(this);
		StrtDayEditView = (EditText) findViewById(R.id.editText3);
		// freminus=(ImageButton)findViewById(R.id.imageButton4);
		cancel = (TextView) findViewById(R.id.textView7);
		cancel.setOnClickListener(this);
		endtime = (EditText) findViewById(R.id.editText1);
		left = (ImageButton) findViewById(R.id.imageButton3);
		left.setOnClickListener(this);
		scroll = (ScrollView) findViewById(R.id.scrollViewer);
		right = (ImageButton) findViewById(R.id.imageButton5);
		right.setOnClickListener(this);
		vibe = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
		dfrequency = (TextView) findViewById(R.id.frequencyView);
		dfrequency.setOnClickListener(this);
		
		done = (TextView) findViewById(R.id.done);
		done.setOnClickListener(this);
		oneHour = (TextView) findViewById(R.id.tv1);
		oneHour.setOnClickListener(this);
		twoHour = (TextView) findViewById(R.id.tv2);
		twoHour.setOnClickListener(this);
		threeHour = (TextView) findViewById(R.id.tv3);
		threeHour.setOnClickListener(this);
		fourHour = (TextView) findViewById(R.id.tv4);
		fourHour.setOnClickListener(this);
		fiveHour = (TextView) findViewById(R.id.tv5);
		fiveHour.setOnClickListener(this);
		sixHour = (TextView) findViewById(R.id.tv6);
		sixHour.setOnClickListener(this);
		sevenHour = (TextView) findViewById(R.id.tv7);
		sevenHour.setOnClickListener(this);
		eightHour = (TextView) findViewById(R.id.tv8);
		eightHour.setOnClickListener(this);
		nineHour = (TextView) findViewById(R.id.tv9);
		nineHour.setOnClickListener(this);
		tenHour = (TextView) findViewById(R.id.tv10);
		tenHour.setOnClickListener(this);
		elevenHour = (TextView) findViewById(R.id.tv12);
		elevenHour.setOnClickListener(this);
		tewlvHour = (TextView) findViewById(R.id.tv11);
		tewlvHour.setOnClickListener(this);

		mSoundManager = new SoundManager();
		mSoundManager.initSounds(getBaseContext());
		
		

		addListenerOnSpinnerItemSelection();
		sharedPreferences = getSharedPreferences("MY_SHARED_PREF", MODE_PRIVATE);
		String title= sharedPreferences.getString("Title", "");
		TextView Title = (TextView)findViewById(R.id.shoulderroll);
		Title.setText(title);
		int Value  = getIntent().getExtras().getInt("TogglebuttonValue");

		if (Value%2!= 0) {
			dfrequency.setText("1");
			StrtDayEditView.setText("1");
			endtime.setText("3");
			spinner1.setSelected(true);
			Flag = 3;
		}
		
		
		//left button
		left.setImageResource(R.drawable.left1);
		right.setImageResource(R.drawable.rightbutton);
		Flag = 1;
		// ------------------Clearing the Screen-----------------------
		StrtDayEditView.setText("");
		endtime.setText("");
		dfrequency.setText("");

		// ----------------------------------When Left was
		// clicked----------------
		sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
				MODE_PRIVATE);
		String strSavedMem1 = sharedPreferences.getString("LstrtDay", null);
		if(strSavedMem1==null)
		{
		StrtDayEditView.setText("1");
		endtime.setText("3");
		dfrequency.setText("1");
		}
		
		// ---------------------Resett Values--------------------
		if (strSavedMem1 != null) {
			String strLendday = sharedPreferences.getString("LendDay", "");
			String Lfrequency = sharedPreferences.getString("Lfrequency", "");
			StrtDayEditView.setText(strSavedMem1);
			endtime.setText(strLendday);
			dfrequency.setText(Lfrequency);
		}
	}

	private void addListenerOnSpinnerItemSelection() {
		// TODO Auto-generated method stub
		spinner1 = (Spinner) findViewById(R.id.spinner1);
		spinner1.setOnItemSelectedListener(this);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_main, menu);
		return true;
	}

	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		switch (arg0.getId()) {
		case R.id.done:
			strtDay = (Integer.parseInt(StrtDayEditView.getText().toString()));
			enddayLeft = (Integer.parseInt(endtime.getText().toString()));
			freLeft = (Integer.parseInt(dfrequency.getText().toString()));
			if ((strtDay != 0) && (enddayLeft != 0) && (freLeft != 0)) {
				/*final Dialog dialog = new Dialog(context);
				dialog.setContentView(R.layout.activatealarm);
				dialog.setTitle("Activate alarm...");

				Button dialogButton = (Button) dialog
						.findViewById(R.id.activate);
				dialogButton.setOnClickListener(new View.OnClickListener() {

					public void onClick(View v) {
						// TODO Auto-generated method stub
						dialog.dismiss();
					}
				});
				dialog.show();
				dialog.getWindow().setLayout(280, 280);*/
			}
			if (Flag == 1) {
				sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
						MODE_PRIVATE);
				String strSavedMem1 = sharedPreferences
						.getString("spinner", "").toLowerCase();

				int resID = getResources().getIdentifier(strSavedMem1, "raw",
						getPackageName());
				mSoundManager.addSound(1, resID);
				strtDay = (Integer.parseInt(StrtDayEditView.getText().toString()));

				if (strtDay != 0) {
					enddayLeft = (Integer
							.parseInt(endtime.getText().toString()));
					freLeft = (Integer.parseInt(dfrequency.getText().toString()));

					SavePreferences("LstrtDay", StrtDayEditView.getText().toString());
					SavePreferences("LendDay", endtime.getText().toString());
					SavePreferences("Lfrequency", dfrequency.getText()
							.toString());

					// strtDay = (enddayLeft-strtDay)*freLeft ;
					strtDay = (enddayLeft - strtDay) * (24 / freLeft);

					freLeft = freLeft  * 60 *60* 1000;
					myCounter(freLeft);
					/*Intent intent = new Intent(this, MainActivity.class);
					//intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					// intent.putExtra(name, ("finishApplication", true);
					startActivity(intent);*/
					finish();
				}

				else {

					Toast.makeText(armCircleSettingActivity.this, "Chnage Settings ",
							Toast.LENGTH_SHORT).show();
				}

			}
			if (Flag == 2) {
				sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
						MODE_PRIVATE);
				String strSavedMem1 = sharedPreferences
						.getString("spinner", "").toLowerCase();;

				int resID = getResources().getIdentifier(strSavedMem1, "raw",
						getPackageName());
				mSoundManager.addSound(1, resID);
				strtDay = (Integer.parseInt(StrtDayEditView.getText().toString()));

				if (strtDay != 0) {
					enddayLeft = (Integer
							.parseInt(endtime.getText().toString()));
					freLeft = (Integer.parseInt(dfrequency.getText().toString()));

					SavePreferences("RstrtDay", StrtDayEditView.getText().toString());
					SavePreferences("RendDay", endtime.getText().toString());
					SavePreferences("Rfrequency", dfrequency.getText()
							.toString());

					// strtDay = (enddayLeft-strtDay)*freLeft ;
					strtDay = (enddayLeft - strtDay) * (24 / freLeft);

					freLeft = freLeft * 60 *60 * 1000;
					myCounter(freLeft);
					/*Intent intent = new Intent(this, MainActivity.class);
					//intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					// intent.putExtra(name, ("finishApplication", true);
					startActivity(intent);*/
					finish();
				}

				else {

					Toast.makeText(armCircleSettingActivity.this, "Chnage Settings ",
							Toast.LENGTH_SHORT).show();
				}

			}
			if (Flag == 3) {
				int resID = getResources().getIdentifier("becauseofyou", "raw",
						getPackageName());
				mSoundManager.addSound(1, resID);
				strtDay = 1;

				if (strtDay != 0) {
					int enddayLeft = 4;
					freLeft = 1;

					// strtDay = (enddayLeft-strtDay)*freLeft ;
					strtDay = (enddayLeft - strtDay) * (24 / freLeft);

					freLeft = freLeft * 60* 60 * 1000;
					myCounter(freLeft);
					/*Intent intent = new Intent(this, MainActivity.class);
					//intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
					// intent.putExtra(name, ("finishApplication", true);
					startActivity(intent);*/
					finish();
				}

				else {

					Toast.makeText(armCircleSettingActivity.this, "Chnage Settings ",
							Toast.LENGTH_SHORT).show();
				}
			}
			break;
		case R.id.imageButton1:

			if (strtDay < 12) {

				try {
					String hello = StrtDayEditView.getText().toString();
					strtDay = Integer.parseInt(hello);
				} catch (NumberFormatException nfe) {
					System.out.println("Could not parse " + nfe);
				}
				strtDay++;
				StrtDayEditView.setText("" + strtDay);
			} else
				Toast.makeText(armCircleSettingActivity.this, "You can go beypnd 12",
						Toast.LENGTH_SHORT).show();
			break;
		case R.id.imageButton3:
			left.setImageResource(R.drawable.left1);
			right.setImageResource(R.drawable.rightbutton);
			Flag = 1;
			// ------------------Clearing the Screen-----------------------
			StrtDayEditView.setText("");
			endtime.setText("");
			dfrequency.setText("");

			// ----------------------------------When Left was
			// clicked----------------
			sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
					MODE_PRIVATE);
			String strSavedMem1 = sharedPreferences.getString("LstrtDay", null);
			if(strSavedMem1==null)
			{
			StrtDayEditView.setText("1");
			endtime.setText("3");
			dfrequency.setText("1");
			}
			
			// ---------------------Resett Values--------------------
			if (strSavedMem1 != null) {
				String strLendday = sharedPreferences.getString("LendDay", "");
				String Lfrequency = sharedPreferences.getString("Lfrequency", "");
				StrtDayEditView.setText(strSavedMem1);
				endtime.setText(strLendday);
				dfrequency.setText(Lfrequency);
			}

			break;
						
		case R.id.imageButton5:
			left.setImageResource(R.drawable.left);
			right.setImageResource(R.drawable.right1);
			Flag = 2;

			StrtDayEditView.setText("");
			endtime.setText("");
			dfrequency.setText("");

			sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
					MODE_PRIVATE);
			String strRSavedMem1 = sharedPreferences.getString("RstrtDay", "");
			String strRendday = sharedPreferences.getString("RendDay", "");
			String Rfrequency = sharedPreferences.getString("Rfrequency", "");

			// ---------------------Resett Values--------------------
			if (strRSavedMem1 != null) {
				StrtDayEditView.setText(strRSavedMem1);
				endtime.setText(strRendday);
				dfrequency.setText(Rfrequency);
			}else
				StrtDayEditView.setText("1");
			endtime.setText("3");
			dfrequency.setText("1");
			break;
		case R.id.textView7:
			/*Intent intent = new Intent(this, MainActivity.class);
			intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			// intent.putExtra(name, ("finishApplication", true);
			startActivity(intent);*/
			finish();
			break;
		case R.id.tv1:
			dfrequency.setText("1");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv2:
			dfrequency.setText("2");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv3:
			dfrequency.setText("3");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv4:
			dfrequency.setText("4");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv5:
			dfrequency.setText("5");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv6:
			dfrequency.setText("6");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv7:
			dfrequency.setText("7");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv8:
			dfrequency.setText("8");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv9:
			dfrequency.setText("9");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv10:
			dfrequency.setText("10");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv11:
			dfrequency.setText("11");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv12:
			dfrequency.setText("12");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.frequencyView:
			scroll.setVisibility(scroll.VISIBLE);
			break;

		default:

			sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
					MODE_PRIVATE);
			String strdSavedMem1 = sharedPreferences.getString("LstrtDay", "");
			String strdLendday = sharedPreferences.getString("LendDay", "");
			String Ldfrequency = sharedPreferences.getString("Lfrequency", "");

			// ---------------------Resett Values--------------------
			if (strdSavedMem1 != null) {
				StrtDayEditView.setText(strdSavedMem1);
				endtime.setText(strdLendday);
				frequency.setText(Ldfrequency);
			}
			break;
		}

	}

	private void myCounter(int eas) {
		new CountDownTimer(eas, 1000) {

			@Override
			public void onTick(long millisUntilFinished) {
			}

			@Override
			public void onFinish() {

				count++;
				displayNotification();

				if (count >= strtDay) {
					myCounter(freLeft);
				}

			}
		}.start();

	}
	protected void displayNotification()
	{
	//---PendingIntent to launch activity if the user selects
	// this notification---
	streamID = mSoundManager.playSound(1);
	Intent i = new Intent(this, NotificationView.class);
	i.putExtra("notificationID", notificationID);
	i.putExtra("streamID", streamID);
	PendingIntent pendingIntent =
	PendingIntent.getActivity(this, 0, i, 0);
	
	NotificationManager nm = (NotificationManager)
			getSystemService(NOTIFICATION_SERVICE);
			Notification notif = new Notification(R.drawable.icon512,"Reminder: Implant Exercise",System.currentTimeMillis());
			long pattern[] = {100, 250, 100, 500};
			vibe.vibrate(pattern,-1);
				
			CharSequence from = "Implant Exercise";
			CharSequence message = "Do your exercise";
			notif.setLatestEventInfo(this, from, message, pendingIntent);
			nm.notify(notificationID, notif);
			}
	   private void SavePreferences(String key, String value) {
		SharedPreferences sharedPreferences = getSharedPreferences(
				"MY_SHARED_PREF", MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putString(key, value);
		editor.commit();
	}

	private void LoadPreferences() {
		SharedPreferences sharedPreferences = getSharedPreferences(
				"MY_SHARED_PREF", MODE_PRIVATE);
		String strSavedMem1 = sharedPreferences.getString("spinner", "");

	}

	public void onItemSelected(AdapterView<?> parent, View view, int pos,
			long id) {
		// TODO Auto-generated method stub
		String lowerCase = parent.getItemAtPosition(pos).toString().toLowerCase();

		SavePreferences("spinner", lowerCase );
	}

	public void onNothingSelected(AdapterView<?> arg0) {
		// TODO Auto-generated method stub

	}

}
