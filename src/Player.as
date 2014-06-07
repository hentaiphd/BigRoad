package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/ship.png")] private var ImgPlayer:Class;

        public var timeSec:Number = 0;
        public var timeFrame:Number = 0;

        public var _debugText:FlxText;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPlayer,false,false,17,42);
            this.scale.y = -1;

            this._debugText = new FlxText(200, 200, FlxG.width, "");
            this._debugText.size = 14;
            FlxG.state.add(_debugText);
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
