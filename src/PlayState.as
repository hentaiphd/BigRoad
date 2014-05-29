package
{
    import org.flixel.*;

    public class PlayState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;
        [Embed(source="../assets/box.png")] private var ImgBox:Class;
        [Embed(source="../assets/hud.png")] private var ImgHud:Class;
        [Embed(source="../assets/letter1.png")] private var ImgL1:Class;
        [Embed(source="../assets/bubble.png")] private var ImgBubble:Class;
        [Embed(source="../assets/FORCEDSQUARE.ttf", fontFamily="FORCEDSQUARE", embedAsCFF="false")] public var FontHud:String;

        public var _bg:FlxSprite;
        public var _planet:Planet;
        public var _planet2:Planet;
        public var _player:Player;
        public var _hudTxt:FlxText;
        public var checkLanding:Boolean = true;
        public var _box:FlxSprite = null;
        public var _hud:FlxSprite;
        public var debugText:FlxText;
        public var _planetTraitText:FlxText;
        public var _letter1:FlxSprite;
        public var _lettertext:FlxText;
        public var _bubble:FlxSprite;
        public var _bubbletext:FlxText;
        public var current_bubble_text:String = "";
        public var _earning:Number = 100;
        public var _instruction:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _planet = new Planet(100,100,1);
            add(_planet);

            _hud = new FlxSprite(0,0);
            _hud.loadGraphic(ImgHud,false,false,640,480);
            add(_hud);

            _instruction = new FlxText(150,200,500,"LEFT or RIGHT to fly.");
            _instruction.setFormat("FORCEDSQUARE",34,0xFFFFFFFF);
            add(_instruction);

            _letter1 = new FlxSprite(350,70);
            _letter1.loadGraphic(ImgL1,false,false,176,375);
            add(_letter1);
            _letter1.alpha = 0;

            _lettertext = new FlxText(360,250,170,"I miss you! Come home soon!");
            add(_lettertext);
            _lettertext.setFormat("FORCEDSQUARE",14,0xFFFFFFFF);
            _lettertext.alpha = 0;

            _player = new Player(FlxG.width-100,FlxG.height-55);
            add(_player);

            _bubble = new FlxSprite(_player.x-100,_player.y-100);
            _bubble.loadGraphic(ImgBubble,false,false,171,111);
            add(_bubble);

            _bubbletext = new FlxText(_bubble.x+23,_bubble.y+25,150,"");
            _bubbletext.setFormat("FORCEDSQUARE",14,0xFFFFFFFF);
            add(_bubbletext);

            _hudTxt = new FlxText(200,440,FlxG.width,"");
            add(_hudTxt);
            _hudTxt.setFormat("FORCEDSQUARE",18,0xFFFFFFFF);

            _planetTraitText = new FlxText(90,305,219,"");
            add(_planetTraitText);
            _planetTraitText.setFormat("FORCEDSQUARE",16,0xFFFFFFFF);

            _box = new FlxSprite(10,150);
            _box.loadGraphic(ImgBox,false,false,565,190);
            add(_box);
            _box.alpha = 0;

            debugText = new FlxText(10,10,100,"");
            add(debugText);

        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if(FlxG.keys.LEFT || FlxG.keys.RIGHT){
                _instruction.text = "";
            }

            _hudTxt.text = "Money: " + _player._money.toString() + " PSD";
            _planetTraitText.text = _planet.current_trait;

            if(_planet.x > 640){
                _planet.resetPos(10,100);
            }
            if(_planet.x < 0-(_planet.width*_planet.scale.x)){
                _planet.resetPos(FlxG.width-10,100);
            }

            if(!_planet._moving){
                debugText.text = "landed";
                _hudTxt.text = "PRESS SPACE TO TAKE OFF.";
                _planetTraitText.text = _planet.current_status;
                _bubbletext.text = _player._yearsTraveled.toString() + " years traveled." + "\n" + _player._age.toString() + " years old.";
                _letter1.alpha = 1;
                _lettertext.alpha = 1;
                _player._grounded = true;
                if(FlxG.keys.SPACE){
                    _planet._moving = true;
                    _player._money += _earning;
                    _planet.scale.y = 1;
                    _planet.scale.x = 1;
                    _letter1.alpha = 0;
                    _lettertext.alpha = 0;
                    _player._grounded = false;
                }
            } else {
                _hudTxt.text = "Money: " + _player._money.toString() + " PSD";
                debugText.text = "flying";
                _bubbletext.text = current_bubble_text;
                if(_player._age == 35){
                    _earning = 100;
                    _player._deduction = 50;
                    current_bubble_text = "The money is good. I'm glad I can send home my extra cash.";
                } else if(_player._age == 36){
                    _earning = 150;
                    _player._deduction = 100;
                    current_bubble_text = "It's been a few years since I went home... hope Alex is doing ok, like the letters say.";
                } else if(_player._age == 45){
                    _earning = 200;
                    _player._deduction = 150;
                    current_bubble_text = "Maybe Alex would like a letter from me... I don't know.";
                } else if(_player._age == 50){
                    _earning = 250;
                    _player._deduction = 200;
                    current_bubble_text = "Alex should be in college by now. Hope the money's helping.";
                } else if(_player._age == 55){
                    _earning = 300;
                    _player._deduction = 250;
                    current_bubble_text = "I don't even recognize Alex anymore... she's so tall.";
                } else if(_player._age == 60){
                    _earning = 350;
                    _player._deduction = 300;
                    current_bubble_text = "I could go back, just to say hello.";
                } else if(_player._age == 65){
                    _earning = 400;
                    _player._deduction = 350;
                    current_bubble_text = "I don't know how much longer I can do deliveries...";
                } else if(_player._age == 70){
                    _earning = 450;
                    _player._deduction = 400;
                    current_bubble_text = "Alex might not even be living on Wellar anymore.";
                } else if(_player._age == 80){
                    _earning = 500;
                    _player._deduction = 450;
                    current_bubble_text = "I don't think I ever even told Alex that I love her...";
                }
            }

            if(_player._money <= 0){
                FlxG.switchState(new OutroState());
            }

            if(timeSec == 100){
                FlxG.switchState(new OutroState());
            }
        }
    }
}
