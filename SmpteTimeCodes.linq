<Query Kind="Program" />


void Main()
{
	//const string timecodeString = "01:01:21:00";
	//const string timecodeString = "01:00:54:00";
	//const string timecodeString = "01:05:00:00";
	const string timecodeString = "01:01:16:00";
	var timeCode = new TimeCode(timecodeString, SmpteFrameRate.Smpte30);
	timeCode.ToString().Dump();
	timeCode.Dump();

//	double timeCodeIn = 10.0;
//	double videoFrameRate = 30;
//	var parsedFrameRate = TimeCode.ParseFramerate(videoFrameRate);		
//	var timeCode = new TimeCode(timeCodeIn, parsedFrameRate);
//	timeCode.ToString().Dump();
//	timeCode.Dump();
}

// Define other methods and classes here
/// <summary> 
/// SMPTE Frame Rates enumeration. Use this enumeration with the Timecode struct to set the framerate for the Timecode. 
/// </summary> 
/// <remarks>  
/// Framerates supported by the Timecode class include, 23.98 IVTC Film Sync, 24fps Film Sync, 25fps PAL, 29.97 drop frame, 
/// 29.97 Non drop, and 30fps. 
/// </remarks> 
public enum SmpteFrameRate
{
	/// <summary> 
	/// SMPTE 23.98 frame rate. Also known as Film Sync. 
	/// </summary> 
	Smpte2398 = 0,

	/// <summary> 
	/// SMPTE 24 fps frame rate. 
	/// </summary> 
	Smpte24 = 1,

	/// <summary> 
	/// SMPTE 25 fps frame rate. Also known as PAL. 
	/// </summary> 
	Smpte25 = 2,

	/// <summary> 
	/// SMPTE 29.97 fps Drop Frame timecode. Used in the NTSC television system. 
	/// </summary> 
	Smpte2997Drop = 3,

	/// <summary> 
	/// SMPTE 29.97 fps Non Drop Fram timecode. Used in the NTSC television system. 
	/// </summary> 
	Smpte2997NonDrop = 4,

	/// <summary> 
	/// SMPTE 30 fps frame rate. 
	/// </summary> 
	Smpte30 = 5,

	/// <summary> 
	/// SMPTE 50 fps frame rate. 
	/// </summary> 
	Smpte50 = 6,

	/// <summary> 
	/// SMPTE 59.94 fps Drop Frame timecode. Used in the NTSC television system. 
	/// </summary> 
	Smpte5994Drop = 7,

	/// <summary> 
	/// SMPTE 59.94 fps Non Drop Fram timecode. Used in the NTSC television system. 
	/// </summary> 
	Smpte5994NonDrop = 8,

	/// <summary> 
	/// SMPTE 60 fps frame rate. 
	/// </summary> 
	Smpte60 = 9,

	/// <summary> 
	/// UnKnown Value. 
	/// </summary> 
	Unknown = -1
}

/// <summary>
/// Represents a SMPTE 12M standard time code and provides conversion operations to various SMPTE time code formats and rates.
/// </summary>
/// <remarks>
/// Framerates supported by the TimeCode class include, 23.98 IVTC Film Sync, 24fps Film Sync, 25fps PAL, 29.97 drop frame,
/// 29.97 Non drop, 30fps, 50fps, 59.94 drop frame, 59.94 Non drop and 60fps.
/// </remarks>
public struct TimeCode : IComparable, IComparable<TimeCode>, IEquatable<TimeCode>
{
	/// <summary>
	/// Regular expression string used for parsing out the timecode.
	/// </summary>
	// ReSharper disable once InconsistentNaming
	private const string SMPTEREGEXSTRING = "(?<Hours>\\d{2}):(?<Minutes>\\d{2}):(?<Seconds>\\d{2})(?::|;)(?<Frames>\\d{2})";

	/// <summary>
	/// Epsilon value to deal with rounding precision issues with decimal and double values.
	/// </summary>
	// ReSharper disable once InconsistentNaming
	private const decimal EPSILON = 0.00000000000000000000001M;

	/// <summary>
	/// Regular expression object used for validating timecode.
	/// </summary>
	private static readonly Regex ValidateTimecode = new Regex(SMPTEREGEXSTRING, RegexOptions.CultureInvariant);

	/// <summary>
	/// The private Timespan used to track absolute time for this instance.
	/// </summary>
	private readonly decimal _absoluteTime;

	/// <summary>
	/// The frame rate for this instance.
	/// </summary>
	private SmpteFrameRate _frameRate;

	/// <summary>
	///  Initializes a new instance of the TimeCode struct to a specified number of hours, minutes, and seconds.
	/// </summary>
	/// <param name="hours">Number of hours.</param>
	/// <param name="minutes">Number of minutes.</param>
	/// <param name="seconds">Number of seconds.</param>
	/// <param name="frames">Number of frames.</param>
	/// <param name="rate">The SMPTE frame rate.</param>
	/// <exception cref="System.FormatException">
	/// The parameters specify a TimeCode value less than TimeCode.MinValue
	/// or greater than TimeCode.MaxValue, or the values of time code components are not valid for the SMPTE framerate.
	/// </exception>
	/// <code source="..\Documentation\SdkDocSamples\TimecodeSamples.cs" region="CreateTimeCode_2398FromIntegers" lang="CSharp" title="Create TimeCode from Integers"/>
	public TimeCode(int hours, int minutes, int seconds, int frames, SmpteFrameRate rate)
	{
		var timeCode = String.Format("{0:D2}:{1:D2}:{2:D2}:{3:D2}", hours, minutes, seconds, frames);
		_frameRate = rate;
		_absoluteTime = Smpte12MToAbsoluteTime(timeCode, _frameRate);
	}

