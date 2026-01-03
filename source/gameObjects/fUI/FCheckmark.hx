package gameObjects.fUI;

class FCheckmark extends FlxSprite {
    public var name:String = "";
    public var state:Bool = false;

    private var onToggle:(FCheckmark)->Void = null;

    public function new(x:Float, y:Float, initState:Bool, onToggle: (FCheckmark)->Void, ?name:String) {
        super(x, y);

        frames = Paths.getSparrowAtlas('menu/settings/Settings');
        animation.addByPrefix("on", "check_select", 1);
        animation.addByPrefix("off", "check_empty", 1);

        this.state = initState;
        animation.play(state ? "on" : "off");

        antialiasing = ClientPrefs.globalAntialiasing;

        scale.set(0.5, 0.5);
        updateHitbox();

        if (name != null) this.name = name;
        this.onToggle = onToggle;
    }

    // Forced to use this since FlxMouseEvent would ignore most of the sprite coz of pixel perfect overlap checks -xeight
        // jan 2026 edit: this was before i discovered that you can actually turn it off, but im simply going through
        // the source code to prepare it for release, so im not gonna change it
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed && visible) {
            state = !state;
            animation.play(state ? "on" : "off");
            if(onToggle != null) onToggle(this);
        }
    }
}