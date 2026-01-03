package gameObjects;

import flixel.FlxState;
import flixel.util.FlxAxes;

class Subtitles {
    public static var colors:Map<String, String> = [
        "ryan" => "#9A9FFF",
        "dutch" => "#7C80CD",
        "rookie" => "#888EFF",
        
        "sammy" => "#5059FF ",
    
        "ulgrin" => "#FFFA92",

        "thompson" => "#00CD00",
    
        "default" => "#FFFFFF"
    ];

    public static function createSubtitle(character:String, text:String, time:Float, ?camera:FlxCamera, ?state:FlxState) {
        if (!ClientPrefs.subtitles) return;
        
        var color = colors[character.toLowerCase()];
        if (color == null)
            color = colors["default"];
        
        if (camera == null)
            camera = FlxG.camera;

        if (state == null)
            state = FlxG.state;

        var subtitle:FlxText = new FlxText();
        subtitle.cameras = [camera];
        subtitle.text = text;
        subtitle.setFormat(Paths.font("cour.ttf"), 32, FlxColor.fromString(color), CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        subtitle.screenCenter(FlxAxes.X);
        subtitle.alpha = 0;
        subtitle.y = FlxG.height - 175;

        var subtitleBg:FlxSprite = new FlxSprite(subtitle.x - 5, subtitle.y - 5).makeGraphic(Std.int(subtitle.width) + 10, Std.int(subtitle.height) + 10, FlxColor.BLACK);
        subtitleBg.cameras = [camera];

        state.add(subtitleBg);
        state.add(subtitle);

        FlxTween.tween(subtitle, {"y": FlxG.height - 200, "alpha": 1}, 0.5, {ease: FlxEase.quartOut});
        FlxTween.tween(subtitleBg, {"y": FlxG.height - 200, "alpha": 0.5}, 0.5, {ease: FlxEase.quartOut});

        FlxTween.tween(subtitle, {"y": FlxG.height - 225, "alpha": 0}, 0.5, {ease: FlxEase.quartOut, startDelay: time, onComplete:(t) -> {
            subtitle.destroy();
        }});
        FlxTween.tween(subtitleBg, {"y": FlxG.height - 225, "alpha": 0}, 0.5, {ease: FlxEase.quartOut, startDelay: time, onComplete:(t) -> {
            subtitleBg.destroy();
        }});        
    }
}