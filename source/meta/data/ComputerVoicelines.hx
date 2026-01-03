package meta.data;

import gameObjects.Subtitles;
import flixel.FlxState;
import haxe.Json;

class ComputerVoicelines
{
	public static var neededFreeplay:String = "";
	public static var flags:Array<String> = [];
	private static var voicelines:ComputerVoicelineFile;

	private static var computer:FlxSprite;
	private static var state:FlxState;
	private static var camera:FlxCamera;

	private static var voiceline:FlxSound;
	private static var timers:Array<FlxTimer> = [];

	public static var playing:Bool = false;

	public static function setup(computer:FlxSprite, state:FlxState, camera:FlxCamera)
	{
		ComputerVoicelines.computer = computer;
		ComputerVoicelines.state = state;
		ComputerVoicelines.camera = camera;

		if (voicelines == null)
			voicelines = Json.parse(Paths.getTextFromFile('data/079data.json'));
	}

	public static function play(line:String)
	{
		if (playing) return;
		playing = true;

		var voiceline:ComputerVoiceline = find(line);
		if (voiceline == null)
		{
			trace('Voiceline $line doesnt exist');
			return;
		}

		timers = [];

		ComputerVoicelines.voiceline = FlxG.sound.load(Paths.sound('voicelines/' + voiceline.file));
		ComputerVoicelines.voiceline.persist = true;
		ComputerVoicelines.voiceline.play();

		for (i in 0...voiceline.data.length)
		{
			var lineData = voiceline.data[i];

			var nextVL:ComputerVoicelineData = voiceline.data[i + 1];
			if (nextVL == null)
				continue;
			if (nextVL.transcript == "")
			{ // Reached the end
				timers.push(new FlxTimer().start(nextVL.time, (t) ->
				{
					if (computer != null)
						computer.animation.play("neutral", true);
					t.destroy();
				}));
			}

			var voicelineLength:Float = nextVL.time - lineData.time;

			if (lineData.time == 0)
			{
				computer.animation.play(lineData.face, true);
				Subtitles.createSubtitle("default", lineData.transcript, voicelineLength, camera, state);
				continue;
			}

			timers.push(new FlxTimer().start(lineData.time, (t) ->
			{
				Subtitles.createSubtitle("default", lineData.transcript, voicelineLength, camera, state);
				if (computer != null)
					computer.animation.play(lineData.face, true);
				t.destroy();
			}));
		}

		ComputerVoicelines.voiceline.onComplete = () ->
		{
			playing = false;
			if (computer != null)
				computer.animation.play("neutral", true);

			if (flags.contains("played_idle"))
			{
				flags.remove("played_idle");

				if (state != null)
					Reflect.setProperty(state, "idling", false);
			}
		};
	}

	public static function changeVolume(to:Float, over:Float)
	{
		if (voiceline != null)
			FlxTween.tween(voiceline, {"volume": to}, over);
	}

	public static function stop()
	{
		playing = false;
		if (voiceline != null)
		{
			voiceline.stop();
			for (timer in timers)
			{
				if (timer.active)
					timer.cancel();
				timer.destroy();
			}
		}
	}

	private static function find(line:String):ComputerVoiceline
	{
		for (voiceline in voicelines.voicelines)
		{
			if (voiceline.name == line)
				return voiceline;
		}

		trace("Couldn't find a voiceline: " + line);

		return null;
	}
}

typedef ComputerVoicelineFile =
{
	var voicelines:Array<ComputerVoiceline>;
}

typedef ComputerVoiceline =
{
	var name:String;
	var file:String;
	var data:Array<ComputerVoicelineData>;
}

typedef ComputerVoicelineData =
{
	var time:Float;
	var transcript:String;
	var face:String;
}
