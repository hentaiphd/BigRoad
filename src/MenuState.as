package{
    import org.flixel.*;

    public class MenuState extends FlxState{
        [Embed(source="../assets/title_screen3.png")] private var ImgBg:Class;

        public var _bg:FlxSprite;

        override public function create():void{
            FlxG.mouse.hide();

            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);
        }

        override public function update():void{
            super.update();

            if(FlxG.mouse.pressed()){
                FlxG.switchState(new OutroState());
            }
        }
    }
}
