// A bit of a scuffed way but it gets the work done without bloating the main desktop state -xeight
package meta.states.substate.desktop;

import flixel.util.FlxSpriteUtil;
import flixel.input.mouse.FlxMouseEvent;
import meta.states.FoundationDesktopState.FoundationDesktopBaseWindow;

class FoundationDesktopQuitSubstate extends FoundationDesktopBaseWindow
{
	var sureText:FlxText;
	var yesButton:FlxSprite;
	var yesText:FlxText;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sureText = new FlxText(75, 100);
		sureText.antialiasing = false;
		sureText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.BLACK);
		sureText.text = "Are you sure you want to quit?";
		add(sureText);

		yesButton = new FlxSprite(85, 275);
		yesButton.antialiasing = false;
		yesButton.scale.set(0.35, 0.35);
		yesButton.updateHitbox();
		yesButton.frames = Paths.getSparrowAtlas('menu/desktopnew/genericbutton');
		yesButton.animation.addByPrefix("idle", "widebutton0");
		yesButton.animation.addByPrefix("press", "widebutton_press0");
		yesButton.animation.play("idle", true);
		add(yesButton);

		yesText = new FlxText(yesButton.x - 20, yesButton.y - 45);
		yesText.antialiasing = false;
		yesText.text = "Yes";
		yesText.setFormat(Paths.font("pixel.otf"), 24, FlxColor.BLACK);
		add(yesText);

		FlxMouseEvent.add(yesButton, (s:FlxSprite) ->
		{
			FlxG.sound.music.fadeOut(1);
			FlxTween.tween(FlxG.camera, {"alpha": 0}, 1.5, {
				onComplete: (t) ->
				{
					Sys.exit(0);
				}
			});
		}, null, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0.25);
			}, (s:FlxSprite) ->
			{
				FlxSpriteUtil.setBrightness(s, 0);
			});
	}
}
