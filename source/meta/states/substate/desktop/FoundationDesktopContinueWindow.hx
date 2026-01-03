// A bit of a scuffed way but it gets the work done without bloating the main desktop state -xeight
package meta.states.substate.desktop;

import flixel.util.FlxSpriteUtil;
import flixel.input.mouse.FlxMouseEvent;
import meta.states.FoundationDesktopState.FoundationDesktopBaseWindow;

class FoundationDesktopContinueWindow extends FoundationDesktopBaseWindow
{
	var sureText:FlxText;
	var continueButton:FlxSprite;
	var continueText:FlxText;
	var startOverButton:FlxSprite;
	var startOverText:FlxText;

	var transitioning:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sureText = new FlxText(125, 100);
		sureText.antialiasing = false;
		sureText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.BLACK, CENTER);
		sureText.text = "Do you wish to continue\nor start over?";
		add(sureText);

		continueButton = new FlxSprite(100, 275);
		continueButton.antialiasing = false;
		continueButton.scale.set(0.35, 0.35);
		continueButton.frames = Paths.getSparrowAtlas('menu/desktopnew/genericbutton');
		continueButton.animation.addByPrefix("idle", "widebutton0");
		continueButton.animation.addByPrefix("press", "widebutton_press0");
		continueButton.animation.play("idle", true);
		continueButton.updateHitbox();
		add(continueButton);

		continueText = new FlxText(continueButton.x - 340, continueButton.y - 190);
		continueText.antialiasing = false;
		continueText.text = "Continue";
		continueText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.BLACK);
		continueText.updateHitbox();
		add(continueText);

		startOverButton = new FlxSprite(400, 275);
		startOverButton.antialiasing = false;
		startOverButton.scale.set(0.35, 0.35);
		startOverButton.frames = Paths.getSparrowAtlas('menu/desktopnew/genericbutton');
		startOverButton.animation.addByPrefix("idle", "widebutton0");
		startOverButton.animation.addByPrefix("press", "widebutton_press0");
		startOverButton.animation.play("idle", true);
		startOverButton.updateHitbox();
		add(startOverButton);

		startOverText = new FlxText(startOverButton.x - 340, startOverButton.y - 187.5);
		startOverText.antialiasing = false;
		startOverText.text = "Start Over";
		startOverText.setFormat(Paths.font("pixel.otf"), 20, FlxColor.BLACK);
		startOverText.updateHitbox();
		add(startOverText);

		FlxMouseEvent.add(continueButton, (s:FlxSprite) ->
		{
			if (!transitioning)
				FoundationDesktopFootageWindow.startThing("story_mode");
			transitioning = true;
		}, null, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0.25);
			}, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0);
			});

		FlxMouseEvent.add(startOverButton, (s:FlxSprite) ->
		{
			if (!transitioning) {
				FlxG.save.data.foundation.storyProgress = 0;
				FoundationDesktopFootageWindow.startThing("story_mode");
			}
			transitioning = true;
		}, null, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0.25);
			}, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0);
			});
	}
}
