// A bit of a scuffed way but it gets the work done without bloating the main desktop state -xeight
package meta.states.substate.desktop;

import flixel.util.FlxSpriteUtil;
import flixel.input.mouse.FlxMouseEvent;
import meta.states.FoundationDesktopState.FoundationDesktopBaseWindow;

class FoundationDesktopResetSaveWindow extends FoundationDesktopBaseWindow
{
	var sureText:FlxText;
	var yesButton:FlxSprite;
	var yesText:FlxText;
	var noButton:FlxSprite;
	var noText:FlxText;

	var holding:Bool = false;
	var deleteHoldTimer:Float = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sureText = new FlxText(125, 100);
		sureText.antialiasing = false;
		sureText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.BLACK, CENTER);
		sureText.text = "Are you sure you want\nto delete your save data?";
		add(sureText);

		yesButton = new FlxSprite(100, 275);
		yesButton.antialiasing = false;
		yesButton.scale.set(0.35, 0.35);
		yesButton.frames = Paths.getSparrowAtlas('menu/desktopnew/genericbutton');
		yesButton.animation.addByPrefix("idle", "widebutton0");
		yesButton.animation.addByPrefix("press", "widebutton_press0");
		yesButton.animation.play("idle", true);
		yesButton.updateHitbox();
		add(yesButton);

		yesText = new FlxText(yesButton.x - 200, yesButton.y - 90, yesButton.width);
		yesText.antialiasing = false;
		yesText.text = "Yes";
		yesText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.RED);
		yesText.updateHitbox();
		add(yesText);

		noButton = new FlxSprite(400, 275);
		noButton.antialiasing = false;
		noButton.scale.set(0.35, 0.35);
		noButton.frames = Paths.getSparrowAtlas('menu/desktopnew/genericbutton');
		noButton.animation.addByPrefix("idle", "widebutton0");
		noButton.animation.addByPrefix("press", "widebutton_press0");
		noButton.animation.play("idle", true);
		noButton.updateHitbox();
		add(noButton);

		noText = new FlxText(noButton.x - 175, noButton.y - 90, noButton.width);
		noText.antialiasing = false;
		noText.text = "No";
		noText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.BLACK);
		noText.updateHitbox();
		add(noText);

		FlxMouseEvent.add(yesButton, (s:FlxSprite) ->
		{
			holding = true;
			yesText.text = "Hold";
			yesText.updateHitbox();
		}, (s:FlxSprite) ->
			{
				holding = false;
				deleteHoldTimer = 0;
				yesText.text = "Yes";
				yesText.updateHitbox();
			}, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0.25);
			}, (s:FlxSprite) ->
			{
				holding = false;
				deleteHoldTimer = 0;
				yesText.text = "Yes";
				yesText.updateHitbox();
				FlxSpriteUtil.setBrightness(s, 0);
			});

		FlxMouseEvent.add(noButton, (s:FlxSprite) ->
		{
			destroy();
		}, null, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0.25);
			}, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0);
			});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (holding) {
			deleteHoldTimer += elapsed;
			yesText.text = "Hold" + StringTools.rpad("", ".", Std.int(deleteHoldTimer+1));
		}

		if (deleteHoldTimer >= 5)
		{
			holding = false;
			deleteHoldTimer = 0;

			FlxG.save.data.foundation = {
				seenIntro: false,
				finishedGauche: false,
				doneQuiz: false,
				unlockedFreeplay: false,
	
				storyProgress: 0,
				finalStoryProgress: 0,

				pickedUpCuriositySticky: false,
				pickedUpInventorySticky: false,
				
				songsSeen: [],
				songsBeaten: []
			};

			FoundationOfficeState.turnedOn = false;
			meta.data.ComputerVoicelines.flags = [];

			FoundationIntroState.currentSegment = null;
			FoundationIntroState.currentLine = -1;
			FoundationIntroState.pastText = "";
			FoundationIntroState.pastLine = null;

			FlxG.sound.music.stop();
			FlxG.sound.music = null;
			FlxG.switchState(new FoundationIntroState());

			// FlxG.save.data.flush();
		}
	}
}
