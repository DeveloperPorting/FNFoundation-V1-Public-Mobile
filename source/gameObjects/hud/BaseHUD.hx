package gameObjects.hud;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class BaseHUD extends FlxTypedSpriteGroup<FlxSprite> {
    public function new(x:Float, y:Float) {
        super(x, y);
    }
}