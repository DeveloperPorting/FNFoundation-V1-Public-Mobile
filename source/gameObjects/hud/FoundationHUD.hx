package gameObjects.hud;

import flixel.group.FlxSpriteGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using StringTools;

/**
	Styles:
		Blue - Blue one
		Orange - Orange one
		Decay - Pocket dimension
		Cardboard - Harlequin
		Acid - Disgusting acid
**/
class FoundationHUD extends BaseHUD
{
	var hpGroup:FlxTypedSpriteGroup<FlxSprite>;
	var infoGroup:FlxTypedSpriteGroup<FlxSprite>;

	public var style(default, set):String = "Orange";

	var atlas:FlxAtlasFrames;

	public var special:FlxSprite;
	public var icon:FlxSprite;
	public var base:FlxSprite;
	public var bars:FlxSpriteGroup;
	public var splashes:FlxSpriteGroup;

	var totalSegments:Int = 6;
	public var healthSegmented:Int = 3;
	var healthSegmentedPrev:Int = 3;

	var infoSprite:FlxSprite;
	var infoScore:FlxText;
	var infoCombo:FlxText;
	var infoMisses:FlxText;

    var shake:Bool = false;
    var alphaTween:FlxTween;

	public function new()
	{
		super(0, ClientPrefs.downScroll ? -100 : FlxG.height - 300);

		hpGroup = new FlxTypedSpriteGroup<FlxSprite>(700, 0);
		infoGroup = new FlxTypedSpriteGroup<FlxSprite>(637.5, 55);

		atlas = Paths.getSparrowAtlas('ui/HPbar');

		antialiasing = ClientPrefs.globalAntialiasing;

		createBase();
		createBars();
		createIcon();
		createInfobox();
		createSpecial();

		add(hpGroup);
		add(infoGroup);

		hpGroup.alpha = 0.5;
		hpGroup.scale.set(0.5, 0.5);
		hpGroup.updateHitbox();

		infoGroup.alpha = 0.5;
		infoGroup.scale.set(0.75, 0.75);
		infoGroup.updateHitbox();

		style = style;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (style != "Cardboard")
			healthSegmented = Math.round((PlayState.instance.health) * totalSegments / 2);

		if (healthSegmented != healthSegmentedPrev)
		{
			var healthDelta:Int = healthSegmented - healthSegmentedPrev;

			if (healthDelta < 0) // Damage
			{
				for (i in 0...totalSegments)
				{
					var segment = totalSegments - i - 1;

					var bar:FlxSprite = bars.members[segment];

					if (segment + 1 > healthSegmented)
					{
						if (bar.animation.curAnim != null && !bar.animation.curAnim.name.contains("Broken"))
						{
                            if (bar.animation.exists("Broken" + style)) {
								bar.animation.play("Broken" + style, true);
								bar.updateHitbox();
								hpGroup.updateHitbox();
							}
						}
						// else if (!bar.animation.exists("Broken" + style))
						// {
						// 	bar.visible = false;
						// }
					}
					else {
						bar.animation.play("Static" + style, true);
						bar.updateHitbox();
						hpGroup.updateHitbox();
					}
				}
			}
			else if (healthDelta > 0) // Heal
			{
				for (i in 0...totalSegments)
				{
					var segment = totalSegments - i - 1;

					var bar:FlxSprite = bars.members[segment];

					if (segment + 1 <= healthSegmented && bar.animation.curAnim != null && !bar.animation.curAnim.name.contains("Static"))
					{
						bar.visible = true;
						// bar.animation.stop();
						bar.animation.play("Static" + style, true);
						bar.updateHitbox();
						hpGroup.updateHitbox();
					}
				}
			}

            shake = healthSegmented <= 2;

			if (healthSegmented <= 2)
				alphaTween = FlxTween.tween(hpGroup, {"alpha": 1}, 1);
			else
				alphaTween = FlxTween.tween(hpGroup, {"alpha": 0.5}, 1);            
		}

		if (style == "Cardboard")
			hpGroup.alpha = 1;
        // for (bar in bars) {
        //     if (shake)
        //         bar.offset.set(0, FlxG.random.float(-2, 2));
        //     else
        //         bar.offset.set(0, 0);
        // }

        if (healthSegmented <= 2 && icon.animation.curAnim.name != "Losing"+style)
            icon.animation.play("Losing" + style, true);
        else if (healthSegmented > 2)
            icon.animation.play("Neutral" + style, true);

		icon.updateHitbox();
		hpGroup.updateHitbox();

		healthSegmentedPrev = healthSegmented;

		infoScore.text = PlayState.instance.ratingName;
		infoCombo.text = Std.string(PlayState.instance.combo);
		infoMisses.text = Std.string(PlayState.instance.songMisses);

		infoScore.updateHitbox();
		infoCombo.updateHitbox();
		infoMisses.updateHitbox();
	}

	function set_style(_style:String):String
	{
		// if (style == _style) return style; 	// wasnt an issue before but parasite hud has
		// 							 		// a really long bar break animation

		base.animation.play(_style, true);
		base.updateHitbox();

		for (i in 0...bars.length)
		{
			var bar:FlxSprite = bars.members[i];

			if (i < healthSegmented)
				bar.animation.play("Static" + _style, true);
			else {
				bar.animation.play("Broken" + _style, true, false, 10);
			}
			bar.updateHitbox();
		}
		bars.updateHitbox();

		if (healthSegmented <= 2)
			icon.animation.play("Neutral" + _style, true);
		else
			icon.animation.play("Losing" + _style, true);
		icon.updateHitbox();

		if (special.animation.exists("Special" + style)) {
			special.visible = true;
			special.animation.play("Special" + style, true);
		}
		else {
			special.visible = false;
		}

		hpGroup.updateHitbox();

		return style = _style;
	}

