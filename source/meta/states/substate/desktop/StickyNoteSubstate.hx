package meta.states.substate.desktop;

class StickyNoteSubstate extends MusicBeatSubstate {
    var sprite:FlxSprite;
    var image:String;
    var literalStickyNote:Bool = true;
    var canExit:Bool = false;

    public function new(image:String, literalSticky:Bool = true) {
        super();

        this.image = image;
        this.literalStickyNote = literalSticky;
    }

    override function create() {
        super.create();

        FoundationOfficeState.doParallax = false;
        FoundationOfficeState.inSubstate = true;

        var bg:FlxSprite = new FlxSprite(-500, -500).makeGraphic(1, 1, FlxColor.BLACK);
        bg.cameras = [CoolUtil.getTopCam()];
        bg.setGraphicSize(20000, 20000);
        bg.alpha = 0.5;
        add(bg);

        sprite = new FlxSprite().loadGraphic(Paths.image(image));
        sprite.antialiasing = ClientPrefs.globalAntialiasing;
        sprite.cameras = [CoolUtil.getTopCam()];
        sprite.scale.set(0.65, 0.65);
        sprite.updateHitbox();
        sprite.screenCenter(X);
        add(sprite);

        if (literalStickyNote) {
            sprite.y = FlxG.height + 200;
            FlxTween.tween(sprite, {"y": (FlxG.height - sprite.height) / 2}, 1, {ease: FlxEase.quartOut});
        }

        new FlxTimer().start(0.1, (t) -> canExit = true);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (canExit && (controls.BACK || controls.ACCEPT || FlxG.mouse.justPressed)) {
            switch (image) {
                case "menu/officenew/note1Full":
                    FoundationOfficeState.instance.curiosityStickyNote.visible = true;
                case "menu/officenew/note2Full":
                    FoundationOfficeState.instance.inventoryStickyNote.visible = true;
            }
            FoundationOfficeState.inSubstate = false;
            FoundationOfficeState.doParallax = true;
            FoundationInventorySubstate.inSubSubState = false;
            close();
        }
    }
}