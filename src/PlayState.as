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
        public var current_bubble_text:String = "";
        public var _earning:Number = 100;
        public var _instruction:FlxText;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;

        override public function create():void{
            _bg = new FlxSprite(0,0);
            _bg.loadGraphic(ImgBg,false,false,640,480);
            add(_bg);

            _planet = new Planet(100,100,1);
            add(_planet);

            _player = new Player(100,100);
            add(_player);

            _instruction = new FlxText(150,200,500,"LEFT or RIGHT to fly.");
            _instruction.setFormat("FORCEDSQUARE",34,0xFFFFFFFF);
            add(_instruction);

            debugText = new FlxText(10,10,100,"");
            add(debugText);

        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if(FlxG.keys.LEFT){
                _player._angle += (Math.PI*2)/100;
                _player.calcPosition(_planet);
            }else if(FlxG.keys.RIGHT){
                _player._angle -= (Math.PI*2)/100;
                _player.calcPosition(_planet);
            }
        }
    }
}
