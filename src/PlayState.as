package
{
    import org.flixel.*;

    public class PlayState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;

        public var _bg:FlxSprite;
        public var _planet:Planet;
        public var _player:Player;
        public var _hud:FlxText;

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

        }

        public function landing(player:Player, planet:Planet):void{
            //player lands
        }
    }
}
