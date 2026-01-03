package gameObjects.hud;

import gameObjects.hud.BaseHUD;
import flixel.math.FlxRect;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class LobCorpHUD extends BaseHUD
{
    var atlas:FlxAtlasFrames;

    var bg:FlxSprite;
    var bar:FlxSprite;
    
    var barClip:FlxRect;
    var clipConvert = 480/2;

	public function new()
	{
		super(0, ClientPrefs.downScroll ? 0 : FlxG.height - 100);

        atlas = Paths.getSparrowAtlas('stages/lobcorp/HopelessHP');

        barClip = new FlxRect(0, 0, 0, 500);

        bar = new FlxSprite(906, 12);
        bar.scale.set(0.5, 0.5);
        bar.frames = atlas;
        bar.animation.addByPrefix("idle", "HP_fill", 1);
        bar.animation.play("idle");
        bar.updateHitbox();
        bar.clipRect = barClip;
        add(bar);

        bg = new FlxSprite(900, 0);
        bg.scale.set(0.5, 0.5);
        bg.frames = atlas;
        bg.animation.addByPrefix("idle", "HP_bar", 1);
        bg.animation.play("idle");
        bg.updateHitbox();
        add(bg);

        clipConvert = bar.frameWidth/2;
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        barClip.width = PlayState.instance.health * clipConvert;
        bar.clipRect = bar.clipRect;
    }
}
