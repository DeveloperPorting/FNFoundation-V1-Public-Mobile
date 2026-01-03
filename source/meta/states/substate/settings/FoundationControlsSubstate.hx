package meta.states.substate.settings;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import gameObjects.fUI.FButton;

class FoundationControlsSubstate extends MusicBeatSubstate {
	var rebinding:Bool = false;
	var currentlyRebinding:String = "";
	var altRebind:Bool = false;

	var rebindingText:FlxText;

	var keys:Array<Array<String>> = [
		['Left', 'note_left'],
		['Down', 'note_down'],
		['Up', 'note_up'],
		['Right', 'note_right'],

		['Reset', 'reset'],
		['Accept', 'accept'],
		['Back', 'back'],
		['Pause', 'pause']
	];

	var rebindLabels:FlxTypedGroup<FlxText>;

	override function create() {
		super.create();

		rebindLabels = new FlxTypedGroup<FlxText>();

		var backBG = new FlxSprite(-50, -50).makeGraphic(FlxG.width*2, FlxG.height*2, FlxColor.BLACK);
		add(backBG);

		var bg = new FlxSprite().loadGraphic(Paths.image('menu/settings/settingsmenu'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scale.set(0.65, 0.65);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		add(rebindLabels);

		createButtonsAndShit();

		rebindingText = new FlxText(0, 550);
		rebindingText.setFormat(Paths.font('cour.ttf'), 48);
		rebindingText.text = "Rebinding...";
		rebindingText.visible = false;
		rebindingText.updateHitbox();
		rebindingText.screenCenter(X);
		add(rebindingText);
	}

	private function createButtonsAndShit() {
		var backButton:FButton = new FButton(250, 75, (f) -> leave());
		add(backButton);

		var backLabel:FlxText = new FlxText(280, 85);
		backLabel.text = "Back";
		backLabel.setFormat(Paths.font('cour.ttf'), 32);
		add(backLabel);
		
		createLabels();

		var i = 0;
		for (def in keys) {
			var rebindMain:FButton = new FButton(700, 150 + i * 50, rebind, def[1]);
			add(rebindMain);

			var rebindAlt:FButton = new FButton(850, 150 + i * 50, rebindAlt, def[1]);
			add(rebindAlt);

			i+=1;
		}
	}

	private function rebind(button:FButton) {
		rebindingText.visible = true;
		currentlyRebinding = button.name;
		altRebind = false;
		rebinding = true;
	}

	private function rebindAlt(button:FButton) {
		rebindingText.visible = true;
		currentlyRebinding = button.name;
		altRebind = true;
		rebinding = true;
	}

	private function createLabels() {
		var i = 0;
		for (def in keys) {
			var key:String = def[0];
			var binds:Array<FlxKey> = ClientPrefs.keyBinds.get(def[1]);

			var mainBind:String = binds[0].toString();
			var altBind:String = binds[1].toString();

			if (altBind == null) altBind = "";

			var keyLabel:FlxText = new FlxText(250, 150 + 5 + i * 50);
			keyLabel.text = '$key ($mainBind' + (altBind != "" ? ', $altBind' : "") + ')';
			keyLabel.setFormat(Paths.font('cour.ttf'), 24);
			rebindLabels.add(keyLabel);

			i += 1;
		}
	}

	private function leave() {
		ClientPrefs.reloadControls();
		close();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (!rebinding) {
			if (controls.BACK)
				leave();
		}
		else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				var keysArray:Array<FlxKey> = ClientPrefs.keyBinds.get(currentlyRebinding);
				keysArray[altRebind ? 1 : 0] = keyPressed;

				ClientPrefs.keyBinds.set(currentlyRebinding, keysArray);

				rebinding = false;

				rebindLabels.forEach((t) -> t.destroy());
				rebindLabels.clear();
				createLabels();

				rebindingText.visible = false;
			}
		}
	}
}