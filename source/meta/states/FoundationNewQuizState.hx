package meta.states;

import gameObjects.PsychVideoSprite;
import gameObjects.shader.FunkinShader.FunkinRuntimeShader;
import flixel.addons.display.FlxRuntimeShader;
import flixel.input.mouse.FlxMouseEvent;
import haxe.Json;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;

class FoundationNewQuizState extends FlxState
{
	var atlas:FlxAtlasFrames;
	var quizData:QuizData;

	var crtCamera:FlxCamera;
	var tvCamera:FlxCamera;
	var cutsceneCamera:FlxCamera;

	var screen:FlxSprite;
	var screenOverlay:FlxSprite;
	var sectionText:FlxText;
	var questionText:FlxText;
	var questionImage:FlxSprite;

	var answerButtons:Array<FlxSprite> = [];
	var answers:Array<FlxText> = [];

	var curSection:Int = 1;
	var curQuestion:Int = 0;

	var curSectionData:QuizSection;
	var curQuestionData:QuizQuestion;

	var layers:Array<FlxSound> = [];
	var curLayer:FlxSound;

	var twofivetwoone:Bool = false;

	var blackout:FlxSprite;
	var heart:FlxSprite;
	var endingCutscene:PsychVideoSprite;
	// var endingCutsceneSound:FlxSound;
	var endingSound:FlxSound;

	var answerTimer:FlxTimer;

	override function create()
	{

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.updatePresence(null, "???");
		#end
		
		super.create();
		Paths.forceCaching = false;

		FlxG.mouse.visible = true;

		FlxG.sound.music.stop();

		endingSound = FlxG.sound.load(Paths.sound("quiz/itscoming"));

		FlxG.save.data.foundation.doneQuiz = true;
		FlxG.save.flush();

		for (i in 0...4)
		{
			var layer:FlxSound = FlxG.sound.load(Paths.music("quiz/mathPhase" + Std.string(i + 1)), 0, true);
			layer.play();
			layers.push(layer);
		}

		curLayer = layers[0];
		curLayer.fadeIn();

		Conductor.changeBPM(100);

		crtCamera = new FlxCamera();
		crtCamera.bgColor.alpha = 0;
		FlxG.cameras.add(crtCamera, false);

		tvCamera = new FlxCamera();
		tvCamera.bgColor.alpha = 0;
		FlxG.cameras.add(tvCamera, false);

		cutsceneCamera = new FlxCamera();
		// tvCamera.bgColor.alpha = 0;

		if (ClientPrefs.shaders)
		{
			var crtShader:FunkinRuntimeShader = null;
			try
			{
				crtShader = new FunkinRuntimeShader(Paths.getContent(Paths.shaderFragment("crtWarp")));
				crtShader.setFloat("warp", 1.5);
				crtShader.setFloat("scan", 0.0);
			}
			catch (e:Dynamic)
			{
				trace("Shader compilation error:" + e.message);
				crtShader = new FunkinRuntimeShader();
			}

			ExUtils.addShader(crtShader, crtCamera);
		}

		quizData = Json.parse(Paths.getTextFromFile('data/boringshit.json'));
		atlas = Paths.getSparrowAtlas("menu/quiz/endingquiz");

		sectionText = new FlxText(0, 50, 800);
		sectionText.antialiasing = ClientPrefs.globalAntialiasing;
		sectionText.cameras = [crtCamera];
		sectionText.setFormat(Paths.font("cour.ttf"), 36, FlxColor.WHITE, CENTER);
		add(sectionText);

		questionText = new FlxText(0, 150, 800);
		questionText.antialiasing = ClientPrefs.globalAntialiasing;
		questionText.cameras = [crtCamera];
		questionText.setFormat(Paths.font("cour.ttf"), 24, FlxColor.WHITE, CENTER);
		add(questionText);

		questionImage = new FlxSprite();
		questionImage.antialiasing = ClientPrefs.globalAntialiasing;
		questionImage.cameras = [crtCamera];
		questionImage.scale.set(0.5, 0.5);
		questionImage.screenCenter();
		questionImage.visible = false;
		add(questionImage);

		for (i in 0...4)
		{
			var answer:FlxSprite = new FlxSprite(0, 500 + (i * 40));
			answer.antialiasing = ClientPrefs.globalAntialiasing;
			answer.cameras = [crtCamera];
			answer.frames = atlas;
			answer.animation.addByPrefix("idle", "textbar");
			answer.animation.play("idle");
			answer.scale.set(0.75, 0.75);
			answer.updateHitbox();
			answer.screenCenter(X);
			add(answer);
			answerButtons.push(answer);

			FlxMouseEvent.add(answer, (s) ->
			{
				if (twofivetwoone)
					return;
				nextQuestion();
			}, null, (s) ->
				{
					if (twofivetwoone)
						return;
					s.color = FlxColor.GRAY;
				}, (s) ->
				{
					if (twofivetwoone)
						return;
					s.color = FlxColor.WHITE;
				});

			var answerText:FlxText = new FlxText(answer.x, answer.y + 5);
			answerText.antialiasing = ClientPrefs.globalAntialiasing;
			answerText.cameras = [crtCamera];
			answerText.setFormat(Paths.font("cour.ttf"), 24, FlxColor.BLACK, CENTER);
			add(answerText);
			answers.push(answerText);
		}

		heart = new FlxSprite();
		heart.antialiasing = ClientPrefs.globalAntialiasing;
		heart.cameras = [crtCamera];
		heart.frames = Paths.getSparrowAtlas('menu/quiz/heart2521');
		heart.animation.addByPrefix("meow", "heart", 24, false);
		heart.animation.play("meow");
		heart.scale.set(0.35, 0.35);
		heart.updateHitbox();
		heart.screenCenter();
		heart.x -= 10;
		heart.y -= 25;
		heart.visible = false;
		heart.animation.finishCallback = (anim) -> heart.visible = false;
		add(heart);

		screenOverlay = new FlxSprite().loadGraphic(Paths.image("menu/screenOverlay"));
		screenOverlay.antialiasing = ClientPrefs.globalAntialiasing;
		screenOverlay.cameras = [tvCamera];
		screenOverlay.screenCenter();
		add(screenOverlay);

		screen = new FlxSprite();
		screen.antialiasing = ClientPrefs.globalAntialiasing;
		screen.cameras = [tvCamera];
		screen.frames = atlas;
		screen.animation.addByPrefix("idle", "tv", 24);
		screen.animation.play("idle");
		screen.scale.set(0.75, 0.75);
		screen.updateHitbox();
		screen.screenCenter();
		add(screen);

		blackout = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackout.cameras = [tvCamera];
		add(blackout);
		FlxTween.tween(blackout, {"alpha": 0}, 0.5);

		endingCutscene = new PsychVideoSprite();
		endingCutscene.cameras = [cutsceneCamera];
		endingCutscene.addCallback('onFormat', () ->
		{
			endingCutscene.scale.set(0.7, 0.7);
			endingCutscene.updateHitbox();
			endingCutscene.screenCenter();
		});
		endingCutscene.addCallback('onEnd', () ->
		{
			FoundationMainMenuState.playMusic = false;
			FlxG.switchState(new meta.states.FoundationMainMenuState());
			endingCutscene.kill();
			// Sys.exit(0); // proved to be too confusing for players -xeight
		});
		endingCutscene.load(Paths.video("QuizEnding"));
		endingCutscene.antialiasing = ClientPrefs.globalAntialiasing;
		add(endingCutscene);

		// endingCutsceneSound = FlxG.sound.load(Paths.sound("quiz/endSFX"));

		nextQuestion();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (twofivetwoone)
			return;

		if (FlxG.mouse.justPressed)
			FlxG.sound.play(Paths.sound("desktop/sClick"), 2);
		if (FlxG.keys.justPressed.ANY)
		{
			if (FlxG.keys.justPressed.SPACE)
				FlxG.sound.play(Paths.sound("desktop/sKeyboardSpace"));
			else
				FlxG.sound.play(Paths.sound("desktop/sKeyboard" + Std.string(FlxG.random.int(0, 4))));
		}
	}

