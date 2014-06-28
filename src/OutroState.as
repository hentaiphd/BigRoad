package{
    import org.flixel.*;

    public class OutroState extends FlxState{
        [Embed(source="../assets/end1screenblank.png")] private var ImgBg:Class;

        public var bg:FlxSprite;
        public var startTime:Date;
        public var score_text:FlxText;
        public var plushies_delivered:Number = 0;

        public var _screen:ScreenManager;

        public function OutroState(plushies:Number = 0):void{
            plushies_delivered = plushies;
        }

        override public function create():void{
            _screen = ScreenManager.getInstance();

            FlxG.mouse.hide();
            startTime = new Date();

            bg = new FlxSprite(_screen.zero_point.x, _screen.zero_point.y);
            bg.loadGraphic(ImgBg,false,false,320,240);
            add(bg);

            score_text = new FlxText(_screen.zero_point.x+178,_screen.zero_point.y+19,60,plushies_delivered.toString());
            score_text.color = 0xff85F348;
            score_text.size = 8;
            add(score_text);

            _screen.addLetterbox();
        }

        override public function update():void{
            super.update();

            if(new Date().valueOf() - startTime.valueOf() > 5000){
                FlxG.switchState(new OutroGirlsState());
            }
        }
    }
}
