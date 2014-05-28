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

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _planet = new Planet(100,100,1);
            add(_planet);

            _hud = new FlxSprite(0,0);
            _hud.loadGraphic(ImgHud,false,false,640,480);
            add(_hud);

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
            _bubble.loadGraphic(ImgBubble,false,false,114,108);
            add(_bubble);
            _bubble.alpha = 0;

            _bubbletext = new FlxText(_bubble.x+5,_bubble.y+25,110,"");
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

            _hudTxt.text = "Money: " + _player._money.toString() + " PSD";
            _planetTraitText.text = _planet.current_trait;

            if(_planet.x > FlxG.width){
                _planet.resetPos(0,100);
            }
            if(_planet.x < 0){
                _planet.resetPos(FlxG.width,100);
            }

            if(!_planet._moving){
                debugText.text = "landed";
                _planetTraitText.text = _planet.current_status;
                _bubbletext.text = _player._yearsTraveled.toString() + " years traveled." + "\n" + _player._age.toString() + " years old.";
                _letter1.alpha = 1;
                _lettertext.alpha = 1;
                _bubble.alpha = 1;
                if(FlxG.keys.SPACE){
                    _planet._moving = true;
                    _player._money += 100;
                    _planet.scale.y = 1;
                    _planet.scale.x = 1;
                    _letter1.alpha = 0;
                    _lettertext.alpha = 0;
                    _bubble.alpha = 0;
                    _bubbletext.text = "";
                }
            } else {
                debugText.text = "flying";
            }
        }
    }
}
