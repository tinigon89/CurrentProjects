package com.bim.implantproject;

import com.bim.implantproject.MassageActivity;
import com.bim.implantproject.R;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;


public class AddItemActivity extends Activity {
	private static ItemDbAdapter mDbHelper;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.additem);
        
        mDbHelper = new ItemDbAdapter(this);
		mDbHelper.open();
        
        final EditText title = (EditText) findViewById(R.id.item_title2);
        final EditText url = (EditText) findViewById(R.id.item_url);
        final EditText mdes = (EditText) findViewById(R.id.item_mdes);
        
        final String type = getIntent().getExtras().getString("type");
        
        Button btnAdd = (Button) findViewById(R.id.save);
		btnAdd.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				String mtitle = title.getText().toString();
				String murl = url.getText().toString();
				String mndes = mdes.getText().toString();
				if(mtitle.equals("") || murl.equals("") || mndes.equals("")){
					Toast.makeText(getApplicationContext(), "Please input all fields.",
							Toast.LENGTH_SHORT).show();
				} else {
					mDbHelper.createCg(0, mtitle, murl, mndes, type);
					Intent i = new Intent(AddItemActivity.this, MassageActivity.class);
					i.putExtra("type", type);
					startActivity(i);
					finish();
				}
			}
		});
		
		Button btnCancel = (Button) findViewById(R.id.cancel);
		btnCancel.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				Intent i = new Intent(AddItemActivity.this, MassageActivity.class);
				i.putExtra("type", type);
				startActivity(i);
				finish();
			}
		});
    
    }
}
       