	public function getIntendedAlpha() {
		return (healthSegmented <= 2) ? 1 : 0.5;
	}

	private function createBase()
	{
		base = new FlxSprite();
		base.frames = atlas;

		base.animation.addByPrefix("Blue", "HpBase1", 1, true);
		base.animation.addByPrefix("Orange", "HpBase2", 1, true);
		base.animation.addByPrefix("Decay", "HpBaseDecay", 1, true);
		base.animation.addByPrefix("Cardboard", "HarleyHpBase", 1, true);
		base.animation.addByPrefix("Acid", "HpBaseAcid", 1, true);
		base.animation.addByPrefix("Parasite", "HpbaseVivi", 1, true);
		base.animation.addByPrefix("Recon", "ReconHpbase", 1, true);

		base.animation.play(style, true);
		base.updateHitbox();

		hpGroup.add(base);
	}

	private function createBars()
	{
		bars = new FlxSpriteGroup(6, 52); // Yes, these are very much magic numbers. No, I will do nothing about it -xeight
		for (i in 0...totalSegments)
		{
			var bar:FlxSprite = new FlxSprite(bars.x + (25 * i));

			bar.frames = atlas;

			bar.animation.addByPrefix("StaticBlue", "HpBar1", 1, true);
			bar.animation.addByPrefix("StaticOrange", "HpBar2", 1, true);
            bar.animation.addByPrefix("StaticDecay", "HpBarDecay0", 1, true);
			bar.animation.addByPrefix("StaticCardboard", "HarleyHpBar1", 1, true);
			bar.animation.addByPrefix("StaticAcid", "HpbarAcid0", 1, true);
			bar.animation.addByPrefix("StaticParasite", "HpbarVivi0", 1, true);
			bar.animation.addByPrefix("StaticRecon", "ReconHpBar0", 1, true);

			bar.animation.addByPrefix("BrokenBlue", "HpBarBroken1", 24, false);
			bar.animation.addByPrefix("BrokenOrange", "HpBarBroken2", 24, false);
            bar.animation.addByPrefix("BrokenDecay", "HpBarDecayBroken", 24, false);
			bar.animation.addByPrefix("BrokenCardboard", "HpBarBroken1", 24, false);
			bar.animation.addByPrefix("BrokenAcid", "HpbarAcidBroken0", 24, false);
			bar.animation.addByPrefix("BrokenParasite", "HpbarVivilosing", 24, false);
			bar.animation.addByPrefix("BrokenRecon", "ReconHpBarBroken", 24, false);

			bar.animation.play("Static" + style, true);
			bar.updateHitbox();

			bars.add(bar);
			bars.updateHitbox();
		}
		hpGroup.add(bars);
	}

	private function createIcon()
	{
		icon = new FlxSprite(200, 30);
		icon.frames = atlas;

		icon.animation.addByPrefix("NeutralBlue", "BfNeutral1", 1, true);
		icon.animation.addByPrefix("NeutralOrange", "BfNeutral2", 1, true);
		icon.animation.addByPrefix("NeutralDecay", "BfNeutralDecay", 1, true);
		icon.animation.addByPrefix("NeutralCardboard", "HarleyBFneutral", 24, true);
		icon.animation.addByPrefix("NeutralAcid", "AcidBFneutral", 24, true);
		icon.animation.addByPrefix("NeutralParasite", "Vivibfneutral", 24, true);
		icon.animation.addByPrefix("NeutralRecon", "Reconbfneutral", 24, true);

		icon.animation.addByPrefix("LosingBlue", "BfLosing1", 24, true);
		icon.animation.addByPrefix("LosingOrange", "BfLosing2", 24, true);
		icon.animation.addByPrefix("LosingDecay", "bfLosingDecay", 24, true);
		icon.animation.addByPrefix("LosingCardboard", "HarleyBFlosing", 24, true);
		icon.animation.addByPrefix("LosingAcid", "AcidBFlosing", 24, true);
		icon.animation.addByPrefix("LosingParasite", "Vivibflosing", 24, true);
		icon.animation.addByPrefix("LosingRecon", "Reconbflosing", 24, true);

		icon.animation.play("Neutral" + style, true);
		icon.updateHitbox();

		hpGroup.add(icon);
	}

	private function createSpecial() {
		special = new FlxSprite(200, 30);
		special.frames = atlas;

		special.animation.addByPrefix("SpecialRecon", "ReconPadlock", 1, true);

		if (special.animation.exists("Special" + style))
			special.animation.play("Special" + style, true);
		else
			special.visible = false;
		
		hpGroup.add(special);
	}

	private function createInfobox() {
		infoSprite = new FlxSprite();
		infoSprite.frames = Paths.getSparrowAtlas('ui/UiScore');
		infoSprite.animation.addByPrefix("idle", "Uiuhhscore", 1);
		infoSprite.animation.play("idle", true);
		infoGroup.add(infoSprite);

		infoScore = new FlxText(250, 75);
		infoScore.setFormat(Paths.font('cour.ttf'), 24);
		infoScore.text = "";
		infoScore.updateHitbox();
		infoGroup.add(infoScore);

		infoCombo = new FlxText(375, 75);
		infoCombo.setFormat(Paths.font('cour.ttf'), 24);
		infoCombo.text = "0";
		infoCombo.updateHitbox();
		infoGroup.add(infoCombo);

		infoMisses = new FlxText(450, 75);
		infoMisses.setFormat(Paths.font('cour.ttf'), 24);
		infoMisses.text = "0";
		infoMisses.updateHitbox();
		infoGroup.add(infoMisses);
	}
}
