package gameObjects;

import haxe.Json;
import sys.io.File;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

typedef MultiCharacterFile = {
    var animations:Array<MultiCharacterAnimation>;
}

typedef MultiCharacterAnimation = {
    var name:String;
    var file:String;
    var animation:String;
}

/**
    Very janky support for a character that uses multiple character files.

    Logic mostly based on Vs. Tricky V2, but probably a bit cleaner.

    Requires you to code all the animation logic in the stage file, since trying to
        make this supported by default character system is completely unreasonable.

    There are no safety checks WHATSOEVER. If you fuck up at some point - It is on you.
    This is not designed to be used at all, unless you know what you are doing.

    Much love,
    -xeight
**/
class MultiCharacter extends FlxTypedSpriteGroup<FlxSprite> {
    public var sprites:Map<String, Character> = [];
    public var animations:Map<String, String> = [];
    public var currentSprite:Character = null;

    public var currentChar:String = '682Multi';
    public function new(x:Float, y:Float, ?character:String = '682Multi') {
        super(x, y);

        if (character != null)
            currentChar = character;

        load();
    }

    public function load(?character:String) {
        if (character == null) character = currentChar;

        var json:MultiCharacterFile = getCharacterFile(character);
        for (animation in json.animations) {
            var char = new Character(this.x, this.y, animation.file);
            add(char);

            sprites.set(animation.name, char);
            animations.set(animation.name, animation.animation);
        }

        playAnim('idle');
    }

    public function playAnim(anim:String, ?force:Bool = false) {
        for (animation => sprite in sprites) {
            if (animation != anim) {
                sprite.visible = false;
                continue;
            }
            sprite.visible = true;
            currentSprite = sprite;
        }
        
        var anim:String = animations.get(anim);
        currentSprite.playAnim(anim, force);
    }

    public static function getCharacterFile(character:String):MultiCharacterFile {
        var characterPath:String = 'characters/' + character + '.json';

		#if MODS_ALLOWED
		var path:String = Paths.modFolders(characterPath);
        #else
        var path:String = Paths.getPreloadPath(characterPath);
        #end

		#if MODS_ALLOWED
		var rawJson = File.getContent(path);
		#else
		var rawJson = Assets.getText(path);
		#end

		return cast Json.parse(rawJson);
    }
}