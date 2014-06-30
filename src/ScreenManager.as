package {
    import org.flixel.*;

    import flash.display.StageDisplayState;

    public class ScreenManager {
        public var screenWidth:Number, screenHeight:Number, aspect_ratio:Number;
        public var applet_dimensions:FlxPoint, letterbox_dimensions:FlxPoint, zero_point:FlxPoint;

        public var letterbox1:FlxSprite = null, letterbox2:FlxSprite = null, letterbox3:FlxSprite = null, letterbox4:FlxSprite = null;

        public static var _instance:ScreenManager = null;

        public function ScreenManager() {
            FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
            applet_dimensions = new FlxPoint(640/2, 480/2);
            screenWidth = FlxG.stage.fullScreenWidth;
            screenHeight = FlxG.stage.fullScreenHeight;
            aspect_ratio = applet_dimensions.x/applet_dimensions.y;
            letterbox_dimensions = new FlxPoint((screenWidth - screenWidth/aspect_ratio)/2,
                                                (screenHeight - screenHeight/aspect_ratio)/2);
            zero_point = new FlxPoint((letterbox_dimensions.x),
                                      (letterbox_dimensions.y));
        }

        public function addLetterbox():void {
            var _color:uint = 0xff000000;

            letterbox1 = new FlxSprite(0, 0);
            letterbox1.makeGraphic(screenWidth+500, zero_point.y, _color);
            FlxG.state.add(letterbox1);

            letterbox2 = new FlxSprite(0, zero_point.y + applet_dimensions.y);
            letterbox2.makeGraphic(screenWidth, screenHeight - (zero_point.y + applet_dimensions.y), _color);
            FlxG.state.add(letterbox2);

            letterbox3 = new FlxSprite(0, 0);
            letterbox3.makeGraphic(zero_point.x, screenHeight, _color);
            FlxG.state.add(letterbox3);

            letterbox4 = new FlxSprite(zero_point.x + applet_dimensions.x, 0);
            letterbox4.makeGraphic(screenWidth - (zero_point.x + applet_dimensions.x), screenHeight, _color);
            FlxG.state.add(letterbox4);
        }

        public static function getInstance():ScreenManager {
            if (_instance == null) {
                _instance = new ScreenManager();
            }
            return _instance;
        }
    }
}
