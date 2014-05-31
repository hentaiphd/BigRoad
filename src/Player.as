package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/ship.png")] private var ImgPlayer:Class;

        public var _money:Number = 500;
        public var _age:Number = 35;
        public var _yearsTraveled:Number = 0;
        public var _grounded:Boolean = false;
        public var _deduction:Number = 100;
        public var timeSec:Number = 0;
        public var timeFrame:Number = 0;
        public var deduct:Boolean = false;
        public var deductcounter:Number = 0;
        public var _angle:Number = 0;
        public var newPos:DHPoint;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPlayer,false,false,17,42);
            newPos = new DHPoint(x,y);
            this.scale.y = -1;
        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            this.x = newPos.x;
            this.y = newPos.y;

            this.angle = _angle*(180/Math.PI)*-1;
        }

        public function calcPosition(p:Planet):void{
            newPos = new DHPoint(p._radius*Math.sin(_angle),p._radius*Math.cos(_angle));
            newPos.x += p.x+10;
            newPos.y += p.y+5;
        }
    }
}