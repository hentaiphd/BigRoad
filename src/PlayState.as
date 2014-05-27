package
{
    import org.flixel.*;

    public class PlayState extends FlxState
    {
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;

        public var _bg:FlxSprite;
        public var _planet:Planet;

        override public function create():void
        {
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _planet = new Planet(100,100);
            add(_planet);

        }

        override public function update():void
        {
            super.update();

        }
    }
}
