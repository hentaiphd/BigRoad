package
{
    import org.flixel.*;

    public class PlayState extends FlxState{
        [Embed(source="../assets/bg.png")] private var ImgBg:Class;
        [Embed(source="../assets/FORCEDSQUARE.ttf", fontFamily="FORCEDSQUARE", embedAsCFF="false")] public var FontHud:String;

        public var _bg:FlxSprite;
        public var debugText:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            debugText = new FlxText(10,10,100,"");
            add(debugText);
        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }
        }
    }
}
