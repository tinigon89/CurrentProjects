package com.example.implantproject;

import android.R.integer;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

/**
 * Simple notes database access helper class. Defines the basic CRUD operations
 * for the notepad example, and gives the ability to list all notes as well as
 * retrieve or modify a specific note.
 * 
 * This has been improved from the first version of this tutorial through the
 * addition of better error handling and also using returning a Cursor instead
 * of using a collection of inner classes (which is less scalable and not
 * recommended).
 */
public class ItemDbAdapter {

	// Define Key field
	public static final String KEY_TITLE = "title";
	public static final String KEY_URL = "url";
	public static final String KEY_MDES = "mdes";
	public static final String KEY_TYPE = "type";
	public static final String KEY_ROWID = "_id";

	// initialize object process with database
	private static final String TAG = "ItemDbAdapter";
	private DatabaseHelper mDbHelper;
	private SQLiteDatabase mDb;

	// Database creation sql statement
	private static final String DATABASE_CREATE = "create table items (_id integer primary key, "
			+ "title text not null, url text not null, mdes text not null, type text not null);";

	// Database info
	private static final String DATABASE_NAME = "implantproject";
	private static final String DATABASE_TABLE = "items";
	private static final int DATABASE_VERSION = 1;

	private final Context mCtx;

	private static class DatabaseHelper extends SQLiteOpenHelper {

		DatabaseHelper(Context context) {
			super(context, DATABASE_NAME, null, DATABASE_VERSION);
		}

		@Override
		public void onCreate(SQLiteDatabase db) {

			db.execSQL(DATABASE_CREATE);
		}

		@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
			/*
			 * Log.w(TAG, "Upgrading database from version " + oldVersion +
			 * " to " + newVersion + ", which will destroy all old data");
			 * db.execSQL("DROP TABLE IF EXISTS notes"); onCreate(db);
			 */
		}
	}

	// Constructor - takes the context to allow the database to be opened or
	// created
	public ItemDbAdapter(Context ctx) {
		this.mCtx = ctx;
	}

	// Open the Notes database
	public ItemDbAdapter open() throws SQLException {
		mDbHelper = new DatabaseHelper(mCtx);
		mDb = mDbHelper.getWritableDatabase();
		return this;
	}

	// Close the Notes database
	public void close() {
		mDbHelper.close();
	}

	// Create
	public long createCg(long id, String title, String url, String mdes, String type) {
		ContentValues initialValues = new ContentValues();
		//initialValues.put(KEY_ROWID, id);
		initialValues.put(KEY_TITLE, title);
		initialValues.put(KEY_URL, url);
		initialValues.put(KEY_MDES, mdes);
		initialValues.put(KEY_TYPE, type);

		return mDb.insert(DATABASE_TABLE, null, initialValues);
	}

	// Delete
	public boolean deleteCg(long rowId) {

		return mDb.delete(DATABASE_TABLE, KEY_ROWID + "=" + rowId, null) > 0;
	}

	// Get all
	public Cursor fetchAllCgs(String type) {

		return mDb.query(DATABASE_TABLE, new String[] { KEY_ROWID, KEY_TITLE,
				KEY_URL, KEY_MDES, KEY_TYPE }, KEY_TYPE + " = " + type, null, null, null, null);
	}

	// Get
	public Cursor fetchCg(long rowId) throws SQLException {

		Cursor mCursor = mDb.query(true, DATABASE_TABLE, new String[] {
				KEY_ROWID, KEY_TITLE, KEY_URL, KEY_MDES, KEY_TYPE  }, KEY_ROWID + "="
				+ rowId, null, null, null, null, null);
		if (mCursor != null) {
			mCursor.moveToFirst();
		}
		return mCursor;

	}

	// Delete all
	public boolean deleteAllCg() {

		return mDb.delete(DATABASE_TABLE, null, null) > 0;
	}
}