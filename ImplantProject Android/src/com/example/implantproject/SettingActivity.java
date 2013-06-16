package com.example.implantproject;

import java.util.Calendar;
import java.util.Random;

import com.example.implantproject.NotificationBarAlarm;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TimePickerDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Vibrator;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;
import android.widget.ToggleButton;

public class SettingActivity extends Activity implements OnClickListener,
		OnItemSelectedListener {

	private MediaPlayer mp;

	private Spinner spinner1;
	private TextView StrtDayEditView;
	static Vibrator vibe;
	private TextView endtime;
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
	private TextView tvneverHour;
	private TextView tv30Hour;
	private TextView tv24Hour;
	private int endDay = 0;
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

	private String screenName;
	private String type;

	private DatePicker dpResult;
	private int year;
	private int month;
	private int day;

	private TimePicker tpResult;
	private int hour;
	private int minute;

	private int dialogFrom;

	private TextView mStartTime;
	private TextView mEndTime;
	private int mCounterSpinner = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		StrtDayEditView = (TextView) findViewById(R.id.editText3);
		StrtDayEditView.setOnClickListener(this);
		// freminus=(ImageButton)findViewById(R.id.imageButton4);
		cancel = (TextView) findViewById(R.id.textView7);
		cancel.setOnClickListener(this);
		endtime = (TextView) findViewById(R.id.editText1);
		endtime.setOnClickListener(this);
		left = (ImageButton) findViewById(R.id.imageButton3);
		left.setOnClickListener(this);
		scroll = (ScrollView) findViewById(R.id.scrollViewer);
		right = (ImageButton) findViewById(R.id.imageButton5);
		right.setOnClickListener(this);
		vibe = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
		dfrequency = (TextView) findViewById(R.id.frequencyView);
		dfrequency.setOnClickListener(this);

		mStartTime = (TextView) findViewById(R.id.editstarttime);
		mStartTime.setOnClickListener(this);
		mEndTime = (TextView) findViewById(R.id.editendtime);
		mEndTime.setOnClickListener(this);

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

		tvneverHour = (TextView) findViewById(R.id.tvNever);
		tvneverHour.setOnClickListener(this);
		tv30Hour = (TextView) findViewById(R.id.tv30Mins);
		tv30Hour.setOnClickListener(this);
		tv24Hour = (TextView) findViewById(R.id.tv24);
		tv24Hour.setOnClickListener(this);

		mSoundManager = new SoundManager();
		mSoundManager.initSounds(getBaseContext());

		addListenerOnSpinnerItemSelection();
		sharedPreferences = getSharedPreferences("MY_SHARED_PREF", MODE_PRIVATE);
		String title = sharedPreferences.getString("Title", "");
		TextView Title = (TextView) findViewById(R.id.shoulderroll);
		Title.setText(title);
		int Value = getIntent().getExtras().getInt("TogglebuttonValue");
		screenName = getIntent().getExtras().getString("screen_name");
		type = getIntent().getExtras().getString("type");

		if (Value % 2 != 0) {
			dfrequency.setText("1");
			StrtDayEditView.setText("1");
			endtime.setText("3");
			spinner1.setSelected(true);
			Flag = 3;
		}

		// left button
		left.setImageResource(R.drawable.left1);
		right.setImageResource(R.drawable.rightbutton);
		Flag = 1;
		// ------------------Clearing the Screen-----------------------
		StrtDayEditView.setText("");
		endtime.setText("");
		dfrequency.setText("");

		// ----------------------------------When Left was
		// clicked----------------
		sharedPreferences = getSharedPreferences("MY_SHARED_PREF", MODE_PRIVATE);
		String strSavedMem1 = sharedPreferences.getString(screenName
				+ "LstrtDay", null);
		// ---------------------Resett Values--------------------
		if (strSavedMem1 != null) {
			String strLendday = sharedPreferences.getString(screenName
					+ "LendDay", "");
			String Lfrequency = sharedPreferences.getString(screenName
					+ "Lfrequency", "");
			String Lstarttime = sharedPreferences.getString(screenName
					+ "Lstarttime", "");
			String Lendtime = sharedPreferences.getString(screenName
					+ "Lendtime", "");
			StrtDayEditView.setText(strSavedMem1);
			endtime.setText(strLendday);
			dfrequency.setText(Lfrequency);
			mStartTime.setText(Lstarttime);
			mEndTime.setText(Lendtime);
		}

		if (strSavedMem1 == null) {
			final Calendar c = Calendar.getInstance();
			year = c.get(Calendar.YEAR);
			month = c.get(Calendar.MONTH) + 1;
			day = c.get(Calendar.DAY_OF_MONTH);
			if(type.equals("1")){
				day = c.get(Calendar.DAY_OF_MONTH) + 3;
			}
			String currentDate = year + "-" + month + "-" + day;
			StrtDayEditView.setText(currentDate);
			endtime.setText(currentDate);
			dfrequency.setText("4 Hours");
			mStartTime.setText("10:00");
			mEndTime.setText("22:00");
		}

		dialogFrom = 0;
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
			if (mp != null) {
				mp.stop();
			}
			if (Flag == 1) {
				sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
						MODE_PRIVATE);
				String strSavedMem1 = sharedPreferences.getString(
						screenName + "Lspinner", "").toLowerCase();

				int resID = getResources().getIdentifier(strSavedMem1, "raw",
						getPackageName());
				SavePreferences(screenName + "LsoundAlarm",
						String.valueOf(resID));

				SavePreferences(screenName + "LstrtDay", StrtDayEditView
						.getText().toString());
				SavePreferences(screenName + "LendDay", endtime.getText()
						.toString());
				SavePreferences(screenName + "Lfrequency", dfrequency.getText()
						.toString());

				SavePreferences(screenName + "Lstarttime", mStartTime.getText()
						.toString());
				SavePreferences(screenName + "Lendtime", mEndTime.getText()
						.toString());

				String mdate = StrtDayEditView.getText().toString();
				String[] arrDate = mdate.split("-", -1);
				String mhour = mStartTime.getText().toString();
				String[] arrHour = mhour.split(":", -1);

				int year = Integer.parseInt(arrDate[0].trim());
				int month = Integer.parseInt(arrDate[1].trim());
				int date = Integer.parseInt(arrDate[2].trim());
				int hour = Integer.parseInt(arrHour[0].trim());
				int min = Integer.parseInt(arrHour[1].trim());

				SharedPreferences sharedPreferences = getSharedPreferences(
						"MY_SHARED_PREF", MODE_PRIVATE);
				SharedPreferences.Editor editor = sharedPreferences.edit();
				Random rnd = new Random();
				int n = 100000 + rnd.nextInt(900000);
				editor.putInt(screenName + "Lintent", n);
				editor.commit();
				int repeat = 0;
				String strrepeat = dfrequency.getText().toString();
				if (strrepeat.indexOf("Never") > 0) {
					repeat = 0;
				}
				if (strrepeat.indexOf("Min") > 0) {
					strrepeat = strrepeat.replace(" Minutes", "");
					repeat = Integer.parseInt(strrepeat);
					repeat = (repeat * 3600 * 1000) / 60;
				}
				if (strrepeat.indexOf("Hours") > 0) {
					strrepeat = strrepeat.replace(" Hours", "");
					repeat = Integer.parseInt(strrepeat);
					repeat = repeat * 3600 * 1000;
				}
				if (strrepeat.indexOf("Hour") > 0) {
					strrepeat = strrepeat.replace(" Hour", "");
					repeat = Integer.parseInt(strrepeat);
					repeat = repeat * 3600 * 1000;
				}

				startAlarm(year, month, date, hour, min, repeat);

				Calendar calendar = Calendar.getInstance();
				calendar.set(year, month - 1, date, hour, min, 0);
				long onTime = calendar.getTimeInMillis();

				String mhour2 = mEndTime.getText().toString();
				String[] arrHour2 = mhour2.split(":", -1);

				int hour2 = Integer.parseInt(arrHour2[0].trim());
				int min2 = Integer.parseInt(arrHour2[1].trim());

				Calendar calendar2 = Calendar.getInstance();
				calendar2.set(year, month - 1, date, hour2, min2, 0);
				long toTime = calendar2.getTimeInMillis();

				long currentTime = System.currentTimeMillis();
				long counterTime = onTime + currentTime;
				long stopTime = toTime - onTime;
				int mCounterTime = (int) (counterTime + stopTime);
				myCounter(mCounterTime);
				finish();
			}
			if (Flag == 2) {
				sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
						MODE_PRIVATE);
				String strSavedMem1 = sharedPreferences.getString(
						screenName + "Rspinner", "").toLowerCase();
				;

				int resID = getResources().getIdentifier(strSavedMem1, "raw",
						getPackageName());
				SavePreferences(screenName + "RsoundAlarm",
						String.valueOf(resID));

				SavePreferences(screenName + "RstrtDay", StrtDayEditView
						.getText().toString());
				SavePreferences(screenName + "RendDay", endtime.getText()
						.toString());
				SavePreferences(screenName + "Rfrequency", dfrequency.getText()
						.toString());
				SavePreferences(screenName + "Rstarttime", mStartTime.getText()
						.toString());
				SavePreferences(screenName + "Rendtime", mEndTime.getText()
						.toString());
				String mdate = StrtDayEditView.getText().toString();
				String[] arrDate = mdate.split("-", -1);
				String mhour = mStartTime.getText().toString();
				String[] arrHour = mhour.split(":", -1);

				int year = Integer.parseInt(arrDate[0].trim());
				int month = Integer.parseInt(arrDate[1].trim());
				int date = Integer.parseInt(arrDate[2].trim());
				int hour = Integer.parseInt(arrHour[0].trim());
				int min = Integer.parseInt(arrHour[1].trim());

				SharedPreferences sharedPreferences = getSharedPreferences(
						"MY_SHARED_PREF", MODE_PRIVATE);
				SharedPreferences.Editor editor = sharedPreferences.edit();
				Random rnd = new Random();
				int n = 100000 + rnd.nextInt(900000);
				editor.putInt(screenName + "Rintent", n);
				editor.commit();

				int repeat = 0;
				String strrepeat = dfrequency.getText().toString();
				if (strrepeat.indexOf("Never") > 0) {
					repeat = 0;
				}
				if (strrepeat.indexOf("Min") > 0) {
					strrepeat = strrepeat.replace(" Minutes", "");
					repeat = Integer.parseInt(strrepeat);
					repeat = (repeat * 3600 * 1000) / 60;
				}
				if (strrepeat.indexOf("Hours") > 0) {
					strrepeat = strrepeat.replace(" Hours", "");
					repeat = Integer.parseInt(strrepeat);
					repeat = repeat * 3600 * 1000;
				}
				if (strrepeat.indexOf("Hour") > 0) {
					strrepeat = strrepeat.replace(" Hour", "");
					repeat = Integer.parseInt(strrepeat);
					repeat = repeat * 3600 * 1000;
				}

				startAlarm(year, month, date, hour, min, repeat);

				Calendar calendar = Calendar.getInstance();
				calendar.set(year, month - 1, date, hour, min, 0);
				long onTime = calendar.getTimeInMillis();

				String mhour2 = mEndTime.getText().toString();
				String[] arrHour2 = mhour2.split(":", -1);

				int hour2 = Integer.parseInt(arrHour2[0].trim());
				int min2 = Integer.parseInt(arrHour2[1].trim());

				Calendar calendar2 = Calendar.getInstance();
				calendar2.set(year, month - 1, date, hour2, min2, 0);
				long toTime = calendar2.getTimeInMillis();

				long currentTime = System.currentTimeMillis();
				long counterTime = onTime + currentTime;
				long stopTime = toTime - onTime;
				int mCounterTime = (int) (counterTime + stopTime);
				myCounter(mCounterTime);
				finish();
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

					freLeft = freLeft * 60 * 60 * 1000;
					myCounter(freLeft);
					/*
					 * Intent intent = new Intent(this, MainActivity.class);
					 * //intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP); //
					 * intent.putExtra(name, ("finishApplication", true);
					 * startActivity(intent);
					 */
					finish();
				}

				else {

					Toast.makeText(SettingActivity.this, "Chnage Settings ",
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
				Toast.makeText(SettingActivity.this, "You can go beypnd 12",
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
			mStartTime.setText("");
			mEndTime.setText("");

			// ----------------------------------When Left was
			// clicked----------------
			sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
					MODE_PRIVATE);
			String strSavedMem1 = sharedPreferences.getString(screenName
					+ "LstrtDay", null);
			if (strSavedMem1 == null) {
				final Calendar c = Calendar.getInstance();
				year = c.get(Calendar.YEAR);
				month = c.get(Calendar.MONTH) + 1;
				day = c.get(Calendar.DAY_OF_MONTH);
				if(type.equals("1")){
					day = c.get(Calendar.DAY_OF_MONTH) + 3;
				}
				String currentDate = year + "-" + month + "-" + day;
				StrtDayEditView.setText(currentDate);
				endtime.setText(currentDate);
				dfrequency.setText("4 Hours");
				mStartTime.setText("10:00");
				mEndTime.setText("22:00");
			}

			// ---------------------Resett Values--------------------
			if (strSavedMem1 != null) {
				String strLendday = sharedPreferences.getString(screenName
						+ "LendDay", "");
				String Lfrequency = sharedPreferences.getString(screenName
						+ "Lfrequency", "");
				String Lstarttime = sharedPreferences.getString(screenName
						+ "Lstarttime", "");
				String Lendtime = sharedPreferences.getString(screenName
						+ "Lendtime", "");
				StrtDayEditView.setText(strSavedMem1);
				endtime.setText(strLendday);
				dfrequency.setText(Lfrequency);
				mStartTime.setText(Lstarttime);
				mEndTime.setText(Lendtime);
			}

			break;

		case R.id.imageButton5:
			left.setImageResource(R.drawable.left);
			right.setImageResource(R.drawable.right1);
			Flag = 2;

			StrtDayEditView.setText("");
			endtime.setText("");
			dfrequency.setText("");
			dfrequency.setText("");
			mStartTime.setText("");
			mEndTime.setText("");

			sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
					MODE_PRIVATE);
			String strRSavedMem1 = sharedPreferences.getString(screenName
					+ "RstrtDay", "");
			String strRendday = sharedPreferences.getString(screenName
					+ "RendDay", "");
			String Rfrequency = sharedPreferences.getString(screenName
					+ "Rfrequency", "");
			String Rstarttime = sharedPreferences.getString(screenName
					+ "Rstarttime", "");
			String Rendtime = sharedPreferences.getString(screenName
					+ "Rendtime", "");

			// ---------------------Resett Values--------------------
			if (strRSavedMem1 != null) {
				StrtDayEditView.setText(strRSavedMem1);
				endtime.setText(strRendday);
				dfrequency.setText(Rfrequency);
				mStartTime.setText(Rstarttime);
				mEndTime.setText(Rendtime);
			}
			if (strRSavedMem1.equals("")) {
				final Calendar c = Calendar.getInstance();
				year = c.get(Calendar.YEAR);
				month = c.get(Calendar.MONTH) + 1;
				day = c.get(Calendar.DAY_OF_MONTH);
				if(type.equals("1")){
					day = c.get(Calendar.DAY_OF_MONTH) + 3;
				}
				String currentDate = year + "-" + month + "-" + day;
				StrtDayEditView.setText(currentDate);
				endtime.setText(currentDate);
				dfrequency.setText("4 Hours");
				mStartTime.setText("10:00");
				mEndTime.setText("22:00");
			}
			break;
		case R.id.textView7:
			/*
			 * Intent intent = new Intent(this, MainActivity.class);
			 * intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP); //
			 * intent.putExtra(name, ("finishApplication", true);
			 * startActivity(intent);
			 */
			if (mp != null) {
				mp.stop();
			}
			finish();
			break;
		case R.id.tv1:
			dfrequency.setText("1 Hour");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv2:
			dfrequency.setText("2 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv3:
			dfrequency.setText("3 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv4:
			dfrequency.setText("4 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv5:
			dfrequency.setText("5 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv6:
			dfrequency.setText("6 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv7:
			dfrequency.setText("7 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv8:
			dfrequency.setText("8 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv9:
			dfrequency.setText("9 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv10:
			dfrequency.setText("10 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv11:
			dfrequency.setText("11 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv12:
			dfrequency.setText("12 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tvNever:
			dfrequency.setText("Never");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv30Mins:
			dfrequency.setText("30 Minutes");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.tv24:
			dfrequency.setText("24 Hours");
			scroll.setVisibility(scroll.INVISIBLE);
			break;
		case R.id.frequencyView:
			scroll.setVisibility(scroll.VISIBLE);
			break;
		case R.id.editText3:
			setCurrentDateOnView();
			dialogFrom = 1;
			showDialog(1);
			break;
		case R.id.editText1:
			setCurrentDateOnView();
			dialogFrom = 2;
			showDialog(1);
			break;
		case R.id.editstarttime:
			setCurrentTimeOnView();
			dialogFrom = 3;
			showDialog(2);
			break;
		case R.id.editendtime:
			setCurrentTimeOnView();
			dialogFrom = 4;
			showDialog(2);
			break;

		default:

			sharedPreferences = getSharedPreferences("MY_SHARED_PREF",
					MODE_PRIVATE);
			String strdSavedMem1 = sharedPreferences.getString(screenName
					+ "LstrtDay", "");
			String strdLendday = sharedPreferences.getString(screenName
					+ "LendDay", "");
			String Ldfrequency = sharedPreferences.getString(screenName
					+ "Lfrequency", "");

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
				/*
				 * count++; if (count >= strtDay) { myCounter(freLeft); }
				 */
				int i = 0;
				if (Flag == 1) {
					i = sharedPreferences.getInt(screenName + "Lintent", 0);
				}
				if (Flag == 2) {
					i = sharedPreferences.getInt(screenName + "Rintent", 0);
				}
				stopAlarm(i);
			}
		}.start();
	}

	private void myCounter2(int eas) {
		new CountDownTimer(eas, 1000) {

			@Override
			public void onTick(long millisUntilFinished) {

			}

			@Override
			public void onFinish() {

			}
		}.start();
	}

	@SuppressWarnings("deprecation")
	protected void displayNotification() {
		// ---PendingIntent to launch activity if the user selects
		// this notification---
		// streamID = mSoundManager.playSound(1);
		Intent i = new Intent(this, NotificationView.class);
		i.putExtra("notificationID", notificationID);
		// i.putExtra("streamID", streamID);
		PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, i, 0);

		NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
		@SuppressWarnings("deprecation")
		Notification notif = new Notification(R.drawable.icon512,
				"Reminder: Meeting starts in 5 minutes",
				System.currentTimeMillis());
		long pattern[] = { 100, 250, 100, 500 };

		vibe.vibrate(pattern, -1);
		CharSequence from = "System Alarm";
		CharSequence message = "Meeting with customer at 3pm...";
		notif.setLatestEventInfo(this, from, message, pendingIntent);
		// ---100ms delay, vibrate for 250ms, pause for 100 ms and
		// then vibrate for 500ms---

		String strSoundAlarm = sharedPreferences.getString(screenName
				+ "LsoundAlarm", "");

		notif.sound = Uri.parse("android.resource://" + getPackageName() + "/"
				+ strSoundAlarm);
		notif.defaults = Notification.DEFAULT_LIGHTS
				| Notification.DEFAULT_VIBRATE;
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
		((TextView) parent.getChildAt(0)).setTextColor(Color.WHITE);
		((TextView) parent.getChildAt(0)).setGravity(Gravity.CENTER);
		String lowerCase = parent.getItemAtPosition(pos).toString()
				.toLowerCase();
		lowerCase = lowerCase.replaceAll("\\s", "");
		if (lowerCase.indexOf("beeps") > 0) {
			lowerCase = "beeps";
		}

		if (Flag == 1) {
			SavePreferences(screenName + "Lspinner", lowerCase);
		}
		if (Flag == 2) {
			SavePreferences(screenName + "Rspinner", lowerCase);
		}
		
		if (mp != null) {
			mp.stop();
		}

		if(lowerCase.equals("vibrate")) {
			long pattern[] = { 100, 250, 100, 500 };
			vibe.vibrate(pattern, -1);
		} else {
			int resID = getResources().getIdentifier(lowerCase, "raw",
					getPackageName());
			mp = MediaPlayer.create(SettingActivity.this, resID);
			mp.setOnCompletionListener(new OnCompletionListener() {
				@Override
				public void onCompletion(MediaPlayer mp) {
					// TODO Auto-generated method stub
					mp.release();
				}

			});
			if (mCounterSpinner < 1) {
				mCounterSpinner++;
			} else {
				mp.start();
			}
		}
	}

	public void onNothingSelected(AdapterView<?> arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	protected Dialog onCreateDialog(int id) {
		switch (id) {
		case 1:
			// set date picker as current date
			return new DatePickerDialog(this, datePickerListener, year, month,
					day);
		case 2:
			// set time picker as current time
			return new TimePickerDialog(this, timePickerListener, hour, minute,
					false);
		}
		return null;

	}

	private DatePickerDialog.OnDateSetListener datePickerListener = new DatePickerDialog.OnDateSetListener() {

		// when dialog box is closed, below method will be called.
		public void onDateSet(DatePicker view, int selectedYear,
				int selectedMonth, int selectedDay) {
			year = selectedYear;
			month = selectedMonth;
			day = selectedDay;

			if (dialogFrom == 1) {
				// set selected date into textview
				StrtDayEditView.setText(new StringBuilder().append(year)
						.append("-").append(month + 1).append("-").append(day)
						.append(" "));
				dialogFrom = 0;
			}
			if (dialogFrom == 2) {
				// set selected date into textview
				endtime.setText(new StringBuilder().append(year).append("-")
						.append(month + 1).append("-").append(day).append(" "));
				dialogFrom = 0;
			}

			// set selected date into datepicker also
			dpResult.init(year, month, day, null);

		}
	};

	public void setCurrentDateOnView() {

		dpResult = (DatePicker) findViewById(R.id.datePicker1);

		final Calendar c = Calendar.getInstance();
		year = c.get(Calendar.YEAR);
		month = c.get(Calendar.MONTH);
		day = c.get(Calendar.DAY_OF_MONTH);
		if(type.equals("1")){
			day = c.get(Calendar.DAY_OF_MONTH) + 3;
		}

		// set current date into datepicker
		dpResult.init(year, month, day, null);

	}

	private TimePickerDialog.OnTimeSetListener timePickerListener = new TimePickerDialog.OnTimeSetListener() {
		public void onTimeSet(TimePicker view, int selectedHour,
				int selectedMinute) {
			hour = selectedHour;
			minute = selectedMinute;

			if (dialogFrom == 3) {
				// set selected date into textview
				mStartTime.setText(new StringBuilder().append(pad(hour))
						.append(":").append(pad(minute)));
				dialogFrom = 0;
			}
			if (dialogFrom == 4) {
				// set selected date into textview
				mEndTime.setText(new StringBuilder().append(pad(hour))
						.append(":").append(pad(minute)));
				dialogFrom = 0;
			}

			// set current time into timepicker
			tpResult.setCurrentHour(hour);
			tpResult.setCurrentMinute(minute);

		}
	};

	// display current time
	public void setCurrentTimeOnView() {
		tpResult = (TimePicker) findViewById(R.id.timePicker1);

		String strSavedMem = "";
		if (Flag == 1) {
			strSavedMem = sharedPreferences.getString(screenName + "LstrtDay",
					null);
		}
		if (Flag == 2) {
			strSavedMem = sharedPreferences.getString(screenName + "RstrtDay",
					null);
		}

		if (strSavedMem != null && !strSavedMem.equals("")) {
			String mhour = mStartTime.getText().toString();
			String[] arrHour = mhour.split(":", -1);

			hour = Integer.parseInt(arrHour[0].trim());
			;
			minute = Integer.parseInt(arrHour[1].trim());
			;

		} else {
			hour = 10;
			minute = 00;
		}

		// set current time into timepicker
		tpResult.setCurrentHour(hour);
		tpResult.setCurrentMinute(minute);

	}

	private static String pad(int c) {
		if (c >= 10)
			return String.valueOf(c);
		else
			return "0" + String.valueOf(c);
	}

	private void startAlarm(int year, int month, int date, int hour,
			int minute, int repeat) {
		month = month - 1;
		Intent intent = new Intent(this, NotificationBarAlarm.class);
		String strSoundAlarm = "";
		int i = 0;
		if (Flag == 1) {
			strSoundAlarm = sharedPreferences.getString(screenName
					+ "LsoundAlarm", "");
			i = sharedPreferences.getInt(screenName + "Lintent", 0);
			Log.d("sound id", strSoundAlarm);
			Log.d("intent id", String.valueOf(i));
		}
		if (Flag == 2) {
			strSoundAlarm = sharedPreferences.getString(screenName
					+ "RsoundAlarm", "");
			i = sharedPreferences.getInt(screenName + "Rintent", 0);
			Log.d("sound id", strSoundAlarm);
			Log.d("intent id", String.valueOf(i));
		}

		intent.putExtra("soundAlarm", strSoundAlarm);
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

		PendingIntent pi = PendingIntent.getBroadcast(context, i, intent, 0);

		Calendar calendar = Calendar.getInstance();
		calendar.set(year, month, date, hour, minute, 0);
		long when = calendar.getTimeInMillis();
		AlarmManager am = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
		// am.setInexactRepeating(AlarmManager.RTC_WAKEUP,
		// calendar.getTimeInMillis(), 1000, pi);
		// am.set(AlarmManager.RTC_WAKEUP, when, pi);
		am.setRepeating(AlarmManager.RTC_WAKEUP, when, repeat, pi);
	}

	private void stopAlarm(int i) {
		Intent intentstop = new Intent(this, NotificationBarAlarm.class);
		PendingIntent senderstop = PendingIntent.getBroadcast(this, i,
				intentstop, 0);
		AlarmManager alarmManagerstop = (AlarmManager) getSystemService(ALARM_SERVICE);
		alarmManagerstop.cancel(senderstop);
	}
}