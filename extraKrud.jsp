<%!
	// prepare strings to be embedded into SQL commands
	static String strToDb(String s) {
		if((s != null) && (s.length() > 0))
			return "'" + s.replace("'", "''") + "'";
		return "NULL";
	}

	// prepare strings to be embedded into SQL commands
	static String strFromDb(String s) {
		if(s == null)
			return "";
		return s;
	}

	// prepare long integers to be embedded into SQL commands
	static String longToDb(String s) {
		return Long.toString(Long.parseLong(s));
	}

	static String longToDb(long val) {
		return Long.toString(val);
	}

	// Delete the given audiorec and all related data
	static boolean audiorecDelete(String id) throws Exception {
		boolean rc = false;

		if(id == null || id.length() < 1)
			return rc;

		try {
			dbConnGet().createStatement().execute(
					"start transaction;"
					+ " delete from reviews where release_id in (select id from releases where audiorec_id=" + id + ");"
					+ " delete from releases where audiorec_id=" + id + ";"
					+ " delete from audiorecs where id=" + id + ";"
					+ " commit;"
				);
			// NOTE: the above SQL will not return an error, even if the IDs don't exist
			// It will return an error if the id value is not an integer
			rc = true;
		}
		catch(Exception e1) {
			// Try to roll back the deletes
			try {
				dbConnGet().createStatement().execute("rollback;");
				// If this works (no exception), we have no other error to catch or recover from.
			}
			catch(Exception e2) {
				// Rollback failed; handle the original exception
				// reset the DB connection to force a reconnect next time
				dbConnReset();
			}
		}
		return rc;
	}

	// Returns SQL query that when executed will return a histogram of rating values & frequency
	static String getReviewHistogramQuery(String func, String col) {
		StringBuffer	sb = new StringBuffer();
		sb.append("select rating, cnt, cast(cnt as float) / ")
			.append(func)
			.append("() as pct")
			.append(" from (select ")
			.append(col)
			.append(" as rating, count(*) as cnt from reviews group by 1) t1")
			.append(" order by 1;");
		return sb.toString();
	}

	// Data to return from processRow()
	static class RowData {
		public RowData(String r, String c, String p, String b) {
			rat = r;
			cnt = c;
			pct = p;
			bar = b;
		}
		public String	rat, cnt, pct, bar;
	}

	// How long to make the barchart graphs in the histograms
	static final double bar_scale = 3.0;

	// Process a row in the histogram for ratings & reviews
	static RowData processHistogramRow(ResultSet rs) throws Exception {
		String			r, c, f;
		Double			pct;
		StringBuffer	bar_str;
		int				bar_len;
		r = String.format("%d", rs.getInt("rating"));
		c = String.format("%,4d", rs.getInt("cnt"));
		pct = rs.getDouble("pct") * 100.0;
		f = String.format("%3.1f", pct);
		bar_str = new StringBuffer();
		bar_len = (int)(pct / bar_scale + 0.5);
		for(int i = 0; i < bar_len; i++)
			bar_str.append("=");
		return new RowData(r, c, f, bar_str.toString());
	}
%>
