package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/title_screen3.png")] private var ImgBg:Class;

        public var _bg:FlxSprite;

        override public function create():void{

            FlxG.mouse.hide();

            var _screen:ScreenManager = ScreenManager.getInstance();

            _bg = new FlxSprite(_screen.zero_point.x,_screen.zero_point.y);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _screen.addLetterbox();
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new IntroState());
            }
        }
    }
}
