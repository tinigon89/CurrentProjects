package com.example.implantproject;

import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.support.v4.app.NavUtils;

public class TermConditionActivity extends Activity implements OnCheckedChangeListener {
private CheckBox conditions;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.disclaimer);
        setTitle("Breast Implant excersice");
        conditions = (CheckBox)findViewById(R.id.checkBox1);
        conditions.setOnCheckedChangeListener(this);
       
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_term_condition, menu);
        return true;
    }

	@Override
	public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
		// TODO Auto-generated method stub
		this.finish();
		 startActivity(new Intent (TermConditionActivity.this,MainActivity.class));
	}

    
}