	/// <summary>
	///  Initializes a new instance of the TimeCode struct to a specified number of hours, minutes, and seconds.
	/// </summary>
	/// <param name="days">Number of days.</param>
	/// <param name="hours">Number of hours.</param>
	/// <param name="minutes">Number of minutes.</param>
	/// <param name="seconds">Number of seconds.</param>
	/// <param name="frames">Number of frames.</param>
	/// <param name="rate">The SMPTE frame rate.</param>
	/// <exception cref="System.FormatException">
	/// The parameters specify a TimeCode value less than TimeCode.MinValue
	/// or greater than TimeCode.MaxValue, or the values of time code components are not valid for the SMPTE framerate.
	/// </exception>
	/// <code source="..\Documentation\SdkDocSamples\TimecodeSamples.cs" region="CreateTimeCode_2398FromIntegers" lang="CSharp" title="Create TimeCode from Integers"/>
	public TimeCode(int days, int hours, int minutes, int seconds, int frames, SmpteFrameRate rate)
	{
		var timeCode = String.Format("{0}:{1:D2}:{2:D2}:{3:D2}:{4:D2}", days, hours, minutes, seconds, frames);
		_frameRate = rate;
		_absoluteTime = Smpte12MToAbsoluteTime(timeCode, _frameRate);
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct using an Int32 in hex format containing the time code value compatible with the Windows Media Format SDK.
	/// Time code is stored so that the hexadecimal value is read as if it were a decimal value. That is, the time code value 0x01133512 does not represent decimal 18035986, rather it specifies 1 hour, 13 minutes, 35 seconds, and 12 frames.
	/// </summary>
	/// <param name="windowsMediaTimeCode">The integer value of the timecode.</param>
	/// <param name="rate">The SMPTE frame rate.</param>
	public TimeCode(int windowsMediaTimeCode, SmpteFrameRate rate)
	{
		// Timecode is provided back formatted as hexadecimal bytes read in single bytes from left to right.
		var timeCodeBytes = BitConverter.GetBytes(windowsMediaTimeCode);
		var timeCode = String.Format("{3:x2}:{2:x2}:{1:x2}:{0:x2}", timeCodeBytes[0], timeCodeBytes[1], timeCodeBytes[2], timeCodeBytes[3]);

		_frameRate = rate;
		_absoluteTime = Smpte12MToAbsoluteTime(timeCode, _frameRate);
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct using the TotalSeconds in the supplied TimeSpan.
	/// </summary>
	/// <param name="timeSpan">The <see cref="TimeSpan"/> to be used for the new timecode.</param>
	/// <param name="rate">The SMPTE frame rate.</param>
	public TimeCode(TimeSpan timeSpan, SmpteFrameRate rate)
	{
		_frameRate = rate;
		_absoluteTime = FromTimeSpan(timeSpan, rate)._absoluteTime;
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct using a time code string that contains the framerate at the end of the string.
	/// </summary>
	/// <remarks>
	/// Pass in a timecode in the format "timecode@framrate". 
	/// Supported rates include @23.98, @24, @25, @29.97, @30
	/// </remarks>
	/// <example>
	/// "00:01:00:00@29.97" is equivalent to 29.97 non drop frame.
	/// "00:01:00;00@29.97" is equivalent to 29.97 drop frame.
	/// </example>
	/// <param name="timeCodeAndRate">The SMPTE 12m time code string.</param>
	public TimeCode(string timeCodeAndRate)
	{
		var timeAndRate = timeCodeAndRate.Split('@');

		var time = string.Empty;
		var rate = string.Empty;

		if (timeAndRate.Length == 1)
		{
			time = timeAndRate[0];
			rate = "29.97";
		}
		else if (timeAndRate.Length == 2)
		{
			time = timeAndRate[0];
			rate = timeAndRate[1];
		}

		_frameRate = SmpteFrameRate.Smpte2997NonDrop;

		if (rate == "59.94" && time.IndexOf(';') > -1)
		{
			_frameRate = SmpteFrameRate.Smpte5994Drop;
		}
		else if (rate == "59.94" && time.IndexOf(';') == -1)
		{
			_frameRate = SmpteFrameRate.Smpte5994NonDrop;
		}
		if (rate == "29.97" && time.IndexOf(';') > -1)
		{
			_frameRate = SmpteFrameRate.Smpte2997Drop;
		}
		else if (rate == "29.97" && time.IndexOf(';') == -1)
		{
			_frameRate = SmpteFrameRate.Smpte2997NonDrop;
		}
		else if (rate == "25")
		{
			_frameRate = SmpteFrameRate.Smpte25;
		}
		else if (rate == "23.98")
		{
			_frameRate = SmpteFrameRate.Smpte2398;
		}
		else if (rate == "24")
		{
			_frameRate = SmpteFrameRate.Smpte24;
		}
		else if (rate == "30")
		{
			_frameRate = SmpteFrameRate.Smpte30;
		}
		else if (rate == "50")
		{
			_frameRate = SmpteFrameRate.Smpte50;
		}
		else if (rate == "60")
		{
			_frameRate = SmpteFrameRate.Smpte60;
		}

		_absoluteTime = Smpte12MToAbsoluteTime(time, _frameRate);
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct using a time code string and a SMPTE framerate.
	/// </summary>
	/// <param name="timeCode">The SMPTE 12m time code string.</param>
	/// <param name="rate">The SMPTE framerate used for this instance of TimeCode.</param>
	public TimeCode(string timeCode, SmpteFrameRate rate)
	{
		_frameRate = rate;
		_absoluteTime = Smpte12MToAbsoluteTime(timeCode, _frameRate);
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct using an absolute time value, and the SMPTE framerate.
	/// </summary>
	/// <param name="absoluteTime">The double that represents the absolute time value.</param>
	/// <param name="rate">The SMPTE framerate that this instance should use.</param>
	public TimeCode(double absoluteTime, SmpteFrameRate rate)
	{
		_absoluteTime = Convert.ToDecimal(absoluteTime);
		_frameRate = rate;
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct using an absolute time value in <see cref="decimal"/> precision, and the SMPTE framerate.
	/// </summary>
	/// <param name="absoluteTime">The <see cref="decimal"/> that represents the absolute time value.</param>
	/// <param name="rate">The SMPTE framerate that this instance should use.</param>
	/// <remarks>This is a more precise way to initialize the TimeCode. Double values in .NET can be less precise and cause rounding errors on frame boundaries.</remarks>
	public TimeCode(decimal absoluteTime, SmpteFrameRate rate)
	{
		_absoluteTime = absoluteTime;
		_frameRate = rate;
	}

	/// <summary>
	///  Gets the number of ticks in 1 day. 
	///  This field is constant.
	/// </summary>
	/// <value>The number of ticks in 1 day.</value>
	public static long TicksPerDay
	{
		get { return 864000000000; }
	}

	/// <summary>
	///  Gets the number of absolute time ticks in 1 day. 
	///  This field is constant.
	/// </summary>
	/// <value>The number of absolute time ticks in 1 day.</value>
	public static double TicksPerDayAbsoluteTime
	{
		get { return 86400; }
	}

	/// <summary>
	///  Gets the number of ticks in 1 hour. This field is constant.
	/// </summary>
	/// <value>The number of ticks in 1 hour.</value>
	public static long TicksPerHour
	{
		get { return 36000000000; }
	}

	/// <summary>
	///  Gets the number of absolute time ticks in 1 hour. This field is constant.
	/// </summary>
	/// <value>The number of absolute time ticks in 1 hour.</value>
	public static double TicksPerHourAbsoluteTime
	{
		get { return 3600; }
	}

	/// <summary>
	/// Gets the number of ticks in 1 millisecond. This field is constant.
	/// </summary>
	/// <value>The number of ticks in 1 millisecond.</value>
	public static long TicksPerMillisecond
	{
		get { return 10000; }
	}

	/// <summary>
	/// Gets the number of ticks in 1 millisecond. This field is constant.
	/// </summary>
	/// <value>The number of ticks in 1 millisecond.</value>
	public static double TicksPerMillisecondAbsoluteTime
	{
		get { return 0.0010000D; }
	}

	/// <summary>
	/// Gets the number of ticks in 1 minute. This field is constant.
	/// </summary>
	/// <value>The number of ticks in 1 minute.</value>
	public static long TicksPerMinute
	{
		get { return 600000000; }
	}

	/// <summary>
	/// Gets the number of absolute time ticks in 1 minute. This field is constant.
	/// </summary>
	/// <value>The number of absolute time ticks in 1 minute.</value>
	public static double TicksPerMinuteAbsoluteTime
	{
		get { return 60; }
	}

	/// <summary>
	/// Gets the number of ticks in 1 second.
	/// </summary>
	/// <value>The number of ticks in 1 second.</value>
	public static long TicksPerSecond
	{
		get { return 10000000; }
	}

	/// <summary>
	/// Gets the number of ticks in 1 second.
	/// </summary>
	/// <value>The number of ticks in 1 second.</value>
	public static double TicksPerSecondAbsoluteTime
	{
		get { return 1.0000000D; }
	}

	/// <summary>
	/// Gets the minimum TimeCode value. This field is read-only.
	/// </summary>
	/// <value>The minimum TimeCode value.</value>
	public static double MinValue
	{
		get { return 0; }
	}


	/// <summary>
	///  Gets the maximum TimeCode value of a known frame rate. The Max value for Timecode.
	/// </summary>
	/// <param name="frameRate">The frame rate to get the max value.</param>
	/// <returns>The maximum TimeCode value for the given frame rate.</returns>
	public static decimal MaxValue(SmpteFrameRate frameRate)
	{
		switch (frameRate)
		{
			case SmpteFrameRate.Smpte2398:
				return 86486.358291666700000M;

			case SmpteFrameRate.Smpte24:
				return 86399.958333333300000M;

			case SmpteFrameRate.Smpte25:
				return 86399.960000000000000M;

			case SmpteFrameRate.Smpte2997Drop:
				return 86399.880233333300000M;

			case SmpteFrameRate.Smpte2997NonDrop:
				return 86486.366633333300000M;

			case SmpteFrameRate.Smpte30:
				return 86399.966666666700000M;

			case SmpteFrameRate.Smpte50:
				return 86399.980000000000000M;

			case SmpteFrameRate.Smpte5994Drop:
				return 86399.896916666700000M;

			case SmpteFrameRate.Smpte5994NonDrop:
				return 86486.383316670000000M;

			case SmpteFrameRate.Smpte60:
				return 86399.983333333300000M;

			default:
				return 86399;
		}
	}

	/// <summary>
	/// Gets the absolute time in seconds of the current TimeCode object.
	/// </summary>
	/// <returns>
	///  A double that is the absolute time in seconds duration of the current TimeCode object.
	/// </returns>
	/// <value>The absolute time in seconds of the current TimeCode.</value>
	public double Duration
	{
		get { return Convert.ToDouble(_absoluteTime); }
	}

	/// <summary>
	/// Gets or sets the current SMPTE framerate for this TimeCode instance.
	/// </summary>
	/// <value>The frame rate of the TimeCode.</value>
	public SmpteFrameRate FrameRate
	{
		get { return _frameRate; }
		set { _frameRate = value; }
	}

	/// <summary>
	///  Gets the number of whole days represented by the current TimeCode
	///  structure.
	/// </summary>
	/// <returns>
	///  The hour component of the current TimeCode structure.
	/// </returns>
	/// <value>The number of whole days of the TimeCode.</value>
	public int DaysSegment
	{
		get
		{
			var timeCode = AbsoluteTimeToSmpte12M(_absoluteTime, _frameRate);

			var days = "0";

			if (timeCode.Length > 11)
			{
				var index = timeCode.IndexOf(":", StringComparison.Ordinal);
				days = timeCode.Substring(0, index);
			}

			return Int32.Parse(days);
		}
	}

	/// <summary>
	///  Gets the number of whole hours represented by the current TimeCode
	///  structure.
	/// </summary>
	/// <returns>
	///  The hour component of the current TimeCode structure. The return value
	///     ranges from 0 through 23.
	/// </returns>
	/// <value>The number of whole hours of the TimeCode.</value>
	public int HoursSegment
	{
		get
		{
			var timeCode = AbsoluteTimeToSmpte12M(_absoluteTime, _frameRate);

			if (timeCode.Length > 11)
			{
				var index = timeCode.IndexOf(":", StringComparison.Ordinal) + 1;
				timeCode = timeCode.Substring(index, timeCode.Length - index);
			}

			var hours = timeCode.Substring(0, 2);

			return Int32.Parse(hours);
		}
	}

	/// <summary>
	/// Gets the number of whole minutes represented by the current TimeCode structure.
	/// </summary>
	/// <returns>
	/// The minute component of the current TimeCode structure. The return
	/// value ranges from 0 through 59.
	/// </returns>
	/// <value>The number of whole minutes of the current TimeCode.</value>
	public int MinutesSegment
	{
		get
		{
			var timeCode = AbsoluteTimeToSmpte12M(_absoluteTime, _frameRate);

			if (timeCode.Length > 11)
			{
				var index = timeCode.IndexOf(":", StringComparison.Ordinal) + 1;
				timeCode = timeCode.Substring(index, timeCode.Length - index);
			}

			var minutes = timeCode.Substring(3, 2);

			return Int32.Parse(minutes);
		}
	}

	/// <summary>
	/// Gets the number of whole seconds represented by the current TimeCode structure.
	/// </summary>
	/// <returns>
	///  The second component of the current TimeCode structure. The return
	///    value ranges from 0 through 59.
	/// </returns>
	/// <value>The number of whole seconds of the current TimeCode.</value>
	public int SecondsSegment
	{
		get
		{
			var timeCode = AbsoluteTimeToSmpte12M(_absoluteTime, _frameRate);

			if (timeCode.Length > 11)
			{
				var index = timeCode.IndexOf(":", StringComparison.Ordinal) + 1;
				timeCode = timeCode.Substring(index, timeCode.Length - index);
			}

			var seconds = timeCode.Substring(6, 2);

			return Int32.Parse(seconds);
		}
	}

	/// <summary>
	/// Gets the number of whole frames represented by the current TimeCode
	///     structure.
	/// </summary>
	/// <returns>
	/// The frame component of the current TimeCode structure. The return
	///     value depends on the framerate selected for this instance. All frame counts start at zero.
	/// </returns>
	/// <value>The number of whole frames of the TimeCode.</value>
	public int FramesSegment
	{
		get
		{
			var timeCode = AbsoluteTimeToSmpte12M(_absoluteTime, _frameRate);

			if (timeCode.Length > 11)
			{
				var index = timeCode.IndexOf(":", StringComparison.Ordinal) + 1;
				timeCode = timeCode.Substring(index, timeCode.Length - index);
			}

			var frames = timeCode.Substring(9, 2);

			return Int32.Parse(frames);
		}
	}

	/// <summary>
	/// Gets the value of the current TimeCode structure expressed in whole
	///     and fractional days.
	/// </summary>
	/// <returns>
	///  The total number of days represented by this instance.
	/// </returns>
	/// <value>The number of days of the TimeCode.</value>
	public double TotalDays
	{
		get
		{
			var framecount = AbsoluteTimeToFrames(_absoluteTime, _frameRate);
			return (framecount / 108000D) / 24;
		}
	}

	/// <summary>
	/// Gets the value of the current TimeCode structure expressed in whole
	///     and fractional hours.
	/// </summary>
	/// <returns>
	///  The total number of hours represented by this instance.
	/// </returns>
	/// <value>The number of hours of the TimeCode.</value>
	public double TotalHours
	{
		get
		{
			var framecount = AbsoluteTimeToFrames(_absoluteTime, _frameRate);

			double hours;

			switch (_frameRate)
			{
				case SmpteFrameRate.Smpte2398:
				case SmpteFrameRate.Smpte24:
					hours = framecount / 86400D;
					break;
				case SmpteFrameRate.Smpte25:
					hours = framecount / 90000D;
					break;
				case SmpteFrameRate.Smpte2997Drop:
					hours = framecount / 107892D;
					break;
				case SmpteFrameRate.Smpte2997NonDrop:
				case SmpteFrameRate.Smpte30:
					hours = framecount / 108000D;
					break;
				case SmpteFrameRate.Smpte50:
					hours = framecount / 180000D;
					break;
				case SmpteFrameRate.Smpte5994Drop:
					hours = framecount / 215784D;
					break;
				case SmpteFrameRate.Smpte5994NonDrop:
				case SmpteFrameRate.Smpte60:
					hours = framecount / 216000D;
					break;
				default:
					hours = framecount / 108000D;
					break;
			}

			return hours;
		}
	}

	/// <summary>
	/// Gets the value of the current TimeCode structure expressed in whole
	/// and fractional minutes.
	/// </summary>
	/// <returns>
	///  The total number of minutes represented by this instance.
	/// </returns>
	/// <value>The number of minutes of the TimeCode.</value>
	public double TotalMinutes
	{
		get
		{
			var framecount = AbsoluteTimeToFrames(_absoluteTime, _frameRate);

			double minutes;

			switch (_frameRate)
			{
				case SmpteFrameRate.Smpte2398:
				case SmpteFrameRate.Smpte24:
					minutes = framecount / 1400D;
					break;
				case SmpteFrameRate.Smpte25:
					minutes = framecount / 1500D;
					break;
				case SmpteFrameRate.Smpte2997Drop:
				case SmpteFrameRate.Smpte2997NonDrop:
				case SmpteFrameRate.Smpte30:
					minutes = framecount / 1800D;
					break;
				case SmpteFrameRate.Smpte50:
					minutes = framecount / 3000D;
					break;
				case SmpteFrameRate.Smpte5994Drop:
				case SmpteFrameRate.Smpte5994NonDrop:
				case SmpteFrameRate.Smpte60:
					minutes = framecount / 3600D;
					break;
				default:
					minutes = framecount / 1800D;
					break;
			}

			return minutes;
		}
	}

	/// <summary>
	/// Gets the value of the current TimeCode structure expressed in whole
	/// and fractional seconds. Not as Precise as the TotalSecondsPrecision.
	/// </summary>
	/// <returns>
	/// The total number of seconds represented by this instance.
	/// </returns>
	/// <value>The number of seconds of the TimeCode.</value>
	public double TotalSeconds
	{
		get
		{
			return Convert.ToDouble(System.Math.Round(_absoluteTime, 6));
		}
	}

	/// <summary>
	/// Gets the value of the current TimeCode structure expressed in whole
	/// and fractional seconds. This is returned as a <see cref="decimal"/> for greater precision.
	/// </summary>
	/// <returns>
	/// The total number of seconds in <see cref="decimal"/> precision represented by this instance.
	/// </returns>
	/// <value>The number of seconds of the TimeCode.</value>
	public decimal TotalSecondsPrecision
	{
		get
		{
			return _absoluteTime;
		}
	}

	/// <summary>
	/// Gets the value of the current TimeCode structure expressed in frames.
	/// </summary>
	/// <returns>
	///  The total number of frames represented by this instance.
	/// </returns>
	/// <value>The total frames of the current TimeCode.</value>
	public long TotalFrames
	{
		get
		{
			return AbsoluteTimeToFrames(_absoluteTime, _frameRate);
		}
	}

	/// <summary>
	/// Subtracts a specified TimeCode from another specified TimeCode.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>A TimeCode whose value is the result of the value of t1 minus the value of t2.
	/// </returns>
	/// <exception cref="System.OverflowException">The return value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.
	/// </exception>
	public static TimeCode operator -(TimeCode t1, TimeCode t2)
	{
		var t3 = new TimeCode(t1._absoluteTime - t2._absoluteTime, t1.FrameRate);

		if (t3.TotalSeconds < MinValue)
		{
			throw new OverflowException("MinValueSmpte12MOverflowException");
		}

		return t3;
	}

	/// <summary>
	/// Indicates whether two TimeCode instances are not equal.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>true if the values of t1 and t2 are not equal; otherwise, false.</returns>
	public static bool operator !=(TimeCode t1, TimeCode t2)
	{
		var timeCode1 = new TimeCode(t1._absoluteTime, SmpteFrameRate.Smpte30);
		var timeCode2 = new TimeCode(t2._absoluteTime, SmpteFrameRate.Smpte30);

		return Math.Abs(timeCode1.TotalSeconds - timeCode2.TotalSeconds) > (double)EPSILON;
	}

	/// <summary>
	/// Adds two specified TimeCode instances.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>A TimeCode whose value is the sum of the values of t1 and t2.</returns>
	/// <exception cref="System.OverflowException">
	/// The resulting TimeCode is less than TimeCode.MinValue or greater than TimeCode.MaxValue.
	/// </exception>
	public static TimeCode operator +(TimeCode t1, TimeCode t2)
	{
		var t3 = new TimeCode(t1._absoluteTime + t2._absoluteTime, t1.FrameRate);

		// decimal maxValue = MaxValue(t3.frameRate);
		// if (t3.TotalSecondsPrecision > maxValue && t3.TotalSeconds > (double)maxValue)
		// {
		//    throw new OverflowException(String.Format(CultureInfo.InvariantCulture, MaxValueSmpte12MOverflowException, t3.TotalSecondsPrecision, maxValue));
		// }
		return t3;
	}

	/// <summary>
	///  Indicates whether a specified TimeCode is less than another
	///  specified TimeCode.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns> 
	/// A true if the value of t1 is less than the value of t2; otherwise, false.
	/// </returns>
	public static bool operator <(TimeCode t1, TimeCode t2)
	{
		var timeCode1 = new TimeCode(t1._absoluteTime, SmpteFrameRate.Smpte30);
		var timeCode2 = new TimeCode(t2._absoluteTime, SmpteFrameRate.Smpte30);

		return timeCode1.TotalSeconds < timeCode2.TotalSeconds;
	}

	/// <summary>
	///  Indicates whether a specified TimeCode is less than or equal to another
	///  specified TimeCode.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>true if the value of t1 is less than or equal to the value of t2; otherwise, false.</returns>
	public static bool operator <=(TimeCode t1, TimeCode t2)
	{
		var timeCode1 = new TimeCode(t1._absoluteTime, SmpteFrameRate.Smpte30);
		var timeCode2 = new TimeCode(t2._absoluteTime, SmpteFrameRate.Smpte30);

		return timeCode1.TotalSeconds < timeCode2.TotalSeconds || (Math.Abs(timeCode1.TotalSeconds - timeCode2.TotalSeconds) < (double)EPSILON);
	}

	/// <summary>
	///  Indicates whether two TimeCode instances are equal.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>true if the values of t1 and t2 are equal; otherwise, false.</returns>
	public static bool operator ==(TimeCode t1, TimeCode t2)
	{
		var timeCode1 = new TimeCode(t1._absoluteTime, SmpteFrameRate.Smpte30);
		var timeCode2 = new TimeCode(t2._absoluteTime, SmpteFrameRate.Smpte30);

		return Math.Abs(timeCode1.TotalSeconds - timeCode2.TotalSeconds) < (double)EPSILON;
	}

	/// <summary>
	/// Indicates whether a specified TimeCode is greater than another specified
	///     TimeCode.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>true if the value of t1 is greater than the value of t2; otherwise, false.
	/// </returns>
	public static bool operator >(TimeCode t1, TimeCode t2)
	{
		var timeCode1 = new TimeCode(t1._absoluteTime, SmpteFrameRate.Smpte30);
		var timeCode2 = new TimeCode(t2._absoluteTime, SmpteFrameRate.Smpte30);

		return timeCode1.TotalSeconds > timeCode2.TotalSeconds;
	}

	/// <summary>
	/// Indicates whether a specified TimeCode is greater than or equal to
	///     another specified TimeCode.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>
	/// A true if the value of t1 is greater than or equal to the value of t2; otherwise,
	///    false.
	/// </returns>
	public static bool operator >=(TimeCode t1, TimeCode t2)
	{
		var timeCode1 = new TimeCode(t1._absoluteTime, SmpteFrameRate.Smpte30);
		var timeCode2 = new TimeCode(t2._absoluteTime, SmpteFrameRate.Smpte30);

		return timeCode1.TotalSeconds > timeCode2.TotalSeconds || (Math.Abs(timeCode1.TotalSeconds - timeCode2.TotalSeconds) < (double)EPSILON);
	}

	/// <summary>
	/// Compares two TimeCode values and returns an integer that indicates their relationship.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>
	/// Value Condition -1 t1 is less than t2, 0 t1 is equal to t2, 1 t1 is greater than t2.
	/// </returns>
	public static int Compare(TimeCode t1, TimeCode t2)
	{
		if (t1 < t2)
		{
			return -1;
		}

		return t1 == t2 ? 0 : 1;
	}

	/// <summary>
	///  Returns a value indicating whether two specified instances of TimeCode
	///  are equal.
	/// </summary>
	/// <param name="t1">The first TimeCode.</param>
	/// <param name="t2">The second TimeCode.</param>
	/// <returns>true if the values of t1 and t2 are equal; otherwise, false.</returns>
	public static bool Equals(TimeCode t1, TimeCode t2)
	{
		return t1 == t2;
	}

	/// <summary>
	///  Returns a TimeCode that represents a specified number of days, where
	///  the specification is accurate to the nearest millisecond.
	/// </summary>
	/// <param name="value">A number of days accurate to the nearest millisecond.</param>
	/// <param name="rate">The desired framerate for this instance.</param>
	/// <returns> A TimeCode that represents value.</returns>
	/// <exception cref="System.OverflowException">
	/// value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.
	/// -or-value is System.Double.PositiveInfinity.-or-value is System.Double.NegativeInfinity.
	/// </exception>
	/// <exception cref="System.FormatException">
	/// value is equal to System.Double.NaN.
	/// </exception>
	public static TimeCode FromDays(double value, SmpteFrameRate rate)
	{
		var absoluteTime = value * TicksPerDayAbsoluteTime;
		return new TimeCode(absoluteTime, rate);
	}

	/// <summary>
	///  Returns a TimeCode that represents a specified number of hours, where
	///  the specification is accurate to the nearest millisecond.
	/// </summary>
	/// <param name="value">A number of hours accurate to the nearest millisecond.</param>
	/// <param name="rate">The desired framerate for this instance.</param>
	/// <returns> A TimeCode that represents value.</returns>
	/// <exception cref="System.OverflowException">
	/// value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.
	/// -or-value is System.Double.PositiveInfinity.-or-value is System.Double.NegativeInfinity.
	/// </exception>
	/// <exception cref="System.FormatException">
	/// value is equal to System.Double.NaN.
	/// </exception>
	public static TimeCode FromHours(double value, SmpteFrameRate rate)
	{
		var absoluteTime = value * TicksPerHourAbsoluteTime;
		return new TimeCode(absoluteTime, rate);
	}

	/// <summary>
	///   Returns a TimeCode that represents a specified number of minutes,
	///   where the specification is accurate to the nearest millisecond.
	/// </summary>
	/// <param name="value">A number of minutes, accurate to the nearest millisecond.</param>
	/// <param name="rate">The <see cref="SmpteFrameRate"/> to use for the calculation.</param>
	/// <returns>A TimeCode that represents value.</returns>
	/// <exception cref="System.OverflowException">
	/// value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.-or-value
	/// is System.Double.PositiveInfinity.-or-value is System.Double.NegativeInfinity.
	/// </exception>
	/// <exception cref="System.ArgumentException">
	/// value is equal to System.Double.NaN.
	/// </exception>
	public static TimeCode FromMinutes(double value, SmpteFrameRate rate)
	{
		var absoluteTime = value * TicksPerMinuteAbsoluteTime;
		return new TimeCode(absoluteTime, rate);
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified number of seconds,
	/// where the specification is accurate to the nearest millisecond.
	/// </summary>
	/// <param name="value">A number of seconds, accurate to the nearest millisecond.</param>
	/// /// <param name="rate">The framerate of the Timecode.</param>
	/// <returns>A TimeCode that represents value.</returns>
	/// <exception cref="System.OverflowException">
	/// value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.-or-value
	///  is System.Double.PositiveInfinity.-or-value is System.Double.NegativeInfinity.
	/// </exception>
	/// <exception cref="System.ArgumentException">
	/// value is equal to System.Double.NaN.
	/// </exception>
	public static TimeCode FromSeconds(double value, SmpteFrameRate rate)
	{
		return new TimeCode(value, rate);
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified number of seconds,
	/// where the specification is accurate to the nearest millisecond.
	/// </summary>
	/// <param name="value">A number of seconds in <see cref="decimal"/> precision, accurate to the nearest millisecond.</param>
	/// /// <param name="rate">The framerate of the Timecode.</param>
	/// <returns>A TimeCode that represents value.</returns>
	/// <exception cref="System.OverflowException">
	/// value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.-or-value
	///  is System.Double.PositiveInfinity.-or-value is System.Double.NegativeInfinity.
	/// </exception>
	/// <exception cref="System.ArgumentException">
	/// value is equal to System.Double.NaN.
	/// </exception>
	public static TimeCode FromSeconds(decimal value, SmpteFrameRate rate)
	{
		return new TimeCode(value, rate);
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified number of frames.
	/// </summary>
	/// <param name="value">A number of frames.</param>
	/// <param name="rate">The framerate of the Timecode.</param>
	/// <returns>A TimeCode that represents value.</returns>
	/// <exception cref="System.OverflowException">
	///  value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.-or-value
	///    is System.Double.PositiveInfinity.-or-value is System.Double.NegativeInfinity.
	/// </exception>
	/// <exception cref="System.ArgumentException">
	/// value is equal to System.Double.NaN.
	/// </exception>
	public static TimeCode FromFrames(long value, SmpteFrameRate rate)
	{
		var abs = FramesToAbsoluteTime(value, rate);
		return new TimeCode(abs, rate);
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified time, where the specification
	///  is in units of ticks.
	/// </summary>
	/// <param name="ticks"> A number of ticks that represent a time.</param>
	/// <param name="rate">The Smpte framerate.</param>
	/// <returns>A TimeCode with a value of value.</returns>
	public static TimeCode FromTicks(long ticks, SmpteFrameRate rate)
	{
		var absoluteTime = Math.Pow(10, -7) * ticks;
		return new TimeCode(absoluteTime, rate);
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified time, where the specification is 
	/// in units of absolute time.
	/// </summary>
	/// <param name="value">The absolute time in 100 nanosecond units.</param>
	/// <param name="rate">The SMPTE framerate.</param>
	/// <returns>A TimeCode.</returns>
	public static TimeCode FromAbsoluteTime(double value, SmpteFrameRate rate)
	{
		return new TimeCode(value, rate);
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified time, where the specification is 
	/// in units of absolute time.
	/// </summary>
	/// <param name="value">The <see cref="TimeSpan"/> object.</param>
	/// <param name="rate">The SMPTE framerate.</param>
	/// <returns>A TimeCode.</returns>
	public static TimeCode FromTimeSpan(TimeSpan value, SmpteFrameRate rate)
	{
		return new TimeCode(value.TotalSeconds, rate);
	}

	/// <summary>
	/// Validates that the string provided is in the correct format for SMPTE 12M time code.
	/// </summary>
	/// <param name="timeCode">String that is the time code.</param>
	/// <returns>True if this is a valid SMPTE 12M time code string.</returns>
	public static bool ValidateSmpte12MTimecode(string timeCode)
	{
		if (!ValidateTimecode.IsMatch(timeCode))
		{
			return false;
		}

		var times = timeCode.Split(':', ';');

		var index = -1;
		var days = 0;

		if (times.Length > 4)
		{
			days = Int32.Parse(times[++index]);
		}

		var hours = Int32.Parse(times[++index]);
		var minutes = Int32.Parse(times[++index]);
		var seconds = Int32.Parse(times[++index]);
		var frames = Int32.Parse(times[++index]);

		return (days >= 0) && (hours < 24) && (minutes < 60) && (seconds < 60) && (frames < 60);
	}

	/// <summary>
	/// Validates that the hexadecimal formatted integer provided is in the correct format for SMPTE 12M time code
	/// Time code is stored so that the hexadecimal value is read as if it were an integer value. 
	/// That is, the time code value 0x01133512 does not represent integer 18035986, rather it specifies 1 hour, 13 minutes, 35 seconds, and 12 frames.      
	/// </summary>
	/// <param name="windowsMediaTimeCode">Integer that is the time code stored in hexadecimal format.</param>
	/// <returns>True if this is a valid SMPTE 12M time code string.</returns>
	public static bool ValidateSmpte12MTimecode(int windowsMediaTimeCode)
	{
		var timeCodeBytes = BitConverter.GetBytes(windowsMediaTimeCode);
		var timeCode = string.Format("{3:x2}:{2:x2}:{1:x2}:{0:x2}", timeCodeBytes[0], timeCodeBytes[1], timeCodeBytes[2], timeCodeBytes[3]);
		var times = timeCode.Split(':', ';');

		var hours = Int32.Parse(times[0]);
		var minutes = Int32.Parse(times[1]);
		var seconds = Int32.Parse(times[2]);
		var frames = Int32.Parse(times[3]);

		return (hours < 24) && (minutes < 60) && (seconds < 60) && (frames < 60);
	}

	/// <summary>
	/// Parses a framerate value as double and converts it to a member of the SmpteFrameRate enumeration.
	/// </summary>
	/// <param name="rate">Double value of the framerate.</param>
	/// <returns>A SmpteFrameRate enumeration value that matches the incoming rates.</returns>
	public static SmpteFrameRate ParseFramerate(double rate)
	{
		var rateRounded = (int)Math.Floor(rate);

		switch (rateRounded)
		{
			case 23: return SmpteFrameRate.Smpte2398;
			case 24: return SmpteFrameRate.Smpte24;
			case 25: return SmpteFrameRate.Smpte25;
			case 29: return SmpteFrameRate.Smpte2997NonDrop;
			case 30: return SmpteFrameRate.Smpte30;
			case 50: return SmpteFrameRate.Smpte50;
			case 59: return SmpteFrameRate.Smpte5994NonDrop;
			case 60: return SmpteFrameRate.Smpte60;
		}

		return SmpteFrameRate.Unknown;
	}

	/// <summary>
	/// Adds the specified TimeCode to this instance.
	/// </summary>
	/// <param name="ts">A TimeCode.</param>
	/// <returns>A TimeCode that represents the value of this instance plus the value of ts.
	/// </returns>
	/// <exception cref="System.OverflowException">
	/// The resulting TimeCode is less than TimeCode.MinValue or greater than TimeCode.MaxValue.
	/// </exception>
	public TimeCode Add(TimeCode ts)
	{
		return this + ts;
	}

	/// <summary>
	///  Compares this instance to a specified object and returns an indication of
	///   their relative values.
	/// </summary>
	/// <param name="value">An object to compare, or null.</param>
	/// <returns>
	///  Value Condition -1 The value of this instance is less than the value of value.
	///    0 The value of this instance is equal to the value of value. 1 The value
	///    of this instance is greater than the value of value.-or- value is null.
	/// </returns>
	/// <exception cref="System.ArgumentException">
	///  value is not a TimeCode.
	/// </exception>
	public int CompareTo(object value)
	{
		if (!(value is TimeCode))
		{
			throw new ArgumentException("Smpte12MOutOfRange");
		}

		var t1 = (TimeCode)value;

		if (this < t1)
		{
			return -1;
		}

		return this == t1 ? 0 : 1;
	}

	/// <summary>
	/// Compares this instance to a specified TimeCode object and returns
	/// an indication of their relative values.
	/// </summary>
	/// <param name="value"> A TimeCode object to compare to this instance.</param>
	/// <returns>
	/// A signed number indicating the relative values of this instance and value.Value
	/// Description A negative integer This instance is less than value. Zero This
	/// instance is equal to value. A positive integer This instance is greater than
	/// value.
	/// </returns>
	public int CompareTo(TimeCode value)
	{
		if (this < value)
		{
			return -1;
		}

		return this == value ? 0 : 1;
	}

	/// <summary>
	///  Returns a value indicating whether this instance is equal to a specified
	///  object.
	/// </summary>
	/// <param name="value">An object to compare with this instance.</param>
	/// <returns>
	/// A true if value is a TimeCode object that represents the same time interval
	/// as the current TimeCode structure; otherwise, false.
	/// </returns>
	public override bool Equals(object value)
	{
		return this == (TimeCode)value;
	}

	/// <summary>
	/// Returns a value indicating whether this instance is equal to a specified
	///     TimeCode object.
	/// </summary>
	/// <param name="obj">An TimeCode object to compare with this instance.</param>
	/// <returns>true if obj represents the same time interval as this instance; otherwise, false.
	/// </returns>
	public bool Equals(TimeCode obj)
	{
		return this == obj;
	}

	/// <summary>
	/// Returns a hash code for this instance.
	/// </summary>
	/// <returns> A 32-bit signed integer hash code.</returns>
	public override int GetHashCode()
	{
		return base.GetHashCode();
	}

	/// <summary>
	/// Subtracts the specified TimeCode from this instance.
	/// </summary>
	/// <param name="ts">A TimeCode.</param>
	/// <returns>A TimeCode whose value is the result of the value of this instance minus the value of ts.</returns>
	/// <exception cref="OverflowException">The return value is less than TimeCode.MinValue or greater than TimeCode.MaxValue.</exception>
	public TimeCode Subtract(TimeCode ts)
	{
		return this - ts;
	}

	/// <summary>
	/// Returns the SMPTE 12M string representation of the value of this instance.
	/// </summary>
	/// <returns>
	/// A string that represents the value of this instance. The return value is
	///     of the form: hh:mm:ss:ff for non-drop frame and hh:mm:ss;ff for drop frame code
	///     with "hh" hours, ranging from 0 to 23, "mm" minutes
	///     ranging from 0 to 59, "ss" seconds ranging from 0 to 59, and  "ff"  based on the 
	///     chosen framerate to be used by the time code instance.
	/// </returns>
	public override string ToString()
	{
		return AbsoluteTimeToSmpte12M(_absoluteTime, _frameRate);
	}

	/// <summary>
	/// Outputs a string of the current time code in the requested framerate.
	/// </summary>
	/// <param name="rate">The SmpteFrameRate required for the string output.</param>
	/// <returns>SMPTE 12M formatted time code string converted to the requested framerate.</returns>
	public string ToString(SmpteFrameRate rate)
	{
		return AbsoluteTimeToSmpte12M(_absoluteTime, rate);
	}

	/// <summary>
	/// Converts a SMPTE timecode to absolute time.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <param name="rate">The <see cref="SmpteFrameRate"/> of the timecode.</param>
	/// <returns>A <see cref="decimal"/> with the absolute time.</returns>
	private static decimal Smpte12MToAbsoluteTime(string timeCode, SmpteFrameRate rate)
	{
		decimal absoluteTime = 0;

		switch (rate)
		{
			case SmpteFrameRate.Smpte2398:
				absoluteTime = Smpte12M2398ToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte24:
				absoluteTime = Smpte12M24ToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte25:
				absoluteTime = Smpte12M25ToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte2997Drop:
				absoluteTime = Smpte12M2997DropToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte2997NonDrop:
				absoluteTime = Smpte12M2997NonDropToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte30:
				absoluteTime = Smpte12M30ToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte50:
				absoluteTime = Smpte12M50ToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte5994Drop:
				absoluteTime = Smpte12M5994DropToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte5994NonDrop:
				absoluteTime = Smpte12M5994NonDropToAbsoluteTime(timeCode);
				break;
			case SmpteFrameRate.Smpte60:
				absoluteTime = Smpte12M60ToAbsoluteTime(timeCode);
				break;
		}

		return absoluteTime;
	}

	/// <summary>
	/// Parses a timecode string for the different parts of the timecode.
	/// </summary>
	/// <param name="timeCode">The source timecode to parse.</param>
	/// <param name="days">The Days section from the timecode.</param>
	/// <param name="hours">The Hours section from the timecode.</param>
	/// <param name="minutes">The Minutes section from the timecode.</param>
	/// <param name="seconds">The Seconds section from the timecode.</param>
	/// <param name="frames">The frames section from the timecode.</param>
	private static void ParseTimecodeString(string timeCode, out int days, out int hours, out int minutes, out int seconds, out int frames)
	{
		if (!ValidateTimecode.IsMatch(timeCode))
		{
			throw new FormatException("Smpte12MBadFormat");
		}

		var times = timeCode.Split(':', ';');

		var index = -1;

		days = 0;

		if (times.Length > 4)
		{
			days = Int32.Parse(times[++index]);
		}

		hours = Int32.Parse(times[++index]);
		minutes = Int32.Parse(times[++index]);
		seconds = Int32.Parse(times[++index]);
		frames = Int32.Parse(times[++index]);

		if ((days < 0) || (hours >= 24) || (minutes >= 60) || (seconds >= 60) || (frames >= 60))
		{
			throw new FormatException("Smpte12MOutOfRange");
		}
	}

	/// <summary>
	/// Generates a string representation of the timecode.
	/// </summary>
	/// <param name="days">The Days section from the timecode.</param>
	/// <param name="hours">The Hours section from the timecode.</param>
	/// <param name="minutes">The Minutes section from the timecode.</param>
	/// <param name="seconds">The Seconds section from the timecode.</param>
	/// <param name="frames">The frames section from the timecode.</param>
	/// <param name="dropFrame">Indicates whether the timecode is drop frame or not.</param>
	/// <returns>The timecode in string format.</returns>
	private static string FormatTimeCodeString(int days, int hours, int minutes, int seconds, int frames, bool dropFrame)
	{
		var framesSeparator = ":";
		if (dropFrame)
		{
			framesSeparator = ";";
		}

		return days > 0 ? string.Format("{0:D2}:{1:D2}:{2:D2}:{3:D2}{5}{4:D2}", days, hours, minutes, seconds, frames, framesSeparator) : string.Format("{0:D2}:{1:D2}:{2:D2}{4}{3:D2}", hours, minutes, seconds, frames, framesSeparator);
	}

	/// <summary>
	/// Generates a string representation of the timecode.
	/// </summary>
	/// <param name="hours">The Hours section from the timecode.</param>
	/// <param name="minutes">The Minutes section from the timecode.</param>
	/// <param name="seconds">The Seconds section from the timecode.</param>
	/// <param name="frames">The frames section from the timecode.</param>
	/// <param name="dropFrame">Indicates whether the timecode is drop frame or not.</param>
	/// <returns>The timecode in string format.</returns>
	private static string FormatTimeCodeString(int hours, int minutes, int seconds, int frames, bool dropFrame)
	{
		var framesSeparator = ":";
		if (dropFrame)
		{
			framesSeparator = ";";
		}

		return string.Format("{0:D2}:{1:D2}:{2:D2}{4}{3:D2}", hours, minutes, seconds, frames, framesSeparator);
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 23.98.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M2398ToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 24)
		{
			throw new FormatException("Smpte12M_2398_BadFormat");
		}

		return (1001 / 24000M) * (frames + (24 * seconds) + (1440 * minutes) + (86400 * hours) + (2073600 * days));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 24.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M24ToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 24)
		{
			throw new FormatException("Smpte12M_24_BadFormat");
		}

		return (1 / 24M) * (frames + (24 * seconds) + (1440 * minutes) + (86400 * hours) + (2073600 * days));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 25.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M25ToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 25)
		{
			throw new FormatException("Smpte12M_25_BadFormat");
		}

		return (1 / 25M) * (frames + (25 * seconds) + (1500 * minutes) + (90000 * hours) + (2160000 * days));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 29.97 Drop frame.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M2997DropToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 30)
		{
			throw new FormatException("Smpte12M_2997_Drop_BadFormat");
		}

		return (1001 / 30000M) * (frames + (30 * seconds) + (1798 * minutes) + ((2 * (minutes / 10)) + (107892 * hours) + (2589408 * days)));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 29.97 Non Drop.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M2997NonDropToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 30)
		{
			throw new FormatException("Smpte12M_2997_NonDrop_BadFormat");
		}

		return Math.Round((1001 / 30000M) * (frames + (30 * seconds) + (1800 * minutes) + (108000 * hours) + (2592000 * days)), 8);
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 30.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="double"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M30ToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 30)
		{
			throw new FormatException("Smpte12M_30_BadFormat");
		}

		return (1 / 30M) * (frames + (30 * seconds) + (1800 * minutes) + (108000 * hours) + (2592000 * days));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 50.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M50ToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 50)
		{
			throw new FormatException("Smpte12M_50_BadFormat");
		}

		return (1 / 50M) * (frames + (50 * seconds) + (3000 * minutes) + (180000 * hours) + (4320000 * days));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 59.94 Drop frame.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M5994DropToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 60)
		{
			throw new FormatException("Smpte12M_5994_Drop_BadFormat");
		}

		return (1001 / 60000M) * (frames + (60 * seconds) + (3596 * minutes) + ((4 * (minutes / 10)) + (215784 * hours) + (5178816 * days)));
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 59.94 Non Drop.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="decimal"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M5994NonDropToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 60)
		{
			throw new FormatException("Smpte12M_5994_NonDrop_BadFormat");
		}

		return Math.Round((1001 / 60000M) * (frames + (60 * seconds) + (3600 * minutes) + (216000 * hours) + (5184000 * days)), 25);
	}

	/// <summary>
	/// Converts to Absolute time from SMPTE 12M 60.
	/// </summary>
	/// <param name="timeCode">The timecode to parse.</param>
	/// <returns>A <see cref="double"/> that contains the absolute duration.</returns>
	private static decimal Smpte12M60ToAbsoluteTime(string timeCode)
	{
		int days, hours, minutes, seconds, frames;

		ParseTimecodeString(timeCode, out days, out hours, out minutes, out seconds, out frames);

		if (frames >= 60)
		{
			throw new FormatException("Smpte12M_60_BadFormat");
		}

		return (1 / 60M) * (frames + (60 * seconds) + (3600 * minutes) + (216000 * hours) + (5184000 * days));
	}

	/// <summary>
	/// Converts to SMPTE 12M.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <param name="rate">The SMPTE frame rate.</param>
	/// <returns>A string in SMPTE 12M format.</returns>
	private static string AbsoluteTimeToSmpte12M(decimal absoluteTime, SmpteFrameRate rate)
	{
		var timeCode = String.Empty;

		if (rate == SmpteFrameRate.Smpte2398)
		{
			timeCode = AbsoluteTimeToSmpte12M2398Fps(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte24)
		{
			timeCode = AbsoluteTimeToSmpte12M24Fps(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte25)
		{
			timeCode = AbsoluteTimeToSmpte12M25Fps(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte2997Drop)
		{
			timeCode = AbsoluteTimeToSmpte12M2997Drop(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte2997NonDrop)
		{
			timeCode = AbsoluteTimeToSmpte12M2997NonDrop(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte30)
		{
			timeCode = AbsoluteTimeToSmpte12M30Fps(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte50)
		{
			timeCode = AbsoluteTimeToSmpte12M50Fps(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte5994Drop)
		{
			timeCode = AbsoluteTimeToSmpte12M5994Drop(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte5994NonDrop)
		{
			timeCode = AbsoluteTimeToSmpte12M5994NonDrop(absoluteTime);
		}
		else if (rate == SmpteFrameRate.Smpte60)
		{
			timeCode = AbsoluteTimeToSmpte12M60Fps(absoluteTime);
		}

		return timeCode;
	}

	/// <summary>
	/// Returns the number of frames.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to use for parsing from.</param>
	/// <param name="rate">The SMPTE frame rate to use for the conversion.</param>
	/// <returns>A <see cref="long"/> with the number of frames.</returns>
	private static long AbsoluteTimeToFrames(decimal absoluteTime, SmpteFrameRate rate)
	{
		if (rate == SmpteFrameRate.Smpte2398)
		{
			return Convert.ToInt64(decimal.Floor(System.Math.Round((decimal)(24 * (float)(1000 / 1001M) * (float)(absoluteTime + EPSILON)), 25)));
		}

		if (rate == SmpteFrameRate.Smpte24)
		{
			return Convert.ToInt64(decimal.Floor((decimal)(24 * (float)absoluteTime)));
		}

		if (rate == SmpteFrameRate.Smpte25)
		{
			return Convert.ToInt64(decimal.Floor((decimal)(25 * (float)absoluteTime)));
		}

		if (rate == SmpteFrameRate.Smpte2997Drop)
		{
			return Convert.ToInt64(decimal.Floor(System.Math.Round((decimal)(30 * (float)(1000 / 1001M) * (float)(absoluteTime + EPSILON)), 25)));
		}

		if (rate == SmpteFrameRate.Smpte2997NonDrop)
		{
			return Convert.ToInt64(decimal.Floor(System.Math.Round((decimal)(30 * (float)(1000 / 1001M) * (float)(absoluteTime + EPSILON)), 25)));
		}

		if (rate == SmpteFrameRate.Smpte30)
		{
			return Convert.ToInt64(30 * (float)absoluteTime);
		}

		if (rate == SmpteFrameRate.Smpte50)
		{
			return Convert.ToInt64(decimal.Floor((decimal)(50 * (float)absoluteTime)));
		}

		if (rate == SmpteFrameRate.Smpte5994Drop)
		{
			return Convert.ToInt64(decimal.Floor(System.Math.Round((decimal)(60 * (double)(1000 / 1001M) * (double)(absoluteTime + EPSILON)), 25)));
		}

		if (rate == SmpteFrameRate.Smpte5994NonDrop)
		{
			return Convert.ToInt64(decimal.Floor(System.Math.Round((decimal)(60 * (double)(1000 / 1001M) * (double)(absoluteTime + EPSILON)), 25)));
		}

		if (rate == SmpteFrameRate.Smpte60)
		{
			return Convert.ToInt64(60 * (float)absoluteTime);
		}

		return Convert.ToInt64(decimal.Floor(30 * absoluteTime));
	}

	/// <summary>
	/// Returns the absolute time.
	/// </summary>
	/// <param name="frames">The number of frames.</param>
	/// <param name="rate">The SMPTE frame rate to use for the conversion.</param>
	/// <returns>The absolute time.</returns>
	private static double FramesToAbsoluteTime(long frames, SmpteFrameRate rate)
	{
		decimal absoluteTimeInDecimal;

		if (rate == SmpteFrameRate.Smpte2398)
		{
			absoluteTimeInDecimal = frames / 24M / System.Math.Round((1000 / 1001M), 11);
		}
		else if (rate == SmpteFrameRate.Smpte24)
		{
			absoluteTimeInDecimal = frames / 24M;
		}
		else if (rate == SmpteFrameRate.Smpte25)
		{
			absoluteTimeInDecimal = frames / 25M;
		}
		else if (rate == SmpteFrameRate.Smpte2997Drop || rate == SmpteFrameRate.Smpte2997NonDrop)
		{
			absoluteTimeInDecimal = frames / 30M / System.Math.Round((1000 / 1001M), 11);
		}
		else if (rate == SmpteFrameRate.Smpte30)
		{
			absoluteTimeInDecimal = frames / 30M;
		}
		else if (rate == SmpteFrameRate.Smpte50)
		{
			absoluteTimeInDecimal = frames / 50M;
		}
		else if (rate == SmpteFrameRate.Smpte5994Drop || rate == SmpteFrameRate.Smpte5994NonDrop)
		{
			absoluteTimeInDecimal = frames / 60M / System.Math.Round((1000 / 1001M), 11);
		}
		else if (rate == SmpteFrameRate.Smpte60)
		{
			absoluteTimeInDecimal = frames / 60M;
		}
		else
		{
			absoluteTimeInDecimal = frames / 30M;
		}

		return Convert.ToDouble(absoluteTimeInDecimal);
	}

	/// <summary>
	/// Returns the SMPTE 12M 23.98 timecode.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M2398Fps(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte2398);

		var days = Convert.ToInt32((framecount / 86400) / 24);
		var hours = Convert.ToInt32((framecount / 86400) % 24);
		var minutes = Convert.ToInt32(((framecount - (86400 * hours)) / 1440) % 60);
		var seconds = Convert.ToInt32(((framecount - (1440 * minutes) - (86400 * hours)) / 24) % 3600);
		var frames = Convert.ToInt32((framecount - (24 * seconds) - (1440 * minutes) - (86400 * hours)) % 24);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 24fps.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M24Fps(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte24);

		var days = Convert.ToInt32((framecount / 86400) / 24);
		var hours = Convert.ToInt32((framecount / 86400) % 24);
		var minutes = Convert.ToInt32(((framecount - (86400 * hours)) / 1440) % 60);
		var seconds = Convert.ToInt32(((framecount - (1440 * minutes) - (86400 * hours)) / 24) % 3600);
		var frames = Convert.ToInt32((framecount - (24 * seconds) - (1440 * minutes) - (86400 * hours)) % 24);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 25fps.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M25Fps(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte25);

		var days = Convert.ToInt32((framecount / 90000) / 24);
		var hours = Convert.ToInt32((framecount / 90000) % 24);
		var minutes = Convert.ToInt32(((framecount - (90000 * hours)) / 1500) % 60);
		var seconds = Convert.ToInt32(((framecount - (1500 * minutes) - (90000 * hours)) / 25) % 3600);
		var frames = Convert.ToInt32((framecount - (25 * seconds) - (1500 * minutes) - (90000 * hours)) % 25);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 29.97fps Drop.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M2997Drop(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte2997Drop);
		var hours = (int)((framecount / 107892) % 24);
		var minutes = Convert.ToInt32((framecount + (2 * ((int)((framecount - (107892 * hours)) / 1800))) - (2 * ((int)((framecount - (107892 * hours)) / 18000))) - (107892 * hours)) / 1800);
		var seconds = Convert.ToInt32((framecount - (1798 * minutes) - (2 * ((int)(minutes / 10D))) - (107892 * hours)) / 30);
		var frames = Convert.ToInt32(framecount - (30 * seconds) - (1798 * minutes) - (2 * ((int)(minutes / 10D))) - (107892 * hours));

		return FormatTimeCodeString(hours, minutes, seconds, frames, true);
	}

	/// <summary>
	/// Converts to SMPTE 12M 29.97fps Non Drop.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M2997NonDrop(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte2997NonDrop);

		var days = Convert.ToInt32((framecount / 108000) / 24);
		var hours = Convert.ToInt32((framecount / 108000) % 24);
		var minutes = Convert.ToInt32(((framecount - (108000 * hours)) / 1800) % 60);
		var seconds = Convert.ToInt32(((framecount - (1800 * minutes) - (108000 * hours)) / 30) % 3600);
		var frames = Convert.ToInt32((framecount - (30 * seconds) - (1800 * minutes) - (108000 * hours)) % 30);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 30fps.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M30Fps(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte30);

		var days = Convert.ToInt32((framecount / 108000) / 24);
		var hours = Convert.ToInt32((framecount / 108000) % 24);
		var minutes = Convert.ToInt32(((framecount - (108000 * hours)) / 1800) % 60);
		var seconds = Convert.ToInt32(((framecount - (1800 * minutes) - (108000 * hours)) / 30) % 3600);
		var frames = Convert.ToInt32((framecount - (30 * seconds) - (1800 * minutes) - (108000 * hours)) % 30);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 50fps.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M50Fps(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte50);

		var days = Convert.ToInt32((framecount / 180000) / 24);
		var hours = Convert.ToInt32((framecount / 180000) % 24);
		var minutes = Convert.ToInt32(((framecount - (180000 * hours)) / 3000) % 60);
		var seconds = Convert.ToInt32(((framecount - (3000 * minutes) - (180000 * hours)) / 50) % 3600);
		var frames = Convert.ToInt32((framecount - (50 * seconds) - (3000 * minutes) - (180000 * hours)) % 50);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 29.97fps Drop.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M5994Drop(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte5994Drop);
		var hours = (int)((framecount / 215784) % 24);
		var minutes = Convert.ToInt32((framecount + (4 * ((int)((framecount - (215784 * hours)) / 3600))) - (4 * ((int)((framecount - (215784 * hours)) / 3600))) - (215784 * hours)) / 3600);
		var seconds = Convert.ToInt32((framecount - (3596 * minutes) - (4 * ((int)(minutes / 10D))) - (215784 * hours)) / 60);
		var frames = Convert.ToInt32(framecount - (60 * seconds) - (3596 * minutes) - (4 * ((int)(minutes / 10D))) - (215784 * hours));

		return FormatTimeCodeString(hours, minutes, seconds, frames, true);
	}

	/// <summary>
	/// Converts to SMPTE 12M 29.97fps Non Drop.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M5994NonDrop(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte5994NonDrop);

		var days = Convert.ToInt32((framecount / 216000) / 24);
		var hours = Convert.ToInt32((framecount / 216000) % 24);
		var minutes = Convert.ToInt32(((framecount - (216000 * hours)) / 3600) % 60);
		var seconds = Convert.ToInt32(((framecount - (3600 * minutes) - (216000 * hours)) / 60) % 3600);
		var frames = Convert.ToInt32((framecount - (60 * seconds) - (3600 * minutes) - (216000 * hours)) % 60);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 60fps.
	/// </summary>
	/// <param name="absoluteTime">The absolute time to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string AbsoluteTimeToSmpte12M60Fps(decimal absoluteTime)
	{
		var framecount = AbsoluteTimeToFrames(absoluteTime, SmpteFrameRate.Smpte60);

		var days = Convert.ToInt32((framecount / 216000) / 24);
		var hours = Convert.ToInt32((framecount / 216000) % 24);
		var minutes = Convert.ToInt32(((framecount - (216000 * hours)) / 3600) % 60);
		var seconds = Convert.ToInt32(((framecount - (3600 * minutes) - (216000 * hours)) / 60) % 3600);
		var frames = Convert.ToInt32((framecount - (60 * seconds) - (3600 * minutes) - (216000 * hours)) % 60);

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	#region CODE NOT USED AND NOT MAINTAINED
	/* THIS CODE IS NOT USED AND LOW PROBABILITY THAT IS GOING TO BE USED IN THE FUTURE SO NOT MAINTAINING

	/// <summary>
	/// Returns the value of this instance in 27 Mhz ticks.
	/// </summary>
	/// <returns>A long value that is in 27 Mhz ticks.</returns>
	public long ToTicks27Mhz()
	{
		return AbsoluteTimeToTicks27Mhz(_absoluteTime);
	}

	/// <summary>
	/// Returns the value of this instance in MPEG 2 PCR time base (PcrTb) format.
	/// </summary>
	/// <returns>A long value that is in PcrTb.</returns>
	public long ToTicksPcrTb()
	{
		return AbsoluteTimeToTicksPcrTb(_absoluteTime);
	}

	/// <summary>
	///     Converts the provided absolute time to PCRTb.
	/// </summary>
	/// <param name="absoluteTime">Absolute time to be converted.</param>
	/// <returns>The number of PCRTb ticks.</returns>
	private static long AbsoluteTimeToTicksPcrTb(decimal absoluteTime)
	{
		return Convert.ToInt64(((absoluteTime * 90000) % Convert.ToDecimal(Math.Pow(2, 33))));
	}

	/// <summary>
	///     Converts the specified absolute time to 27 mhz ticks.
	/// </summary>
	/// <param name="absoluteTime">Absolute time to be converted.</param>
	/// <returns>THe number of 27Mhz ticks.</returns>
	private static long AbsoluteTimeToTicks27Mhz(decimal absoluteTime)
	{
		return AbsoluteTimeToTicksPcrTb(absoluteTime) * 300;
	}

	/// <summary>
	/// Parses a timecode string for the different parts of the timecode.
	/// </summary>
	/// <param name="timeCode">The source timecode to parse.</param>
	/// <param name="hours">The Hours section from the timecode.</param>
	/// <param name="minutes">The Minutes section from the timecode.</param>
	/// <param name="seconds">The Seconds section from the timecode.</param>
	/// <param name="frames">The frames section from the timecode.</param>
	private static void ParseTimecodeString(string timeCode, out int hours, out int minutes, out int seconds, out int frames)
	{
		if (!ValidateTimecode.IsMatch(timeCode))
		{
			throw new FormatException("Smpte12MBadFormat");
		}

		var times = timeCode.Split(':', ';');

		hours = Int32.Parse(times[0]);
		minutes = Int32.Parse(times[1]);
		seconds = Int32.Parse(times[2]);
		frames = Int32.Parse(times[3]);

		if ((hours >= 24) || (minutes >= 60) || (seconds >= 60) || (frames >= 60))
		{
			throw new FormatException("Smpte12MOutOfRange");
		}
	}

	/// <summary>
	/// Returns a TimeCode that represents a specified time, where the specification is 
	/// in units of 27 Mhz clock ticks.
	/// </summary>
	/// <param name="value">A number of ticks in 27 Mhz clock format.</param>
	/// <param name="rate">A Smpte framerate.</param>
	/// <returns>A TimeCode.</returns>
	public static TimeCode FromTicks27Mhz(long value, SmpteFrameRate rate)
	{
		var absoluteTime = Ticks27MhzToAbsoluteTime(value);

		return new TimeCode(absoluteTime, rate);
	}

	/// <summary>
	/// Initializes a new instance of the TimeCode struct a long value that represents a value of a 27 Mhz clock.
	/// </summary>
	/// <param name="ticks27Mhz">The long value in 27 Mhz clock ticks.</param>
	/// <param name="rate">The SMPTE frame rate to use for this instance.</param>
	public TimeCode(long ticks27Mhz, SmpteFrameRate rate)
	{
		_absoluteTime = Ticks27MhzToAbsoluteTime(ticks27Mhz);
		_frameRate = rate;
	}

	/// <summary>
	///     Converts the specified absolute time to absolute time.
	/// </summary>
	/// <param name="ticksPcrTb">Ticks PCRTb to be converted.</param>
	/// <returns>The absolute time.</returns>
	private static decimal TicksPcrTbToAbsoluteTime(long ticksPcrTb)
	{
		return ticksPcrTb / 90000M;
	}

	/// <summary>
	/// Converts the specified absolute time to absolute time.
	/// </summary>
	/// <param name="ticks27Mhz">Ticks 27Mhz to be converted.</param>
	/// <returns>The absolute time.</returns>
	private static decimal Ticks27MhzToAbsoluteTime(long ticks27Mhz)
	{
		var ticksPcrTb = Ticks27MhzToPcrTb(ticks27Mhz);
		return TicksPcrTbToAbsoluteTime(ticksPcrTb);
	}

	/// <summary>
	/// Converts from 27Mhz ticks to PCRTb.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A <see cref="long"/> with the PCRTb.</returns>
	private static long Ticks27MhzToPcrTb(long ticks27Mhz)
	{
		return ticks27Mhz / 300;
	}

	/// <summary>
	/// Returns a SMPTE 12M formatted time code string from a 27Mhz ticks value.
	/// </summary>
	/// <param name="ticks27Mhz">27Mhz ticks value.</param>
	/// <param name="rate">The SMPTE time code framerated desired.</param>
	/// <returns>A SMPTE 12M formatted time code string.</returns>
	public static string Ticks27MhzToSmpte12M(long ticks27Mhz, SmpteFrameRate rate)
	{
		switch (rate)
		{
			case SmpteFrameRate.Smpte2398:
				return Ticks27MhzToSmpte12M2398Fps(ticks27Mhz);
			case SmpteFrameRate.Smpte24:
				return Ticks27MhzToSmpte12M24Fps(ticks27Mhz);
			case SmpteFrameRate.Smpte25:
				return Ticks27MhzToSmpte12M25Fps(ticks27Mhz);
			case SmpteFrameRate.Smpte2997Drop:
				return Ticks27MhzToSmpte12M2927Drop(ticks27Mhz);
			case SmpteFrameRate.Smpte2997NonDrop:
				return Ticks27MhzToSmpte12M2927NonDrop(ticks27Mhz);
			case SmpteFrameRate.Smpte30:
				return Ticks27MhzToSmpte12M30Fps(ticks27Mhz);
			default:
				return Ticks27MhzToSmpte12M30Fps(ticks27Mhz);
		}
	}

	/// <summary>
	/// Returns the value of the provided time code string and framerate in 27Mhz ticks.
	/// </summary>
	/// <param name="timeCode">The SMPTE 12M formatted time code string.</param>
	/// <param name="rate">The SMPTE framerate.</param>
	/// <returns>A long that represents the value of the time code in 27Mhz ticks.</returns>
	public static long Smpte12MToTicks27Mhz(string timeCode, SmpteFrameRate rate)
	{
		switch (rate)
		{
			case SmpteFrameRate.Smpte2398:
				return Smpte12M2398FpsToTicks27Mhz(timeCode);
			case SmpteFrameRate.Smpte24:
				return Smpte12M24FpsToTicks27Mhz(timeCode);
			case SmpteFrameRate.Smpte25:
				return Smpte12M25FpsToTicks27Mhz(timeCode);
			case SmpteFrameRate.Smpte2997Drop:
				return Smpte12M2927DropToTicks27Mhz(timeCode);
			case SmpteFrameRate.Smpte2997NonDrop:
				return Smpte12M2927NonDropToTicks27Mhz(timeCode);
			case SmpteFrameRate.Smpte30:
				return Smpte12M30FpsToTicks27Mhz(timeCode);
			default:
				return Smpte12M30FpsToTicks27Mhz(timeCode);
		}
	}

	/// <summary>
	/// Converts to Ticks 27Mhz.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <returns>The number of 27Mhz ticks.</returns>
	private static long Smpte12M30FpsToTicks27Mhz(string timeCode)
	{
		var t = new TimeCode(timeCode, SmpteFrameRate.Smpte30);
		var ticksPcrTb = (t.FramesSegment * 3000) + (90000 * t.SecondsSegment) + (5400000 * t.MinutesSegment) + (324000000 * t.HoursSegment) + (7776000000 * t.DaysSegment);
		return ticksPcrTb * 300;
	}

	/// <summary>
	/// Converts to Ticks 27Mhz.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <returns>The number of 27Mhz ticks.</returns>
	private static long Smpte12M2398FpsToTicks27Mhz(string timeCode)
	{
		var t = new TimeCode(timeCode, SmpteFrameRate.Smpte2398);
		var ticksPcrTb = Convert.ToInt64((Math.Ceiling(1001 * (15 / 4D) * t.FramesSegment) + (90090 * t.SecondsSegment) + (5405400 * t.MinutesSegment) + (324324000D * t.HoursSegment) + (7783776000 * t.DaysSegment)));
		return ticksPcrTb * 300;
	}

	/// <summary>
	/// Converts to Ticks 27Mhz.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <returns>The number of 27Mhz ticks.</returns>
	private static long Smpte12M24FpsToTicks27Mhz(string timeCode)
	{
		var t = new TimeCode(timeCode, SmpteFrameRate.Smpte24);
		var ticksPcrTb = (t.FramesSegment * 3750) + (90000 * t.SecondsSegment) + (5400000 * t.MinutesSegment) + (324000000 * t.HoursSegment) + (7776000000 * t.DaysSegment);
		return ticksPcrTb * 300;
	}

	/// <summary>
	/// Converts to Ticks 27Mhz.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <returns>The number of 27Mhz ticks.</returns>
	private static long Smpte12M25FpsToTicks27Mhz(string timeCode)
	{
		var t = new TimeCode(timeCode, SmpteFrameRate.Smpte25);
		var ticksPcrTb = (t.FramesSegment * 3600) + (90000 * t.SecondsSegment) + (5400000 * t.MinutesSegment) + (324000000 * t.HoursSegment) + (7776000000 * t.DaysSegment);
		return ticksPcrTb * 300;
	}

	/// <summary>
	/// Converts to Ticks 27Mhz.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <returns>The number of 27Mhz ticks.</returns>
	private static long Smpte12M2927NonDropToTicks27Mhz(string timeCode)
	{
		var t = new TimeCode(timeCode, SmpteFrameRate.Smpte2997NonDrop);
		var ticksPcrTb = (t.FramesSegment * 3003) + (90090 * t.SecondsSegment) + (5405400 * t.MinutesSegment) + (324324000 * t.HoursSegment) + (7783776000 * t.DaysSegment);
		return ticksPcrTb * 300;
	}

	/// <summary>
	/// Converts to Ticks 27Mhz.
	/// </summary>
	/// <param name="timeCode">The timecode to convert from.</param>
	/// <returns>The number of 27Mhz ticks.</returns>
	private static long Smpte12M2927DropToTicks27Mhz(string timeCode)
	{
		var t = new TimeCode(timeCode, SmpteFrameRate.Smpte2997Drop);
		long ticksPcrTb = (3003 * t.FramesSegment) + (90090 * t.SecondsSegment) + (5399394 * t.MinutesSegment) + (6006 * (int)(t.MinutesSegment / 10D)) + (323999676 * t.HoursSegment);
		return ticksPcrTb * 300;
	}

	/// <summary>
	/// Converts to SMPTE 12M 29.27fps Non Drop.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string Ticks27MhzToSmpte12M2927NonDrop(long ticks27Mhz)
	{
		var pcrTb = Ticks27MhzToPcrTb(ticks27Mhz);
		var framecount = (int)(pcrTb / 3003);

		var days = Convert.ToInt32((framecount / 108000) / 24);
		var hours = Convert.ToInt32((framecount / 108000) % 24);
		var minutes = Convert.ToInt32(((framecount - (108000 * hours)) / 1800) % 60);
		var seconds = Convert.ToInt32(((framecount - (1800 * minutes) - (108000 * hours)) / 30) % 3600);
		var frames = (framecount - (30 * seconds) - (1800 * minutes) - (108000 * hours)) % 30;

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 29.27fps Non Drop.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string Ticks27MhzToSmpte12M2927Drop(long ticks27Mhz)
	{
		var pcrTb = Ticks27MhzToPcrTb(ticks27Mhz);
		var framecount = Convert.ToInt32(pcrTb / 3003);
		var hours = Convert.ToInt32((framecount / 107892) % 24);
		var minutes = Convert.ToInt32((framecount + (2 * Convert.ToInt32((framecount - (107892 * hours)) / 1800)) - (2 * Convert.ToInt32((framecount - (107892 * hours)) / 18000)) - (107892 * hours)) / 1800);
		var seconds = Convert.ToInt32((framecount - (1798 * minutes) - (2 * Convert.ToInt32(minutes / 10)) - (107892 * hours)) / 30);
		var frames = framecount - (30 * seconds) - (1798 * minutes) - (2 * Convert.ToInt32(minutes / 10)) - (107892 * hours);

		return FormatTimeCodeString(hours, minutes, seconds, frames, true);
	}

	/// <summary>
	/// Converts to SMPTE 12M 23.98fps.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string Ticks27MhzToSmpte12M2398Fps(long ticks27Mhz)
	{
		var pcrTb = Ticks27MhzToPcrTb(ticks27Mhz);

		var framecount = (int)((4 / 15D) * (pcrTb / 1001D));

		var days = Convert.ToInt32((framecount / 86400) / 24);
		var hours = Convert.ToInt32((framecount / 86400) % 24);
		var minutes = Convert.ToInt32(((framecount - (86400 * hours)) / 1440) % 60);
		var seconds = Convert.ToInt32(((framecount - (1440 * minutes) - (86400 * hours)) / 24) % 3600);
		var frames = (framecount - (24 * seconds) - (1440 * minutes) - (86400 * hours)) % 24;

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 24fps.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string Ticks27MhzToSmpte12M24Fps(long ticks27Mhz)
	{
		var pcrTb = Ticks27MhzToPcrTb(ticks27Mhz);
		var framecount = (int)(pcrTb / 3750);

		var days = Convert.ToInt32((framecount / 86400) / 24);
		var hours = Convert.ToInt32((framecount / 86400) % 24);
		var minutes = Convert.ToInt32(((framecount - (86400 * hours)) / 1440) % 60);
		var seconds = Convert.ToInt32(((framecount - (1440 * minutes) - (86400 * hours)) / 24) % 3600);
		var frames = (framecount - (24 * seconds) - (1440 * minutes) - (86400 * hours)) % 24;

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 25fps.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string Ticks27MhzToSmpte12M25Fps(long ticks27Mhz)
	{
		var pcrTb = Ticks27MhzToPcrTb(ticks27Mhz);
		var framecount = (int)(pcrTb / 3600);

		var days = Convert.ToInt32((framecount / 90000) / 24);
		var hours = Convert.ToInt32((framecount / 90000) % 24);
		var minutes = Convert.ToInt32(((framecount - (90000 * hours)) / 1500) % 60);
		var seconds = Convert.ToInt32(((framecount - (1500 * minutes) - (90000 * hours)) / 25) % 3600);
		var frames = (framecount - (25 * seconds) - (1500 * minutes) - (90000 * hours)) % 25;

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}

	/// <summary>
	/// Converts to SMPTE 12M 30fps.
	/// </summary>
	/// <param name="ticks27Mhz">The number of 27Mhz ticks to convert from.</param>
	/// <returns>A string that contains the correct format.</returns>
	private static string Ticks27MhzToSmpte12M30Fps(long ticks27Mhz)
	{
		var pcrTb = Ticks27MhzToPcrTb(ticks27Mhz);
		var framecount = (int)(pcrTb / 3000);

		var days = Convert.ToInt32((framecount / 108000) / 24);
		var hours = Convert.ToInt32((framecount / 108000) % 24);
		var minutes = Convert.ToInt32(((framecount - (108000 * hours)) / 1800) % 60);
		var seconds = Convert.ToInt32(((framecount - (1800 * minutes) - (108000 * hours)) / 30) % 3600);
		var frames = (framecount - (30 * seconds) - (1800 * minutes) - (108000 * hours)) % 30;

		return FormatTimeCodeString(days, hours, minutes, seconds, frames, false);
	}



	/// <summary>
	///     Converts the specified absolute time to PCRtb
	/// </summary>
	/// <param name="ticksPcrTb">PCR-tb time to be converted</param>
	private static double PcrTbToAbsoluteTime(long ticksPcrTb)
	{
		double absoluteTime = ticksPcrTb / 90000;
		return absoluteTime;
	}
	*/
	#endregion
}