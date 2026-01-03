package gameObjects;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import meta.data.SongMetadata;

class SongCard extends FlxTypedSpriteGroup<FlxSprite>{

    var meta:SongMetadata;
    var tex:String = "";
    var font:String = "cour.ttf";

    var nowPlayingText:FlxText;
    var songTitleText:FlxText;
    var composerText:FlxText;
    var textBG:FlxSprite;

    public function new(x:Int, y:Int, meta:SongMetadata) {
        super(x, y);

        this.meta = meta;

        nowPlayingText = new FlxText(x + 5, y + 10, 0, "Now playing:");
        nowPlayingText.setFormat(Paths.font(font), 24, FlxColor.WHITE);

        songTitleText = new FlxText(x + 5, y + 65, 200, meta.card.name);
        songTitleText.autoSize = true;
        songTitleText.wordWrap = false;
        songTitleText.setFormat(Paths.font(font), 48, FlxColor.WHITE);

        composerText = new FlxText(x + 5, y + 145, 200, "By " + meta.credits.composer);
        composerText.autoSize = true;
        composerText.wordWrap = false;
        composerText.setFormat(Paths.font(font), 24, FlxColor.WHITE);

        textBG = new FlxSprite(x,y);
        textBG.frames = Paths.getSparrowAtlas('ui/songcards');
        textBG.scale.set(0.75, 0.75);
        textBG.animation.addByPrefix('idle', 'songcardshit', 24, false);
        textBG.updateHitbox();
        
        add(textBG);
        add(nowPlayingText);
        add(songTitleText);
        add(composerText);
    }

    public function show() {
        textBG.animation.play('idle');
        FlxTween.tween(nowPlayingText, {x: this.x + 235}, 0.5, {ease: FlxEase.expoOut});
        new FlxTimer().start(0.25, (tmr:FlxTimer) -> {
            FlxTween.tween(songTitleText, {x: this.x + 235}, 0.5, {ease: FlxEase.expoOut});
        });
        new FlxTimer().start(0.35, (tmr:FlxTimer) -> {
            FlxTween.tween(composerText, {x: this.x + 235}, 0.5, {ease: FlxEase.expoOut});
        });

        new FlxTimer().start(2.25, (tmr:FlxTimer) -> {
            FlxTween.tween(nowPlayingText, {alpha: 0}, 0.5);
            FlxTween.tween(songTitleText, {alpha: 0}, 0.5);
            FlxTween.tween(composerText, {alpha: 0}, 0.5);
            // FlxTween.tween(nowPlayingText, {x: this.x}, 0.5, {ease: FlxEase.expoIn});
        });
        // new FlxTimer().start(meta.card.duration, () -> {
        //     textBG.animation
        // });
        // FlxTween.tween(this, {x: init + width}, 0.5, {ease: FlxEase.expoIn, onComplete: twn -> {
        //     FlxTween.tween(this, {x: init}, 0.5, {ease: FlxEase.expoOut, startDelay: meta.card.duration});
        // }});
    }
}