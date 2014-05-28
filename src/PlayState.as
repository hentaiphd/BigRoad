package
{
    import org.flixel.*;

    public class PlayState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;
        [Embed(source="../assets/box.png")] private var ImgBox:Class;
        [Embed(source="../assets/hud.png")] private var ImgHud:Class;
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

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _planet = new Planet(100,100,1);
            add(_planet);

            _player = new Player(200,200);
            add(_player);

            _hud = new FlxSprite(0,0);
            _hud.loadGraphic(ImgHud,false,false,640,480);
            add(_hud);

            _hudTxt = new FlxText(200,440,FlxG.width,"");
            add(_hudTxt);
            _hudTxt.setFormat("FORCEDSQUARE",18,0xFFFFFFFF);

            _planetTraitText = new FlxText(90,305,219,"");
            add(_planetTraitText);
            _planetTraitText.setFormat("FORCEDSQUARE",14,0xFFFFFFFF);

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
                _planetTraitText.text = _planet.current_status + "\nYou have been traveling for " + _player._yearsTraveled.toString() + " years." + "\nYou are " + _player._age.toString() + " years old.";
                if(FlxG.keys.SPACE){
                    _planet._moving = true;
                    _player._money += 100;
                    _planet.scale.y = 1;
                    _planet.scale.x = 1;
                }
            } else {
                debugText.text = "flying";
            }
        }
    }
}
