package com.bim.implantproject;

import android.os.Bundle;
import android.preference.PreferenceManager;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.support.v4.app.NavUtils;
import com.bim.implantproject.R;

public class TermConditionActivity extends Activity implements
		OnCheckedChangeListener {
	private CheckBox conditions;
	SharedPreferences prefs;
	SharedPreferences.Editor editor;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.disclaimer);
		setTitle("Breast Implant Exercises");
		conditions = (CheckBox) findViewById(R.id.checkBox1);
		conditions.setOnCheckedChangeListener(this);
		prefs = PreferenceManager.getDefaultSharedPreferences(this);
		editor = prefs.edit();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_term_condition, menu);
		return true;
	}

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		// TODO Auto-generated method stub
		editor.putBoolean("firsttime", false);
		editor.commit();
		this.finish();
		// startActivity(new Intent
		// (TermConditionActivity.this,MainActivity.class));
	}

}