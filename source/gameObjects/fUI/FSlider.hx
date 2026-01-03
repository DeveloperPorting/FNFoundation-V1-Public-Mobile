package gameObjects.fUI;

import flixel.addons.ui.FlxSlider;
import flixel.input.mouse.FlxMouseEvent;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

// UNFINISHED
class FSlider extends FlxTypedSpriteGroup<FlxSprite> {
    public var name:String = "";
    
    var sliderBase:FlxSprite;
    var sliderSlider:FlxSprite;

    var slider:FlxSlider;

    var rangeMin:Float = 0;
    var rangeMax:Float = 100;

    private var onChange:(FSlider)->Void = null;
    
    public function new(x:Float, y:Float, tracker:Dynamic, trackerVariable:String, rangeMin:Float, rangeMax:Float, onChange:(FSlider)->Void, ?name:String) {
        super(x, y);

        this.rangeMin = rangeMin;
        this.rangeMax = rangeMax;

        this.onChange = onChange;

        if(name != null)
            this.name = name;

        // sliderBase = new FlxSprite();
        // sliderBase.frames = Paths.getSparrowAtlas('menu/settings/Settings');
        // sliderBase.animation.addByPrefix("idle", "sliderbar", 1);
        // sliderBase.animation.play("idle");
        // sliderBase.updateHitbox();
        // add(sliderBase);

        // sliderSlider = new FlxSprite();
        // sliderSlider.frames = Paths.getSparrowAtlas('menu/settings/Settings');
        // sliderSlider.animation.addByPrefix("idle", "slidingthinguclickanddrag", 1);
        // sliderSlider.animation.play("idle");
        // sliderSlider.updateHitbox();
        // add(sliderSlider);

        slider = new FlxSlider(tracker, trackerVariable, 0, 0, rangeMin, rangeMax);
        add(slider);

        antialiasing = ClientPrefs.globalAntialiasing;

        FlxMouseEvent.add(sliderBase, onSliderClicked, null, null, null, false, true, false);

        scale.set(0.5, 0.5);
        updateHitbox();
    }

    private function onSliderClicked(slider:FlxSprite) {

    }
}