package
{
    import org.flixel.*;

    public class Player extends FlxSprite{

        public function Player(x:int,y:int):void{
            super(x,y);
        }

        override public function update():void{
            super.update();
            borderCollide();

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