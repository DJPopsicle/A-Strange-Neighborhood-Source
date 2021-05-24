package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var dialogTransition:FlxSprite;
	var dialogBG:FlxSprite;
	var curAnim:String = '';
	var cutsceneImage:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case ('senpai'):
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		cutsceneImage = new FlxSprite(0, 0);
		cutsceneImage.visible = false;
		add(cutsceneImage);	


		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'chilly-sleepy':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/chilly-sleepy/dialogueBox-normal');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

			case 'wake-down':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/wake-down/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				
			case 'sinner-sleeper':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/sinner-sleeper/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				
			case 'fekemy':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/fekemy/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				
			case 'pop-scare':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/pop-scare/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

			case 'lusturious-lyrica':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/lusturious-lyrica/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				
			case 'terminal-heartbeat':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('Custom Dialogues/terminal-heartbeat/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);

		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case ('senpai' | 'roses' | 'thorns'):
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;


				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case ('fekemy'):
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/fekemy/senpaiPortrait');
				//portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/fekemy/bfPortrait');
				//portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'wake-down':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/wake-down/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/wake-down/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'chilly-sleepy':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/chilly-sleepy/aergiePortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/chilly-sleepy/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'sinner-sleeper':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/sinner-sleeper/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/sinner-sleeper/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'pop-scare':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/pop-scare/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/pop-scare/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'lusturious-lyrica':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/lusturious-lyrica/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/lusturious-lyrica/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
			case 'terminal-heartbeat':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('Custom Dialogues/terminal-heartbeat/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('Custom Dialogues/terminal-heartbeat/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		}
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('Custom Dialogues/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}

			// case "effect":
			// 	switch(curAnim){
			// 		case "hidden":
			// 			swagDialogue.visible = false;
			// 			dropText.visible = false;
			// 			box.visible = false;
			// 			setDialogue = true;
			// 			swagDialogue.resetText("");
			// 		default:
			// 			effectQue.push(curAnim);
			// 			effectParamQue.push(dialogueList[0]);
			// 			skipDialogue = true;
			// 	}
			case "bg":
				switch(curAnim){
					case "hide":
						cutsceneImage.visible = false;
					default:
						cutsceneImage.visible = true;
						cutsceneImage.loadGraphic(Paths.image("assets/dialogue/images/bg/" + curAnim + ".png"));
				}
			case "sound":
				FlxG.sound.play(Paths.sound("assets/dialogue/sounds/" + curAnim + ".ogg"));
			case "music":
				switch(curAnim){
					case "stop":
						FlxG.sound.music.stop();
					case "fadeIn":
						FlxG.sound.music.fadeIn(1.5, 0, Std.parseFloat(dialogueList[0]));
					case "fadeOut":
						FlxG.sound.music.fadeOut(1.5, 0);
					default:
						FlxG.sound.playMusic(Paths.sound("assets/dialogue/music/" + curAnim + ".ogg"), Std.parseFloat(dialogueList[0]));
				}
		}
	}

	// if(!skipDialogue){
	// 	if(!setDialogue){
	// 		swagDialogue.resetText(dialogueList[0]);
	// 	}

	// 	swagDialogue.start(0.04, true);
	// }
	// else{

	// 	dialogueList.remove(dialogueList[0]);
	// 	startDialogue();
		
	// }

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	// function runEffectsQue(){
	
	// 	for(i in 0...effectQue.length){

	// 		switch(effectQue[i]){

	// 			case "fadeOut":
	// 				effectFadeOut(Std.parseFloat(effectParamQue[i]));
	// 			case "fadeIn":
	// 				effectFadeIn(Std.parseFloat(effectParamQue[i]));
	// 			case "exitStageLeft":
	// 				effectExitStageLeft(Std.parseFloat(effectParamQue[i]));
	// 			case "exitStageRight":
	// 				effectExitStageRight(Std.parseFloat(effectParamQue[i]));
	// 			case "enterStageLeft":
	// 				effectEnterStageLeft(Std.parseFloat(effectParamQue[i]));
	// 			case "enterStageRight":
	// 				effectEnterStageRight(Std.parseFloat(effectParamQue[i]));
	// 			case "rightSide":
	// 				effectFlipRight();
	// 			case "flip":
	// 				effectFlipDirection();
	// 			case "toLeft":
	// 				effectToLeft();
	// 			case "toRight":
	// 				effectToRight();
	// 			//case "shake":
	// 				//effectShake(Std.parseFloat(effectParamQue[i]));
	// 			default:

	// 		}

	// 	}

	// 	effectQue = [""];
	// 	effectParamQue = [""];

	// }

	// function hideAll():Void{
	// 	portraitBF.hide();
	// 	portraitGF.hide();
	// 	portraitDAD.hide();
	// 	portraitSPOOKY.hide();
	// 	portraitMONSTER.hide();
	// 	portraitPICO.hide();
	// }

	// function effectFadeOut(?time:Float = 1):Void{
	// 	portraitBF.effectFadeOut(time);
	// 	portraitGF.effectFadeOut(time);
	// 	portraitDAD.effectFadeOut(time);
	// 	portraitSPOOKY.effectFadeOut(time);
	// 	portraitMONSTER.effectFadeOut(time);
	// 	portraitPICO.effectFadeOut(time);
	// }

	// function effectFadeIn(?time:Float = 1):Void{
	// 	portraitBF.effectFadeIn(time);
	// 	portraitGF.effectFadeIn(time);
	// 	portraitDAD.effectFadeIn(time);
	// 	portraitSPOOKY.effectFadeIn(time);
	// 	portraitMONSTER.effectFadeIn(time);
	// 	portraitPICO.effectFadeIn(time);
	// }

	// function effectExitStageLeft(?time:Float = 1):Void{
	// 	portraitBF.effectExitStageLeft(time);
	// 	portraitGF.effectExitStageLeft(time);
	// 	portraitDAD.effectExitStageLeft(time);
	// 	portraitSPOOKY.effectExitStageLeft(time);
	// 	portraitMONSTER.effectExitStageLeft(time);
	// 	portraitPICO.effectExitStageLeft(time);
	// }

	// function effectExitStageRight(?time:Float = 1):Void{
	// 	portraitBF.effectExitStageRight(time);
	// 	portraitGF.effectExitStageRight(time);
	// 	portraitDAD.effectExitStageRight(time);
	// 	portraitSPOOKY.effectExitStageRight(time);
	// 	portraitMONSTER.effectExitStageRight(time);
	// 	portraitPICO.effectExitStageRight(time);
	// }

	// function effectFlipRight(){
	// 	portraitBF.effectFlipRight();
	// 	portraitGF.effectFlipRight();
	// 	portraitDAD.effectFlipRight();
	// 	portraitSPOOKY.effectFlipRight();
	// 	portraitMONSTER.effectFlipRight();
	// 	portraitPICO.effectFlipRight();
	// 	box.flipX = false;
	// }
	
	// function effectFlipDirection(){
	// 	portraitBF.effectFlipDirection();
	// 	portraitGF.effectFlipDirection();
	// 	portraitDAD.effectFlipDirection();
	// 	portraitSPOOKY.effectFlipDirection();
	// 	portraitMONSTER.effectFlipDirection();
	// 	portraitPICO.effectFlipDirection();
	// }

	// function effectEnterStageLeft(?time:Float = 1){
	// 	portraitBF.effectEnterStageLeft(time);
	// 	portraitGF.effectEnterStageLeft(time);
	// 	portraitDAD.effectEnterStageLeft(time);
	// 	portraitSPOOKY.effectEnterStageLeft(time);
	// 	portraitMONSTER.effectEnterStageLeft(time);
	// 	portraitPICO.effectEnterStageLeft(time);
	// }

	// function effectEnterStageRight(?time:Float = 1){
	// 	portraitBF.effectEnterStageRight(time);
	// 	portraitGF.effectEnterStageRight(time);
	// 	portraitDAD.effectEnterStageRight(time);
	// 	portraitSPOOKY.effectEnterStageRight(time);
	// 	portraitMONSTER.effectEnterStageRight(time);
	// 	portraitPICO.effectEnterStageRight(time);
	// }

	// function effectToRight(?time:Float = 1){
	// 	portraitBF.effectToRight(time);
	// 	portraitGF.effectToRight(time);
	// 	portraitDAD.effectToRight(time);
	// 	portraitSPOOKY.effectToRight(time);
	// 	portraitMONSTER.effectToRight(time);
	// 	portraitPICO.effectToRight(time);
	// 	box.flipX = false;
	// }

	// function effectToLeft(?time:Float = 1){
	// 	portraitBF.effectToLeft(time);
	// 	portraitGF.effectToLeft(time);
	// 	portraitDAD.effectToLeft(time);
	// 	portraitSPOOKY.effectToLeft(time);
	// 	portraitMONSTER.effectToLeft(time);
	// 	portraitPICO.effectToLeft(time);
	// }

	/*function effectShake(?time:Float = 0.5){
		portraitBF.effectShake(time);
		portraitGF.effectShake(time);
		portraitDAD.effectShake(time);
		portraitSPOOKY.effectShake(time);
		portraitMONSTER.effectShake(time);
		portraitPICO.effectShake(time);
		portraitDARNELL.effectShake(time);
		portraitNENE.effectShake(time);
	}*/
}
