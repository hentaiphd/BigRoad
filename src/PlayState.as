package
{
    import org.flixel.*;

    public class PlayState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;
        [Embed(source="../assets/box.png")] private var ImgBox:Class;

        public var _bg:FlxSprite;
        public var _planet:Planet;
        public var _player:Player;
        public var _hud:FlxText;
        public var checkLanding:Boolean = true;
        public var _box:FlxSprite = null;

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _planet = new Planet(100,100);
            add(_planet);

            _player = new Player(200,200);
            add(_player);

            _hud = new FlxText(10,10,FlxG.width,"");
            add(_hud);
            _hud.size = 12;

        }

        override public function update():void{
            super.update();

            _hud.text = "Money: " + _player._money.toString() + " PSD" + "\nYou have been traveling for " + _player._yearsTraveled.toString() + " years." + "\nYou are " + _player._age.toString() + " years old.";

            if(checkLanding){
                _player._grounded = false;
                _planet._moving = true;
                FlxG.overlap(_player,_planet,landingCollision);
            } else {
                if(_box == null){
                    _box = new FlxSprite(30,150);
                    _box.loadGraphic(ImgBox,false,false,565,190);
                    add(_box);
                }
                if(FlxG.keys.SPACE){
                    if(_box != null){
                        _box.destroy();
                    }
                    landingLock();
                }
            }
        }

        public function landingCollision(player:Player, planet:Planet):void{
            player._grounded = true;
            planet._moving = false;
            checkLanding = false;
        }

        public function landingLock():void{
            checkLanding = true;
        }
    }
}
