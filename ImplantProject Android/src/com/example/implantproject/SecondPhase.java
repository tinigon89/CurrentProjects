package com.example.implantproject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.MediaController;
import android.widget.TextView;
import android.widget.ToggleButton;
import android.widget.VideoView;



public class SecondPhase extends Activity implements OnClickListener {
private TextView IstExcercise;
private TextView SecExcercise;
private TextView ThirdExcercise;
private TextView fourthExcercise;
private ImageButton Instructions;

private ToggleButton togglebutton;
private int counter = 0;
private TextView home;
private Context context = this;
private Intent i;
private TextView tvVide;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.phase2); 
        IstExcercise = (TextView)findViewById(R.id.exercise1);
        IstExcercise.setOnClickListener(this);
        SecExcercise = (TextView)findViewById(R.id.exercise2);
        SecExcercise.setOnClickListener(this);
        ThirdExcercise = (TextView)findViewById(R.id.exercise3);
        ThirdExcercise.setOnClickListener(this);
        fourthExcercise = (TextView)findViewById(R.id.exercise4);
        fourthExcercise.setOnClickListener(this);
        Instructions = (ImageButton)findViewById(R.id.imageButton1);
        Instructions.setOnClickListener(this);
        
        togglebutton = (ToggleButton)findViewById(R.id.toggleButton1);
        togglebutton.setOnClickListener(this);
        home = (TextView)findViewById(R.id.home);
        home.setOnClickListener(this);
        tvVide = (TextView)findViewById(R.id.tvVideo);
        tvVide.setOnClickListener(this);
        }

	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
		case R.id.toggleButton1:
			counter++;
			break;
		case R.id.tvVideo:
			i = new Intent(SecondPhase.this,VideoActivity.class);
			i.putExtra("Videoname", R.raw.phase222);
			startActivity(i);
			break;
		case R.id.home:
			//startActivity(new Intent (SecondPhase.this,MainActivity.class));
			finish();
			break;
		case R.id.exercise1:
			SavePreferences("Title", "Exercise 1");
			i = new Intent (SecondPhase.this,SettingActivity.class);
			i.putExtra("TogglebuttonValue", counter);
			startActivity(i);
		
			break;
		case R.id.exercise2:
			SavePreferences("Title", "Exercise 2");
			i = new Intent (SecondPhase.this,SettingActivity.class);
			i.putExtra("TogglebuttonValue", counter);
			startActivity(i);
			break;
		case R.id.exercise3:
			SavePreferences("Title", "Exercise 3");
			i = new Intent (SecondPhase.this,SettingActivity.class);
			i.putExtra("TogglebuttonValue", counter);
			startActivity(i);
				break;
		case R.id.exercise4:
			SavePreferences("Title", "Exercise 4");
			i = new Intent (SecondPhase.this,SettingActivity.class);
			i.putExtra("TogglebuttonValue", counter);
			startActivity(i);
					break;
		case R.id.imageButton1:
			 
			final Dialog dialog = new Dialog(context);
			dialog.setContentView(R.layout.phasetwodialog);
			
			dialog.setTitle("...");

			Button dialogButton = (Button) dialog
					.findViewById(R.id.button1);
			dialogButton.setOnClickListener(new View.OnClickListener() {

				public void onClick(View v) {
					// TODO Auto-generated method stub
               

					dialog.dismiss();
				}
			});
			dialog.show();
			
			break;
		}
	}
	private void SavePreferences(String key, String value){
	    SharedPreferences sharedPreferences = getSharedPreferences("MY_SHARED_PREF", MODE_PRIVATE);
	    SharedPreferences.Editor editor = sharedPreferences.edit();
	    editor.putString(key, value);
	    editor.commit();
	   }
}
