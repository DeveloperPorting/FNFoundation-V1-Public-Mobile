addHaxeLibrary("Subtitles", "gameObjects");

function onEvent(name, value1, value2) {
    if (name == "Subtitle") {
        var split = value1.split(":");
        var char = split[0];
        var text = split[1];

        var time = Std.parseFloat(value2);
        
        Subtitles.createSubtitle(char, text, time, game.camOther);
    }
}