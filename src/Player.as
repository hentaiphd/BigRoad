package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/ship.png")] private var ImgShip:Class;

        public var _money:Number = 0;
        public var _age:Number = 35;
        public var _yearsTraveled:Number = 0;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgShip,false,false,17,42);
        }

        override public function update():void{
            super.update();
            borderCollide();

            if(FlxG.keys.LEFT){
                this.x--;
            } else if(FlxG.keys.RIGHT){
                this.x++;
            }

        }

        public function borderCollide():void{
            if(x >= FlxG.width - width)
                x = FlxG.width - width;
            if(this.x <= 0)
                this.x = 0;
            if(this.y >= FlxG.height - height)
                this.y = FlxG.height - height;
            if(this.y <= 0)
                this.y = 0;
        }
    }
}