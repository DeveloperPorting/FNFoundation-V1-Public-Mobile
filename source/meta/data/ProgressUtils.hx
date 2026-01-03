package meta.data;

class ProgressUtils
{
	inline public static function isFreeplayUnlocked():Bool
	{
		return (FlxG.save.data.foundation.finalStoryProgress != null && FlxG.save.data.foundation.finalStoryProgress >= 10);
	}

	inline public static function isQuizUnlocked():Bool
	{
		return (FlxG.save.data.foundation.finalStoryProgress != null
			&& FlxG.save.data.foundation.finalStoryProgress >= 10
			&& FlxG.save.data.foundation.songsBeaten != null
			&& FlxG.save.data.foundation.songsBeaten.contains("mayhem")
			&& FlxG.save.data.foundation.songsBeaten.contains("ballin")
			&& FlxG.save.data.foundation.songsBeaten.contains("hopeless")
			&& FlxG.save.data.foundation.songsBeaten.contains("vasectomy"));
	}

	public static function unlockAll():Void
	{
		FlxG.save.data.foundation.finalStoryProgress = 10;
		FlxG.save.data.foundation.songsSeen = [
			"gauche",
			"evaluation",
			"locked in",
			"terminated",
			"vivisection",
			"captivated",
			"my world",
			"harlequin",
			"scopophobia",
			"recontainment",
			"disgusting",
			"mayhem",
			"ballin",
			"hopeless",
			"vasectomy"
		];

		FlxG.save.data.foundation.songsBeaten = [
			"gauche",
			"evaluation",
			"locked in",
			"terminated",
			"vivisection",
			"captivated",
			"my world",
			"harlequin",
			"scopophobia",
			"recontainment",
			"disgusting",
			"mayhem",
			"ballin",
			"hopeless",
			"vasectomy"
		];
	}
}