	function nextQuestion()
	{
		curQuestion += 1;
		if (curQuestion > 6 && curSection != 4)
		{
			curSection += 1;
			curQuestion = 1;

			curLayer.fadeOut(1);
			curLayer = layers[curSection - 1];
			curLayer.fadeIn();
		}

		curSectionData = quizData.sections[curSection - 1];
		curQuestionData = curSectionData.questions[curQuestion - 1];

		if (Reflect.getProperty(curQuestionData, "thistheone") != null)
			twofivetwoone = true;

		questionImage.visible = false;

		for (i in 0...4)
		{
			answers[i].visible = false;
			answerButtons[i].visible = false;
		};

		sectionText.visible = false;
		questionText.visible = false;

		new FlxTimer().start(0.75, (t) ->
		{
			sectionText.visible = true;
			sectionText.text = curSectionData.name;
			sectionText.screenCenter(X);
		});

		new FlxTimer().start(0.85, (t) ->
		{
			questionText.visible = true;
			questionText.text = curQuestionData.title;
			questionText.screenCenter(X);
		});

		if (answerTimer != null && answerTimer.active)
			answerTimer.cancelTmr();

		answerTimer = new FlxTimer().start(1, (t) ->
		{
			for (i in 0...4)
			{
				new FlxTimer().start(i * 0.05, (t2) ->
				{
					answers[i].visible = true;
					answerButtons[i].visible = true;

					answers[i].text = curQuestionData.answers[i];
					answers[i].screenCenter(X);

					answerButtons[i].color = FlxColor.WHITE;
				});
			};
		});

		new FlxTimer().start(1.5, (t) ->
		{
			if (curQuestionData.image != null)
			{
				questionImage.loadGraphic(Paths.image("menu/quiz/pics/" + curQuestionData.image));
				questionImage.screenCenter();
				questionImage.y -= 25;
				questionImage.visible = true;
			}

			if (twofivetwoone)
			{
				curLayer.stop();
				endingSound.play();

				new FlxTimer().start(3, (timer) ->
				{
                    FlxG.mouse.visible = false;
					endingSound.stop();
					FlxG.cameras.add(cutsceneCamera, false);
					endingCutscene.play();
					// for (i in 0...4) {
					//     FlxTween.tween(answers[i], {"alpha": 0}, 1);
					//     FlxTween.tween(answerButtons[i], {"alpha": 0}, 1);

					//     FlxTween.tween(crtCamera, {"zoom": 4}, 20);
					//     FlxTween.tween(tvCamera, {"zoom": 4}, 20);
					// };

					// heart.visible = true;
					// heart.animation.play("meow", true);

					// new FlxTimer().start(0.4, (t2) -> {
					//     t2.start(1, (t3) -> {
					//         heart.visible = true;
					//         heart.animation.play("meow", true);
					//     }, 4);
					// });

					// timer.start(5, (timer) -> {
					//     endingSound.stop();

					//     // endingCutsceneSound.play();
					// });
				});
			}
		});
	}
}

typedef QuizData =
{
	var sections:Array<QuizSection>;
}

typedef QuizSection =
{
	var name:String;
	var questions:Array<QuizQuestion>;
}

typedef QuizQuestion =
{
	var title:String;
	var answers:Array<String>;
	var image:Null<String>;
}
