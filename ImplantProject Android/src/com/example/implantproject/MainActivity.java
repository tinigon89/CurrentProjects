package com.example.implantproject;



import android.app.Activity;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.MimeTypeMap;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;


public class MainActivity extends Activity implements OnClickListener  {
	 
	 int Flag = 1;
	 static int count = 1;
	 private TextView disclaimer;
	 Context context = this;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.phase);
        TextView b = (TextView)findViewById(R.id.textView1);
        b.setOnClickListener(this);
        TextView b1 = (TextView)findViewById(R.id.textView4);
        b1.setOnClickListener(this);
        disclaimer = (TextView)findViewById(R.id.textView3);
        disclaimer.setOnClickListener(this);
    
    }
	
	
	public void onClick(View v) {
		// TODO Auto-generated method stub
		switch(v.getId()){
		case R.id.textView1:
			
			 startActivity(new Intent (MainActivity.this,MassageActivity.class));
			break;
		case R.id.textView4:
			startActivity(new Intent(MainActivity.this,SecondPhase.class));
			break;
			
		case R.id.textView3:
			
			startActivity(new Intent(MainActivity.this,ViewFlipperSampleActivity.class));
		
  			 
  		/*	Uri file= Uri.parse("file:///android_asset/TermOfUser.pdf");
  		  String mimeType =  MimeTypeMap.getSingleton().getMimeTypeFromExtension(MimeTypeMap.getFileExtensionFromUrl(file.toString()));

  		try{
  		     Intent i;
  		     i = new Intent(Intent.ACTION_VIEW);
  		     i.setDataAndType(file,mimeType);
  		     startActivity(i);

  		}catch (ActivityNotFoundException e) {
  		                    Toast.makeText(this, 
  		                        "No Application Available to view this file type", 
  		                        Toast.LENGTH_SHORT).show();
  		                } */
  			  
			break;
		}
	}
}
       