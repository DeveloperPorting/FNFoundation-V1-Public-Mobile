package gameObjects.fUI;

class FButton extends FlxSprite {
    public var name:String = "";

    private var onPress:(FButton)->Void = null;
    
    public function new(x:Float, y:Float, onPress:(FButton)->Void, ?name:String) {
        super(x, y);
        frames = Paths.getSparrowAtlas('menu/settings/Settings');
        animation.addByPrefix("idle", "rmptysh", 1);
        animation.play("idle");

        antialiasing = ClientPrefs.globalAntialiasing;

        scale.set(0.5, 0.5);
        updateHitbox();

        if (name != null) this.name = name;
        this.onPress = onPress;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed && visible) {
            if(onPress != null) onPress(this);
        }
    }
}