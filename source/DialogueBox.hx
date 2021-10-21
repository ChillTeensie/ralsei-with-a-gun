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

	var portraitSusie:FlxSprite;
	var portraitKris:FlxSprite;
	var portraitRalsei:FlxSprite;
	var portraitBf:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 1;
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
			default:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('bubble','ralsei');
				box.animation.addByPrefix('normalOpen', 'Symbol 1', 24, false);
				box.animation.addByPrefix('normal', 'Symbol 1', 24);
				box.antialiasing = false;
				box.x = 47.6;
				box.y = 365.9;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);
		
		portraitRalsei = new FlxSprite(141.4, 424.6);
		portraitRalsei.frames = Paths.getSparrowAtlas('portaits','ralsei');
		portraitRalsei.animation.addByPrefix('enter', 'ralsei instance 1', 24, false);
		portraitRalsei.updateHitbox();
		portraitRalsei.scrollFactor.set();
		add(portraitRalsei);
		portraitRalsei.antialiasing = false;
		portraitRalsei.visible = false;
		
		portraitKris = new FlxSprite(141.4, 409.55);
		portraitKris.frames = Paths.getSparrowAtlas('portaits','ralsei');
		portraitKris.animation.addByPrefix('enter', 'kris instance 1', 24, false);
		portraitKris.updateHitbox();
		portraitKris.scrollFactor.set();
		add(portraitKris);
		portraitKris.antialiasing = false;
		portraitKris.visible = false;
		
		portraitSusie = new FlxSprite(141.4, 409.55);
		portraitSusie.frames = Paths.getSparrowAtlas('portaits','ralsei');
		portraitSusie.animation.addByPrefix('enter', 'susie instance 1', 24, false);
		portraitSusie.updateHitbox();
		portraitSusie.scrollFactor.set();
		add(portraitSusie);
		portraitSusie.antialiasing = false;
		portraitSusie.visible = false;

		portraitBf = new FlxSprite(141.4, 409.55);
		portraitBf.frames = Paths.getSparrowAtlas('portaits','ralsei');
		portraitBf.animation.addByPrefix('enter', 'boyfriend instance 1', 24, false);
		portraitBf.updateHitbox();
		portraitBf.scrollFactor.set();
		add(portraitBf);
		portraitBf.antialiasing = false;
		portraitBf.visible = false;

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(401.6, 427.6, Std.int(FlxG.width * 0.6), "", 48);
		dropText.font = Paths.font('dialogue.otf');
		dropText.color = 0xFF38006B;
		add(dropText);

		swagDialogue = new FlxTypeText(399.35, 425.35, Std.int(FlxG.width * 0.6), "", 48);
		swagDialogue.font = Paths.font('dialogue.otf');
		swagDialogue.color = 0xFFFFFFFF;
		add(swagDialogue);
		
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitRalsei.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitRalsei.color = FlxColor.BLACK;
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
		switch(curCharacter)
		{
			case 'kris':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('kris','ralsei'), 4)];
			case 'susie':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('susie','ralsei'), 2)];
			case 'ralsei':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ralsei','ralsei'), 2)];
			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf','ralsei'), 1.2)];
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
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
			case 'kris':
				portraitBf.visible = false;
				portraitRalsei.visible = false;
				portraitSusie.visible = false;

				if (!portraitKris.visible)
				{
					portraitKris.visible = true;
					portraitKris.animation.play('enter');
				}
			case 'susie':
				portraitBf.visible = false;
				portraitRalsei.visible = false;
				portraitKris.visible = false;

				if (!portraitSusie.visible)
				{
					portraitSusie.visible = true;
					portraitSusie.animation.play('enter');
				}
			case 'ralsei':
				portraitBf.visible = false;
				portraitSusie.visible = false;
				portraitKris.visible = false;

				if (!portraitRalsei.visible)
				{
					portraitRalsei.visible = true;
					portraitRalsei.animation.play('enter');
				}
			case 'bf':
				portraitRalsei.visible = false;
				portraitSusie.visible = false;
				portraitKris.visible = false;

				if (!portraitBf.visible)
				{
					portraitBf.visible = true;
					portraitBf.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
