package meta.states.substate;

import flixel.input.mouse.FlxMouseEvent;
import haxe.Json;
import gameObjects.PsychVideoSprite;

class FoundationGameOverSubstate extends MusicBeatSubstate {
    public static var videoOverride:String = "";
    public static var deathMessageOverride:String = "";

    var video:PsychVideoSprite;

    var transitioning:Bool = false;
    var canReset:Bool = false;

    var cam:FlxCamera;
    var songs:Array<String> = [
        "gauche",
        "locked in",
        "evaluation",
        "terminated",
        "vivisection",
        "captivated",
        "my world",
        "harlequin",
        "scopophobia",
        "recontainment",
        "disgusting",
        "vasectomy"
    ];

    var box:FlxSprite;
    var deathMessage:FlxText;

    var restartButton:FlxSprite;
    var quitButton:FlxSprite;

    var diedText:FlxText;

    var myheart:FlxSprite;

    override function create() {
        super.create();

        // if (!songs.contains(PlayState.SONG.song.toLowerCase())) {
        //     MusicBeatState.resetState();
        //     return;
        // }

        if (videoOverride == "")
            videoOverride = PlayState.SONG.song.toLowerCase();
        if (deathMessageOverride == "")
            deathMessageOverride = videoOverride;

        FlxG.sound.music.stop();

        cam = new FlxCamera();
        cam.bgColor.alpha = 0;
        FlxG.cameras.add(cam, false);

        Paths.forceCaching = false;

        box = new FlxSprite().loadGraphic(Paths.image('menu/death/box'));
        box.color = 0xFFAAAAAA;
        box.antialiasing = ClientPrefs.globalAntialiasing;
        box.cameras = [cam];
        box.scale.set(0.5, 0.5);
        box.updateHitbox();
        box.screenCenter();
        box.x += 300;

        if (songs.contains(PlayState.SONG.song.toLowerCase())) {
            deathMessage = new FlxText(0, 350, 335);
            deathMessage.antialiasing = ClientPrefs.globalAntialiasing;
            deathMessage.cameras = [cam];
            deathMessage.setFormat(Paths.font("cour.ttf"), 14, CENTER);
            deathMessage.text = Reflect.field(Json.parse(Paths.getTextFromFile('data/deaths.json')).deaths, deathMessageOverride);
            deathMessage.screenCenter(X);
            deathMessage.x += 360;
        }

        restartButton = new FlxSprite(0, 145).loadGraphic(Paths.image('menu/death/retry'));
        restartButton.antialiasing = ClientPrefs.globalAntialiasing;
        restartButton.cameras = [cam];
        restartButton.scale.set(0.5, 0.5);
        restartButton.screenCenter(X);
        restartButton.updateHitbox();
        restartButton.x += 500;

        quitButton = new FlxSprite(0, 250).loadGraphic(Paths.image('menu/death/quit'));
        quitButton.antialiasing = ClientPrefs.globalAntialiasing;
        quitButton.cameras = [cam];
        quitButton.scale.set(0.5, 0.5);
        quitButton.screenCenter(X);
        quitButton.updateHitbox();
        quitButton.x += 500;

        diedText = new FlxText(0, 35);
        diedText.antialiasing = ClientPrefs.globalAntialiasing;
        diedText.cameras = [cam];
        diedText.setFormat(Paths.font("cour.ttf"), 68, CENTER);
        diedText.text = "YOU DIED";
        diedText.screenCenter(X);
        diedText.x += 350;

        myheart = new FlxSprite();
        myheart.antialiasing = ClientPrefs.globalAntialiasing;
        myheart.cameras = [cam];
        myheart.frames = Paths.getSparrowAtlas("menu/death/Heart");
        myheart.animation.addByPrefix("idle", "heart_idle", 24);
        myheart.animation.addByPrefix("confirm", "heart_confirm", 24, false);
        myheart.animation.play("idle", true);
        myheart.scale.set(0.5, 0.5);
        myheart.updateHitbox();
        myheart.screenCenter();
        myheart.x -= 300;

        FlxMouseEvent.add(restartButton, (s) -> {
            if (transitioning) return;
            transitioning = true;

            myheart.animation.play("confirm", true);
            myheart.updateHitbox();
            myheart.x -= 25;
            myheart.y -= 70;

            FlxG.sound.music.fadeOut(1);

            FlxTween.tween(cam, {"alpha": 0}, 2);
            new FlxTimer().start(3, (t) -> MusicBeatState.resetState());
        });

        FlxMouseEvent.add(quitButton, (s) -> {
            if (transitioning) return;
            transitioning = true;

            quitLikeACoward();
        });

        if (songs.contains(PlayState.SONG.song.toLowerCase())) {
            video = new PsychVideoSprite();
            video.cameras = [cam];
            video.load(Paths.video("deaths/" + videoOverride));
            video.canSkip = true;
            video.addCallback('onEnd',()->{
                video.kill();
                finishThing();
            });
            video.scale.set(0.7, 0.675);
            video.addCallback('onFormat',()->{
                video.updateHitbox();
                video.screenCenter();
            });
            video.antialiasing = ClientPrefs.globalAntialiasing;
            add(video);

            video.play();
        }
        else
            finishThing();
    }

    override function destroy() {
        super.destroy();

        Paths.forceCaching = true;
        FlxG.mouse.visible = false;

        videoOverride = "";
        deathMessageOverride = "";
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!transitioning && controls.BACK && !PlayState.introSequence) {
            transitioning = true;

            quitLikeACoward();
        }
        else if(!transitioning && controls.ACCEPT && canReset) {
            transitioning = true;
            
            MusicBeatState.resetState();
        }
    }

    function finishThing() {
        new FlxTimer().start(0.5, (t) -> canReset = true);

        FlxG.sound.playMusic(Paths.music("GameOver"), true);
        FlxG.sound.music.fadeIn(5);

        FlxG.mouse.visible = true;

        cam.flash(FlxColor.BLACK, 1);

        add(box);

        if (songs.contains(PlayState.SONG.song.toLowerCase()))
            add(deathMessage);

        add(restartButton);
        if (!PlayState.introSequence) add(quitButton);
        add(diedText);

        myheart.alpha = 0;
        FlxTween.tween(myheart, {"alpha": 1}, 1);
        add(myheart);

    }

    function quitLikeACoward() {
        PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;
		PlayState.explainedMechanic = false;

        Init.SwitchToPrimaryMenu(FoundationDesktopState);
        FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()));
        FlxG.sound.music.volume = 0.7;  
    }
}