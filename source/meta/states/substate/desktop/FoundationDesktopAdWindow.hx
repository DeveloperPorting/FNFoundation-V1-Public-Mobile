/*
    these would have been random popups that appear if you afk in the desktop for long enough
    scrapped coz of images not being sized uniformly, so i would have to go through each of them
    and set their position and scale manually, and i really didnt feel like doing it

    -xeight
*/

// package meta.states.substate.desktop;

// import flixel.input.mouse.FlxMouseEvent;
// import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

// class FoundationDesktopAdWindow extends FlxTypedSpriteGroup<FlxSprite> {
//     var adPosition = [
//         [30, 82],
//         [45, 100],
//         [0, 0],
//         [0, 0],
//         [0, 0],
//     ];

//     var adScale:Array<Array<Float>> = [
//         [1.1, 0.8],
//         [0.9, 0.4]
//     ];
//     public function new(x:Float, y:Float) {
//         super(x, y);

//         var window = new FlxSprite().loadGraphic(Paths.image('menu/desktopnew/basewindow'));
//         window.scale.set(0.75, 0.75);
//         window.updateHitbox();
//         add(window);

//         var ad = new FlxSprite();       
//         ad.frames = Paths.getSparrowAtlas('menu/desktopnew/ads');
//         ad.animation.addByPrefix("1", "Ad1");
//         ad.animation.addByPrefix("2", "Ad2");
//         ad.animation.addByPrefix("3", "Ad3");
//         ad.animation.addByPrefix("4", "Ad4");
//         ad.animation.addByPrefix("5", "Ad5");

//         var adNum = FlxG.random.int(1, 2);
//         // var adNum = 2;

//         ad.animation.play(Std.string(adNum));

//         ad.x = adPosition[adNum - 1][0];
//         ad.y = adPosition[adNum - 1][1];
//         ad.scale.set(adScale[adNum-1][0], adScale[adNum-1][1]);
//         ad.updateHitbox();
//         add(ad);

//         FlxMouseEvent.add(this, (s:FlxSprite) -> {
//             destroy();
//         });
//     }
// }