package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/person.png")] private var ImgPerson:Class;

        public var _money:Number = 0;
        public var _age:Number = 35;
        public var _yearsTraveled:Number = 0;
        public var _grounded:Boolean = false;
        public var timeSec:Number = 0;
        public var timeFrame:Number = 0;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPerson,false,false,17,55);
        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if(timeFrame%500 == 0){
                _age++;
                _yearsTraveled++;
            }
            if(timeFrame%250 == 0){
                _money -= 10;
            }

        }
    }
}