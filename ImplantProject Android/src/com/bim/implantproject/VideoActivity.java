package com.bim.implantproject;

import android.net.Uri;
import android.os.Bundle;
import android.app.Activity;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.MediaController;
import android.widget.VideoView;
import com.bim.implantproject.R;

public class VideoActivity extends Activity implements OnClickListener {
private VideoView mVideoView;
private int flag = 0;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.videoviewlayout);
       
        int streamID = getIntent().getExtras().getInt("Videoname", 0);
        mVideoView = (VideoView) findViewById(R.id.videoView1);
        mVideoView.setVideoURI(Uri.parse("android.resource://" + getPackageName() +"/"+streamID)); 
       
        mVideoView.setMediaController(new MediaController(this));
        mVideoView.start();
        mVideoView.requestFocus();
        
         Button b = (Button)findViewById(R.id.button2);
         b.setOnClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.videoviewl, menu);
        return true;
    }

	@Override
	public void onClick(View arg0) {
		// TODO Auto-generated method stub
		switch(arg0.getId()){
		
		case R.id.button2:
			mVideoView.pause();
			finish();
		}
	}
}
